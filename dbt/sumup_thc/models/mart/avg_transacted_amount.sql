{{ config(
    materialized = 'view',
) }}

with aggregated as (
    select
        store_country,
        store_typology,
        sum(total_amount) as transacted_amount,
        sum(count_transactions) as count_transactions
    from
        {{ ref('transactions_aggregated') }}
    group by 1,2
)
select
    store_country,
    store_typology,
    round(1.0*transacted_amount / count_transactions, 2) as average_transacted_amount
from
    aggregated
order by 1,2