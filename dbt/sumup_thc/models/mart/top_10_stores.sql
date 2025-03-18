{{ config(
    materialized = 'view',
) }}

with aggregated as (
    select
        store_id,
        sum(total_amount) as transacted_amount
    from
        {{ ref('stores_aggregated') }}
    group by 1
),
ranked as (
    select
        store_id,
        transacted_amount,
        row_number() over (order by transacted_amount desc) as rn
    from
        aggregated
)
select
    store_id,
    transacted_amount
from ranked
where rn <= 10