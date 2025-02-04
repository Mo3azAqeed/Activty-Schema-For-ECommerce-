{{ config(materialized='ephemeral') }}

WITH order_activities AS (

	 SELECT
        order_id,
        user_id,
       'Cancelled' AS activity,
      created_at AS timestamp
    FROM
        {{ ref('stg_ecommerce__orders') }}
	where 
		status='Cancelled'
    UNION ALL

    SELECT
        order_id,
        user_id,
        'shipped' AS activity,
        shipped_at AS timestamp
    FROM
        {{ ref('stg_ecommerce__orders') }}
    WHERE
        shipped_at IS NOT NULL

    UNION ALL

    SELECT
        order_id,
        user_id,
        'delivered' AS activity,
        delivered_at AS timestamp
    FROM
        {{ ref('stg_ecommerce__orders') }}
    WHERE
        delivered_at IS NOT NULL

    UNION ALL

    SELECT
        order_id,
        user_id,
        'returned' AS activity,
        returned_at AS timestamp
    FROM
        {{ ref('stg_ecommerce__orders') }}
    WHERE
        returned_at IS NOT NULL
)

SELECT
	order_id,
    activity,
    timestamp
FROM 
    order_activities
ORDER BY 
    order_id, timestamp


