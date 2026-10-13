-- Silver layer: one row per delivery, with the reporting month derived from the delivery date.
select
    delivery_id,
    store_id,
    carrier_id,
    delivery_date,
    substr(delivery_date, 1, 7) as month
from {{ ref('deliveries') }}
where delivery_id is not null
