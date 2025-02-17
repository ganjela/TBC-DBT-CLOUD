{{ config(materialized='table') }}

with sign_ins as (
    select 
        user_id,
        {{ format_date('timestamp', 'hour') }} as event_time,
        count(*) as total_sign_ins
    from {{ source('consumer_events', 'consumer_sign_in') }}
    group by user_id, event_time
),

sign_outs as (
    select 
        user_id,
        {{ format_date('timestamp', 'hour') }} as event_time,
        count(*) as total_sign_outs
    from {{ source('consumer_events', 'consumer_sign_out') }}
    group by user_id, event_time
),

item_views as (
    select 
        user_id,
        {{ format_date('timestamp', 'hour') }} as event_time,
        count(*) as total_items_viewed
    from {{ source('item_events', 'item_view_events') }}
    group by user_id, event_time
),

cart_adds as (
    select 
        user_id,
        {{ format_date('timestamp', 'hour') }} as event_time,
        count(*) as total_items_added
    from {{ source('cart_events', 'add_to_cart_events') }}
    group by user_id, event_time
),

purchases as (
    select 
        user_id,
        {{ format_date('timestamp', 'hour') }} as event_time,
        count(*) as total_purchases
    from {{ source('cart_events', 'checkout_events') }}
    group by user_id, event_time
)

select 
    coalesce(s.user_id, so.user_id, iv.user_id, ca.user_id, p.user_id) as user_id,
    coalesce(s.event_time, so.event_time, iv.event_time, ca.event_time, p.event_time) as event_time,
    coalesce(s.total_sign_ins, 0) as total_sign_ins,
    coalesce(so.total_sign_outs, 0) as total_sign_outs,
    coalesce(iv.total_items_viewed, 0) as total_items_viewed,
    coalesce(ca.total_items_added, 0) as total_items_added,
    coalesce(p.total_purchases, 0) as total_purchases
from sign_ins s
full outer join sign_outs so 
    on s.user_id = so.user_id 
    and s.event_time = so.event_time
full outer join item_views iv 
    on coalesce(s.user_id, so.user_id) = iv.user_id 
    and coalesce(s.event_time, so.event_time) = iv.event_time
full outer join cart_adds ca 
    on coalesce(s.user_id, so.user_id, iv.user_id) = ca.user_id 
    and coalesce(s.event_time, so.event_time, iv.event_time) = ca.event_time
full outer join purchases p 
    on coalesce(s.user_id, so.user_id, iv.user_id, ca.user_id) = p.user_id 
    and coalesce(s.event_time, so.event_time, iv.event_time, ca.event_time) = p.event_time
