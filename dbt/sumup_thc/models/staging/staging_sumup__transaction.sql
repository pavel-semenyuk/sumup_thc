{{ config(
    materialized = 'incremental',
    unique_key = 'id',
    incremental_strategy = 'delete+insert'
) }}

select
    id,
    device_id,
    product_name,
    product_sku,
    category_name,
    amount,
    status,
    to_timestamp(created_at, 'MM-DD-YYYY hh24:mi:ss') as created_at,
    to_timestamp(happened_at, 'MM-DD-YYYY hh24:mi:ss') as happened_at
from
    {{ source('raw', 'transaction') }}

{% if is_incremental() %}
where to_timestamp(created_at, 'MM-DD-YYYY hh24:mi:ss') >= coalesce(
    (
        select
            max(created_at)
        from
            {{ this }}
    ),
    '1900-01-01'
)
{% endif %}