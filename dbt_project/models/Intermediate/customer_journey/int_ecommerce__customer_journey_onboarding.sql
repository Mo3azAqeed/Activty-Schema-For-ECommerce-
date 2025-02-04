{{ 
   config(
      materialized='ephemeral'
   ) 
}}

SELECT 
    user_id,
    signing_up_date AS onborading_date,
    referral_channel as source
FROM {{ ref("int_ecommerce__users__events")}}

