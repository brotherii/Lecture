--drop table if exists public.test_data;
create table public.test_data as
select generate_series(1, 1000000) as a
, generate_series(1000000, 1, -1)::text as b
, CASE floor(random() * 3)::int
      WHEN 0 THEN NULL
      WHEN 1 THEN FALSE
      ELSE TRUE
    END as c
, NOW() - (TRUNC(random() * 365 * 5) || ' days')::interval as d
, 1::int8 as fk
;

select * from public.test_data; --analyze public.test_data1;
order by c;

SELECT relname AS table_name, indexrelname AS index_name, idx_scan AS index_scans, *
FROM pg_stat_user_indexes
--WHERE idx_scan = 0;
 
select attname, n_distinct, correlation, null_frac, most_common_vals, most_common_freqs, *
from pg_stats where tablename = 'test_data';
--analyze test_data;

ALTER TABLE test_data ADD UNIQUE CONSTRAINT b;
ALTER TABLE test_data ADD CONSTRAINT uni_b UNIQUE (b);

select * from test_data where b='5';

EXPLAIN (analyze, costs off, timing off,/* summary off,*/ buffers)
--select a from test_data
--select a from test_data where a=1
--select * from test_data where a=1
select * from test_data where a=1000000 and b='2'
--select * from test_data where a=1 and ''||b='2'
--select * from test_data where b='2' and c=true
--select * from test_data where a=1 and c=true
--select * from test_data where c=true
--select * from test_data where a=1 and b='5' and c>false
--select * from test_data where a=1 or  b='5' or  c>false
--select * from test_data where a=1 and b<'5' or  c>false
--select * from test_data where a=1 or  b::int8<5 or c>false
--select * from test_data where a=1 or  b like '5%' or c>false
--select * from test_data where (a=1 or c>false) and b like '5%'
--select * from test_data where a=1 or b like '5' or c>false


with settings as (
	select '2021-10-30 22:45:31.794 +0500'::timestamptz as ts
)
select *
from public.test_data t , settings s
where t.d = s.ts


EXPLAIN (analyze, costs off, timing off,/* summary off,*/ buffers)
SELECT * FROM test_data
WHERE d = '2025-04-24'


