create database fave_reads
	with owner marcosportela
;

create table "_book"
(
	id bigserial not null
		constraint book_pkey
			primary key,
	title text,
	year integer
)
;

alter table "_book" owner to marcosportela
;

create table "_author"
(
	id bigserial not null
		constraint author_pkey
			primary key,
	name text,
	book_id bigint
		constraint book_id
			references "_book"
)
;

alter table "_author" owner to marcosportela
;

