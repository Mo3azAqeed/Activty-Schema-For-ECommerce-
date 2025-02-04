with source as (
    select * 
    from {{ source('raw_ecommerce_data', 'users') }}
),
renamed as (
    select
        {{ adapter.quote("user_id") }},
        {{ adapter.quote("first_name") }},
        {{ adapter.quote("age") }},
        {{ adapter.quote("gender") }},
        {{ adapter.quote("city") }},
        {{ adapter.quote("country") }},
        {{ adapter.quote("traffic_source") }},
        {{ adapter.quote("created_at") }} as signing_up_date
    from source
)
select * 
from renamed
