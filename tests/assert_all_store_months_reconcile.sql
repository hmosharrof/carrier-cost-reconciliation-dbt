-- Fails (returns rows) if any store-month does not add back up to Controlling's total.
select * from {{ ref('fct_reconciliation_check') }} where is_reconciled = 0
