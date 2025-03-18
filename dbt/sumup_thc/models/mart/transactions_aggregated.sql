{{ config(
    materialized = 'incremental',
    unique_key = 'transactions_aggregated_id',
    incremental_strategy = 'delete+insert'
) }}

select
    created_at::date || '-' || type || '-' || country || '-' || typology as transactions_aggregated_id,
    created_at::date,
    type as device_type,
    country as store_country,
    typology as store_typology,
    sum(amount) as total_amount,
    count(id) as count_transactions
from
    {{ ref('intermediate_transaction_joined') }}
where status = 'accepted'

{% if is_incremental() %}
and created_at::date >= coalesce(
    (
        select
           max(created_at::date)
        from
            {{ this }}
    ),
    '1900-01-01'
)
{% endif %}

group by
    1,2,3,4,5

