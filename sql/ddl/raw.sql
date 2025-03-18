create schema raw authorization postgres;

create table raw.device (
	id			bigint primary key,
	type 		int,
	store_id 	bigint
);

create table raw.store (
	id			bigint primary key,
	name		text,
	address		text,
	city		text,
	country		text,
	created_at	text,
	typology	text,
	customer_id	bigint
);

create table raw.transaction (
	id					bigint primary key,
	device_id			bigint,
	product_name		text,
	product_sku			text,
	category_name		text,
	amount				bigint,
	status				text,
	card_number			text,
	cvv					int,
	created_at			text,
	happened_at			text
);