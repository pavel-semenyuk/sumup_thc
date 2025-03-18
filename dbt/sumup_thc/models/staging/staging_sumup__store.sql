{{ config(
    materialized = 'ephemeral'
) }}

select
    id,
    name,
    address,
    city,
    country,
    to_timestamp(created_at, 'MM.DD.YYYY hh24:mi:ss') as created_at,
    typology,
    customer_id
from
    {{ source('raw', 'store') }}