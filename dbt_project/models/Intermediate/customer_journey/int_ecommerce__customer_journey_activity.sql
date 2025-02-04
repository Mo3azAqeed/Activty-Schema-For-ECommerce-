{{ 
   config(
      materialized = 'ephemeral'
   ) 
}}

SELECT
    user_id,
    created_at AS timestamp,
    session_id,
     traffic_source AS source ,
    CASE 
        WHEN event_type = 'cancel' THEN 'Cancel Purchase'
        WHEN event_type = 'cart' THEN 'Adding to Cart'
        WHEN event_type = 'purchase' THEN 'Making a Purchase'
        ELSE 'Viewing'
    END AS activity
FROM 
    {{ ref("stg_ecommerce__events") }}
WHERE 
    user_id IS NOT NULL
ORDER BY 
    timestamp, session_id
