{{ 
   config(
      materialized='ephemeral'
   ) 
}}

WITH browsing_base AS (
    SELECT  
        session_id,
        user_id,
        MIN(created_at) AS browsing_date
    FROM 
        {{ ref('stg_ecommerce__events') }}
    WHERE 
        event_type = 'purchase'
    GROUP BY 
        session_id, user_id
),

ordering_base AS (
    SELECT 
        order_id,
        user_id,
        status,
        created_at AS order_date
    FROM 
        {{ ref('stg_ecommerce__orders') }}
),

checkout_base AS (
    SELECT 
        order_id,
        MAX(created_at) AS checkout_date
    FROM 
        {{ ref('stg_ecommerce__order_items') }}
    GROUP BY 
        order_id
)
-- Combine all stages into a final table
SELECT 
    ob.order_id,
    bb.browsing_date AS browsing,
    ob.order_date AS submitted,
    cb.checkout_date AS checkout
FROM 
    ordering_base AS ob
JOIN 
    browsing_base AS bb ON ob.user_id = bb.user_id
    AND ob.order_date BETWEEN bb.browsing_date AND bb.browsing_date + INTERVAL '1 day'
JOIN 
    checkout_base AS cb ON ob.order_id = cb.order_id
ORDER BY 
    ob.order_id
