{{ config(materialized='view') }}

select 
    [timestamp],
    event_name,
    [user_id]
from {{ source('consumer_events', 'consumer_sign_in') }}
