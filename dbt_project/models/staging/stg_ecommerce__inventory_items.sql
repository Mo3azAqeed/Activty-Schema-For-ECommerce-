
  
WITH source AS 
    (
    SELECT * 
    FROM 
        "Thelook"."public"."inventory_items"
        
        )
SELECT
    product_name,
    inventory_item_id,
    sold_at,
    product_retail_price,
    created_at,
    product_brand,
    product_category,
    cost,
    product_distribution_center_id,
    product_department,
    product_id,
    product_sku

FROM source
