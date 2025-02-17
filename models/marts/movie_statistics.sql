{{ config(materialized='table') }}

with movie_views as (
    select 
        item_id as movie_id,
        {{ format_date('timestamp', 'hour') }} as event_time,
        count(*) as total_views
    from {{ source('item_events', 'item_view_events') }}
    group by item_id, event_time
),

movie_cart_adds as (
    select 
        item_id as movie_id,
        {{ format_date('timestamp', 'hour') }} as event_time,
        count(*) as total_cart_adds
    from {{ source('cart_events', 'add_to_cart_events') }}
    group by item_id, event_time
),

movie_purchases as (
    select 
        item_id as movie_id,
        {{ format_date('timestamp', 'hour') }} as event_time,
        count(*) as total_purchases
    from {{ source('cart_events', 'checkout_events') }}
    group by item_id, event_time
)

select 
    coalesce(mv.movie_id, mc.movie_id, mp.movie_id) as movie_id,
    coalesce(mv.event_time, mc.event_time, mp.event_time) as event_time,
    coalesce(mv.total_views, 0) as total_views,
    coalesce(mc.total_cart_adds, 0) as total_cart_adds,
    coalesce(mp.total_purchases, 0) as total_purchases
from movie_views mv
full outer join movie_cart_adds mc 
    on mv.movie_id = mc.movie_id 
    and mv.event_time = mc.event_time
full outer join movie_purchases mp 
    on coalesce(mv.movie_id, mc.movie_id) = mp.movie_id 
    and coalesce(mv.event_time, mc.event_time) = mp.event_time
