-- Silver layer: when each carrier started working for each store.
select
    carrier_id,
    store_id,
    contract_start_date
from {{ ref('carrier_contracts') }}
