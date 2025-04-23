ALTER TABLE public.test_data ADD fk int8 null default 1;
ALTER TABLE public.test_data DROP COLUMN fk;

--drop table if exists public.test_data_fk;
create table public.test_data_fk as 
	select generate_series(1, 1000000)::int8 as id, generate_series(1000000, 1, -1)::text as t;
ALTER TABLE public.test_data_fk
    ADD CONSTRAINT test_data_fk_pk PRIMARY KEY (id);
ALTER TABLE public.test_data
    ADD CONSTRAINT test_data_test_data_fk_fk FOREIGN KEY (fk)
    REFERENCES public.test_data_fk(id);
create index on public.test_data(fk);

create table public.test_data_statistic as
select 1 as num, '1' as tim, '' as idx

ALTER TABLE public.test_data
    ADD CONSTRAINT test_data_pk PRIMARY KEY (a);
create index on public.test_data(a);
create index on public.test_data(b);
create index on public.test_data(c);-- where c is not null;
--drop index if exists test_data_c_idx;
--drop index if exists test_data_b_idx;
create unique index on public.test_data(a, b, c);
create unique index on public.test_data(a, b, c) include (d);
 


analyze verbose test_data;
VACUUM (VERBOSE, ANALYZE) test_data;
