-- Fails if the delivery shares of a store-month do not sum to 1.
select store_id, month, sum(delivery_share) as share_sum
from {{ ref('int_carrier_delivery_share') }}
group by store_id, month
having abs(sum(delivery_share) - 1.0) > 0.000001
