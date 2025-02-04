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
    order_id,
    activity,
    timestamp
FROM 
    {{ ref('int_ecommerce__order_journey_activities') }}

UNION ALL 

SELECT  
    order_id,
    activity,
    timestamp
FROM  
    {{ ref('int_ecommerce__order_journey_status') }}

ORDER BY 
    order_id, timestamp
