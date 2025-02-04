{{
    config(
        materialized = 'table',
        partition_by = {
            "field": "timestamp",
            "data_type": "timestamp",
            "granularity": "day"
        }
    )
}}

SELECT 
    user_id,
    timestamp,
    activity,
    source
FROM {{ ref("int_ecommerce__customer_journey_activity") }}

UNION ALL

SELECT
    user_id,
    onborading_date AS timestamp,
    'Signing up' AS activity,
    source
FROM {{ ref("int_ecommerce__customer_journey_onboarding") }}

ORDER BY timestamp
