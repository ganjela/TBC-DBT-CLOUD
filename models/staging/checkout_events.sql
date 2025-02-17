{{ config(materialized='view') }}

select 
    timestamp,
    event_name,
    user_id,
    cart_id,
    payment_method
from {{ source('cart_events', 'checkout_events') }}

