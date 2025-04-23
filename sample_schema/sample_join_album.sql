EXPLAIN (analyze, costs off, timing off, /*summary off,*/ buffers)
--SELECT * FROM public.album a, public.track t WHERE a."Album_Id" = t.albumid;
SELECT * FROM public.album a JOIN public.track t ON a."Album_Id" = t.albumid;
	