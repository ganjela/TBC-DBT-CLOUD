{{ config(materialized='view') }}

select 
    timestamp,
    event_name,
    item_id,
    user_id
from {{ source('item_events', 'item_view_events') }}
