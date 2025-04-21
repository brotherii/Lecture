EXPLAIN (analyze, costs off, timing off,/* summary off,*/ buffers)
--select * from test_data t, test_data_fk f;
--select * from test_data t, test_data_fk f where t.fk = f.id;
--select * from test_data t join test_data_fk f on t.fk = f.id;
select * from test_data t join test_data_fk f on t.fk = f.id and t.fk=1;
