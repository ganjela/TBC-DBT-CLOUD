{{ config(materialized='table') }}

with user_activity as (
    select 
        user_id,
        sum(total_items_viewed) as views,
        sum(total_items_added) as adds,
        sum(total_items_purchased) as purchases
    from {{ ref('aggregated_user_activity') }}
    group by user_id
)

select 
    user_id,
    case 
        when views > 10 and purchases > 3 then 'High-Value Customer'
        when views > 5 then 'Frequent Browser'
        else 'Inactive User'
    end as user_segment
from user_activity