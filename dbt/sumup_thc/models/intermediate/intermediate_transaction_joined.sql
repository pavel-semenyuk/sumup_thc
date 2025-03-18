{{ config(
    materialized = 'incremental',
    unique_key = 'id',
    incremental_strategy = 'delete+insert'
) }}

select
    t.id,
    t.device_id,
    t.product_name,
    t.product_sku,
    t.amount,
    t.status,
    t.happened_at,
    t.created_at,
    d.type,
    d.store_id,
    s.country,
    s.typology
from
    {{ ref('staging_sumup__transaction') }} t
left join {{ ref('device_snapshot') }} d on t.device_id = d.id and t.happened_at between d.dbt_valid_from and d.dbt_valid_to
left join {{ ref('store_snapshot') }} s on d.store_id = s.id and t.happened_at between s.dbt_valid_from and s.dbt_valid_to

{% if is_incremental() %}
where t.created_at >= coalesce(
    (
        select
           max(created_at)
        from
            {{ this }}
    ),
    '1900-01-01'
)
{% endif %}