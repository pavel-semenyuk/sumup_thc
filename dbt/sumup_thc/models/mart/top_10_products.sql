{{ config(
    materialized = 'view',
) }}

with aggregated as (
    select
        product_name,
        sum(total_amount) as transacted_amount
    from
        {{ ref('products_aggregated') }}
    group by 1
),
ranked as (
    select
        product_name,
        transacted_amount,
        row_number() over (order by transacted_amount desc) as rn
    from
        aggregated
)
select
    product_name,
    transacted_amount
from ranked
where rn <= 10