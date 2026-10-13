-- Gold layer: proves that the allocation adds back up to what Controlling booked.
-- Rounding of each carrier's share to cents can leave a small difference, so the tolerance is 0.05.
select
    store_id,
    month,
    max(controlling_total_cost) as controlling_total_cost,
    sum(allocated_cost) as allocated_total,
    max(controlling_total_cost) - sum(allocated_cost) as difference,
    case when abs(max(controlling_total_cost) - sum(allocated_cost)) <= 0.05 then 1 else 0 end as is_reconciled
from {{ ref('fct_carrier_cost_allocation') }}
group by store_id, month
