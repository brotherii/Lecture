WITH lines AS (--$$ <вставить текст> $$ --иначе спотыкается на кавычках
  SELECT regexp_split_to_table(:log_txt, E'\n') AS line
)
,blocks AS (-- Номеруем по номеру блока, используя накопление
  SELECT
    trim(regexp_replace(replace(line,'|',''), '\s+', ' ', 'g')) as line,
    sum(CASE WHEN line ~ 'fetched.' THEN 1 ELSE 0 END)
      OVER (ORDER BY ord ROWS UNBOUNDED PRECEDING) + 1 AS block_id
  FROM (
    SELECT line, row_number() OVER () AS ord
    FROM lines
    where line not like '--%'
    and length(line)>10
  ) sub
)
,grouped AS (-- Группируем по номеру блока
  SELECT block_id, string_agg(line, E'\n') AS block_text
  FROM blocks
  where
      line not like '%EXPLAIN%'
  and line not like '%fetched%'
  and line not like '%Planning%'
  GROUP BY block_id
  ORDER BY block_id
)
,parsed AS (-- Парсим значения
  select
    row_number() OVER () AS id
--    ,(SELECT line FROM lines WHERE line ILIKE 'select%') AS query_text
    ,(SELECT regexp_match(block_text, '(Index Only Scan|Index Scan|Parallel Seq Scan|Seq Scan|Bitmap Index Scan|Bitmap Heap Scan)', 'i'))[1] AS scan_type
    ,(SELECT regexp_match(block_text, 'on ([a-zA-Z0-9_]+)', 'i'))[1] AS table_name
    ,(SELECT regexp_match(block_text, '>\s*(Index Only Scan) using ([^\s]+)', 'i'))[1] AS scan_type
    ,(SELECT regexp_match(block_text, '>\s*(Index Only Scan) using ([^\s]+)', 'i'))[2] AS index_name
--    ,(SELECT regexp_match(block_text, 'Index Cond: \((.+)\)', 'i'))[1] AS index_cond
    ,(SELECT regexp_match(block_text, 'Filter: \((.+)\)', 'i'))[1] AS filter_cond
    ,(SELECT regexp_match(block_text, 'Execution Time: ([0-9.]+)', 'i'))[1]::float AS exec_time
    -- Извлекаем первое и второе вхождение Index Scan using ...
--    ,(regexp_matches(block_text, 'Index Scan using (\S+)', 'g'))[1] AS index1
--    ,(regexp_matches(block_text, 'Index Scan using (\S+)', 'g'))[2] AS index2
    -- Извлекаем Execution Time
--    ,(regexp_match(block_text, '->  [a-Z| ]+ on', 'i'))[1] AS index_scan
--    ,(regexp_match(block_text, 'Execution Time: ([0-9.]+) ms'))[1] AS execution_time
    --
--    ,block_id
    ,block_text
  FROM grouped
  where block_text like '%QUERY PLAN%'
)
SELECT *
FROM parsed;
