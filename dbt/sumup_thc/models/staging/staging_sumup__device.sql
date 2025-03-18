{{ config(
    materialized = 'ephemeral'
) }}

select
    id,
    type,
    store_id
from
    {{ source('raw', 'device') }}
