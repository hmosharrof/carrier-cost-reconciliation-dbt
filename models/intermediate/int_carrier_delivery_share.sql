-- Share of each carrier in a store's deliveries per month. This is the allocation key.
with counts as (
    select store_id, month, carrier_id, count(*) as deliveries
    from {{ ref('stg_deliveries') }}
    group by store_id, month, carrier_id
),
totals as (
    select store_id, month, sum(deliveries) as total_deliveries
    from counts
    group by store_id, month
)
select
    c.store_id,
    c.month,
    c.carrier_id,
    c.deliveries,
    t.total_deliveries,
    cast(c.deliveries as double) / t.total_deliveries as delivery_share
from counts c
join totals t
  on t.store_id = c.store_id
 and t.month = c.month
