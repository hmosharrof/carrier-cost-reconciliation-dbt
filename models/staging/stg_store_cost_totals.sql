-- Silver layer: the single logistics cost per store and month that Controlling books.
select
    store_id,
    month,
    cast(controlling_total_cost as decimal(18,2)) as controlling_total_cost
from {{ ref('store_cost_totals') }}
