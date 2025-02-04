with source as (
      select * from {{ source('raw_ecommerce_data', 'order_items') }}
),
renamed as (
    select
        {{ adapter.quote("order_item_id") }},
        {{ adapter.quote("order_id") }},
        {{ adapter.quote("user_id") }},
        {{ adapter.quote("product_id") }},
        {{ adapter.quote("inventory_item_id") }},
        {{ adapter.quote("status") }},
        {{ adapter.quote("created_at") }},
        {{ adapter.quote("shipped_at") }},
        {{ adapter.quote("delivered_at") }},
        {{ adapter.quote("returned_at") }},
        {{ adapter.quote("sale_price") }}
    from source
)

select * from renamed
  