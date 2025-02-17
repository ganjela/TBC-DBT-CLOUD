{{ config(materialized='view') }}

select 
    [timestamp],
    event_name,
    [user_id],
    age,
    masked_email,
    preferred_language
from {{ source('consumer_events', 'consumer_registration') }}
