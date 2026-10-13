-- Fails if Controlling has more than one total for the same store and month.
select store_id, month, count(*) as n
from {{ ref('stg_store_cost_totals') }}
group by store_id, month
having count(*) > 1
