{{ config(
    materialized = 'view',
) }}

with aggregated as (
    select
        device_type,
        sum(count_transactions) as count_transactions
    from
        {{ ref('transactions_aggregated') }}
    group by 1
)
select
    device_type,
    round(1.0*count_transactions / sum(count_transactions) over (), 6) as percentage_of_transaction
from
    aggregated
order by 1