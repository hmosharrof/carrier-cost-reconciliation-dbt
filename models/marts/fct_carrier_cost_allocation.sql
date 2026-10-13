-- Gold layer: Controlling's monthly store cost split across carriers by their share of deliveries.
select
    s.store_id,
    s.month,
    s.carrier_id,
    s.deliveries,
    s.delivery_share,
    t.controlling_total_cost,
    round(t.controlling_total_cost * s.delivery_share, 2) as allocated_cost
from {{ ref('int_carrier_delivery_share') }} s
join {{ ref('stg_store_cost_totals') }} t
  on t.store_id = s.store_id
 and t.month = s.month
