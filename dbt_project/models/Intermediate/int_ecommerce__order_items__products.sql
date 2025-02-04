WITH products AS (
    SELECT
        product_id,
        department AS product_department,
        cost AS product_cost,
        retail_price AS product_retail_price
    FROM {{ ref('stg_ecommerce__products') }}  -- Using ref to reference a dbt model
), 
orders AS (
    SELECT
        order_id, 
        SUM(sale_price) AS total_order_cost 
    FROM {{ ref('stg_ecommerce__order_items') }}
    GROUP BY order_id 
)

SELECT
    -- IDs
    order_items.order_item_id,
    order_items.order_id,
    order_items.user_id,
    order_items.product_id,

    -- Order item data
    order_items.sale_price,

    -- Product data
    products.product_department,
    products.product_cost,
    products.product_retail_price,

    -- Calculated fields
    order_items.sale_price - products.product_cost AS item_profit,
    products.product_retail_price - order_items.sale_price AS item_discount,

    -- Order related columns
    o.total_order_cost,
    (order_items.sale_price / o.total_order_cost) * 100 AS order_item_percentage

FROM 
    {{ ref('stg_ecommerce__order_items') }} AS order_items
LEFT JOIN 
    products 
ON 
    order_items.product_id = products.product_id
JOIN 
    orders AS o 
ON 
    order_items.order_id = o.order_id