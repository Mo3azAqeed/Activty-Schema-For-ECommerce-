WITH user_activities AS (
    SELECT  
        user_id, 
        MIN(created_at) AS engaged_user_at,
        MAX(created_at)AS last_seen_at
    FROM 
        {{ ref('stg_ecommerce__events') }}
    GROUP BY user_id
), 
orders AS (
    SELECT 
        user_id,
        MAX(created_at) AS first_payment_at
    FROM 
        {{ ref('stg_ecommerce__orders') }}
    WHERE 
        status = 'Complete' AND returned_at IS NULL
    GROUP BY 
        user_id
)

SELECT 
    stg_us.user_id,
    stg_us.signing_up_date,
    stg_us.traffic_source AS referral_channel,
    ua.engaged_user_at,
    ua.last_seen_at,
    o.first_payment_at
FROM  
    {{ ref('stg_ecommerce__users') }} AS stg_us
LEFT JOIN 
    user_activities AS ua ON stg_us.user_id = ua.user_id
LEFT JOIN 
    orders AS o ON o.user_id = stg_us.user_id
