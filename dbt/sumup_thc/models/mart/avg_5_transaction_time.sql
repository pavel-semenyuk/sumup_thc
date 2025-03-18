{{ config(
    materialized = 'view',
) }}

with fifths as (
	select
		store_id,
		happened_at as first_transaction,
		lead(happened_at, 5) over (partition by store_id order by happened_at) as fifth_transaction,
		row_number() over (partition by store_id order by happened_at) as rn
	from {{ ref('intermediate_transaction_joined') }}
	where status = 'accepted'
)
select
    avg(fifth_transaction - first_transaction) as average_time_to_fifth_transaction
from
    fifths
where
    rn = 1 and
    fifth_transaction is not null