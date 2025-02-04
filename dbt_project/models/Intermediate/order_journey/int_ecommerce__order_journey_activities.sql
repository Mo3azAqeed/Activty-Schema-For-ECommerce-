{{ config(materialized='ephemeral') }}

WITH order_journey AS (
    SELECT
        order_id,
        MAX(browsing) As browsing,
        MAX(submitted) AS submitted,
        MAX(checkout) AS checkout
    FROM
        {{ ref('int_ecommerce__order_journey') }}
    GROUP BY 
        order_id
),

order_activities AS (
    SELECT 
        order_id,
        'browsing' AS activity,
        browsing AS timestamp
    FROM 
        order_journey
    WHERE 
        browsing IS NOT NULL

    UNION ALL

    SELECT 
        order_id,
        'submitted' AS activity,
        submitted AS timestamp
    FROM 
        order_journey
    WHERE 
        submitted IS NOT NULL

    UNION ALL

    SELECT 
        order_id,
        'checkout' AS activity,
        checkout AS timestamp
    FROM 
        order_journey
    WHERE 
        checkout IS NOT NULL
)

SELECT 
    order_id,
    activity,
    timestamp
FROM 
    order_activities
ORDER BY 
    order_id, timestamp
