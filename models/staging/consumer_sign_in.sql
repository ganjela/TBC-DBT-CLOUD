{{ config(materialized='view') }}

select 
    timestamp,
    event_name,
    user_id
from {{ source('user_events', 'sign_in_events') }}