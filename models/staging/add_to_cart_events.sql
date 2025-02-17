{{ config(materialized='view') }}

select 
    [timestamp],
    event_name,
    item_id,
    [user_id],
    cart_id
from {{ source('cart_events', 'add_to_cart_events') }}
