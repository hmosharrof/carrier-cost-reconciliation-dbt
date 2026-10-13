-- Gold layer: compares the old rule (whole month to the carrier with the latest start date)
-- with the delivery-share rule, per store, month and carrier.
with latest_contract as (
    select
        a.store_id,
        a.month,
        c.carrier_id,
        row_number() over (
            partition by a.store_id, a.month
            order by c.contract_start_date desc
        ) as rn
    from (select distinct store_id, month from {{ ref('fct_carrier_cost_allocation') }}) a
    join {{ ref('stg_carrier_contracts') }} c
      on c.store_id = a.store_id
     and c.contract_start_date <= (a.month || '-31')
)
select
    f.store_id,
    f.month,
    f.carrier_id,
    f.delivery_share,
    f.allocated_cost as delivery_share_cost,
    case when l.carrier_id = f.carrier_id then f.controlling_total_cost else 0 end as start_date_rule_cost,
    case when l.carrier_id = f.carrier_id then f.controlling_total_cost else 0 end - f.allocated_cost as overcharge_under_old_rule
from {{ ref('fct_carrier_cost_allocation') }} f
join latest_contract l
  on l.store_id = f.store_id
 and l.month = f.month
 and l.rn = 1
