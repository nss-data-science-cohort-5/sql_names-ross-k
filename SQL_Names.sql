		-- SQL_NAMES - ROSS KIMBERLIN - NSS DS5 --

/* 
	# 1) Q - How many rows are in the names table?

	 	 A - 1,957,046.
*/

	SELECT COUNT(*) AS row_cnt
	FROM names;


/*
	# 2) Q - How many total registered people appear in the dataset?

	 	 A - 351,653,025.
*/

	SELECT SUM(num_registered) AS reg_sum
	FROM names;


/*
	# 3) Q - Which name had the most appearances in a single year in the dataset?
	 
	 	 A - Linda
*/
	
	SELECT name		-- CHRIS MULVEY'S CODE
	FROM names
	WHERE num_registered = 
	(
		SELECT MAX(num_registered) 
		FROM names
	);


/*
	# 4) Q - What range of years are included?

		 A - 1880 to 2018.
*/

	SELECT MAX(year), MIN(year)
	FROM names;
	
	--	SELECT DISTINCT year	-- CHECKING TO SEE IF ANY YEARS ARE SKIPPED
	--	FROM names
	--	ORDER BY year;


/*
	# 5) Q - What year has the largest number of registrations?
	
		 A - 1957.
*/

	SELECT nr.year, MAX(nr.reg_sum) AS max_reg
	FROM 
	(
		SELECT year, SUM(num_registered) AS reg_sum
		FROM names
		GROUP BY year
	) nr
	GROUP BY nr.year
	ORDER BY max_reg DESC;
	
	-- COULD ALSO USE CHRIS MULVEY'S Question 3 CODE, 
	--   SELECT year FROM names WHERE num_registered = 
	--         (SELECT MAX(num_registered) FROM names)  ?


/*
	# 6) Q - How many different (distinct) names are contained in the dataset?

		 A - 98,400.
*/

	SELECT COUNT(DISTINCT name) AS name_cnt
	FROM names;


/*
	# 7) Q - Are there more males or more females registered?

		 A - More males are registered.
*/

	SELECT gender, SUM(num_registered) AS reg_sum
	FROM names
	GROUP BY gender;


/*
	# 8) Q - What are the most popular male and female names overall 
(i.e., the most total registrations)?

		 A - James (M) and Mary (F).
*/	 
	
	SELECT name, gender, sum(num_registered) AS reg_sum
	FROM names
	GROUP BY name, gender
	ORDER BY name_sum DESC;


/*
	# 9) Q - What are the most popular boy and girl names of the first decade 
of the 2000s (2000 - 2009)?

		 A - Jacob and Emily.
*/

	SELECT name, gender, sum(num_registered) AS reg_sum
	FROM names
	WHERE year > 1999
		AND year < 2010
	GROUP BY name, gender
	ORDER BY name_sum DESC;


/*
	# 10) Q - Which year had the most variety in names 
(i.e. had the most distinct names)?

		  A - 2008
*/

	SELECT DISTINCT year, COUNT(DISTINCT name) AS name_cnt
	FROM names
	GROUP BY year
	ORDER BY name_cnt DESC;


/*
	# 11) Q - What is the most popular name for a girl 
that starts with the letter X?

	 	  A - Ximena.
*/	  
	  
	SELECT name, sum(num_registered) AS reg_sum
	FROM names
	WHERE gender = 'F'
		AND name LIKE 'X%'
	GROUP BY name
	ORDER BY name_sum DESC;
	  

/*
	# 12) Q - How many distinct names appear that start with a 'Q', 
but whose second letter is not 'u'?
	
		  A - 46.
*/

	SELECT COUNT(DISTINCT name) AS name_cnt
	FROM names
	WHERE name LIKE 'Q%'
		AND name NOT LIKE 'Qu%';


/*
	# 13) Q - Which is the more popular spelling between "Stephen" and "Steven"? 
Use a single query to answer this question.

		  A - Steven.
*/	  

	SELECT name, sum(num_registered) AS reg_sum
	FROM names
	WHERE name = 'Stephen'
		OR name = 'Steven'
	GROUP BY name	
	ORDER BY sum_reg DESC;


	-- BRYAN HAD:
	-- select case
	--          when sum(t.stephen) > sum(t.steven) then 'Stephen is more popular'
	--          when sum(t.stephen) < sum(t.steven) then 'Steven is more popular'
	--          else 'They are equally popular' end as popularity
	-- from (select case when name = 'Stephen' 
	--				then num_registered else 0 end as stephen,
	--             case when name = 'Steven' then num_registered 
	--				else 0 end  as steven
	--       from usa_names) as t;
	  
	  
/*
	# 14) Q - What percentage of names are "unisex" - that is what percentage of names have been used both for boys and for girls?

	  A - Roughly 10.948%.
*/


	-- TOTAL DATA SET HAS 98,400 DISTINCT NAMES.
	SELECT COUNT(DISTINCT name)
	FROM names;
	
	SELECT COUNT(DISTINCT name)		-- 67,698
	FROM names
	WHERE gender = 'F';
	
	SELECT COUNT(DISTINCT name)		-- 41,475
	FROM names
	WHERE gender = 'M';
	
	
	SELECT DISTINCT name			-- 10,773
	FROM names
	WHERE gender = 'F'
	INTERSECT
	SELECT DISTINCT name	
	FROM names
	WHERE gender = 'M';
	
	
	SELECT 10773.0 / 98400.0
	
	
	-- NOT SURE HOW TO JOIN
	;WITH cteTotalNames AS
	(
		SELECT COUNT(DISTINCT name) AS name_total
		FROM names
	),
	cteUniSex AS
	(
		SELECT DISTINCT name			-- 10,773 ROWS
		FROM names
		WHERE gender = 'F'
		INTERSECT
		SELECT DISTINCT name	
		FROM names
		WHERE gender = 'M'
	),
	cteUniCount AS
	(
		SELECT COUNT(*) AS uni_cnt
		FROM cteUniSex
	)
	SELECT uni_cnt / name_total AS unisex_pct
	FROM cte...;
	
	
	-- MICHAEL HAD:
	WITH
		male_names AS 
		(
			SELECT DISTINCT name
			FROM names
			WHERE gender = 'M'
		),
		female_names AS 
		(
			SELECT DISTINCT name
			FROM names
			WHERE gender = 'F'	
		),
		unisex_names AS 
		(
			SELECT name
			FROM male_names
			INNER JOIN female_names
			USING(name)
		)
	SELECT 
		(SELECT COUNT(name) FROM unisex_names) * 100 /  (SELECT COUNT(DISTINCT name) FROM names) AS unisex_pct;
	
	
	
	
	-- ALEX HAD:
	-- SELECT COUNT(unisex_counts)*100.00/COUNT(*)
	-- FROM (SELECT CASE WHEN (COUNT( DISTINCT gender)>1) 
	-- 			THEN 1 END AS unisex_counts
	-- 		 FROM names
	-- 		 GROUP BY name) AS unisex



	-- CHRIS MULVEY HAD:
	-- WITH male AS 
	-- (
	--		SELECT DISTINCT(name) AS distinct_name
	-- 	  		FROM names
	-- 	  		WHERE gender = 'M'
	-- ),	 
	-- 	 female AS 
	-- (
	-- 		SELECT DISTINCT(name) AS distinct_name
	-- 		FROM names
	-- 		WHERE gender = 'F'
	-- 	)
	-- SELECT
	-- 	(COUNT(DISTINCT(f.distinct_name))::float / (SELECT COUNT(DISTINCT(name)) FROM names)) * 100
	-- FROM female f
	-- JOIN male m ON f.distinct_name = m.distinct_name
	-- ;


	-- BRYAN HAD:
	
	-- select count(distinct name) / 
	--		(select count(distinct name) from usa_names)::float as percent_unisex
	-- from usa_names
	-- where name in
	--      (select name from usa_names where gender = 'M')
	--  	and name in
	--      (select name from usa_names where gender = 'F');
	  

/*
	# 15) Q - How many names have made an appearance in every single year since 1880?

		  A - 921.
*/	

	SELECT name, COUNT(DISTINCT year) AS year_cnt	-- RANGE IS 2018 - 1880 (SEE Q 4)
	FROM names
	GROUP BY name
	HAVING COUNT(DISTINCT year) = 139;


/*
	# 16) Q - How many names have only appeared in one year?

		  A - 21,123.
*/

	SELECT name, COUNT(DISTINCT year) AS year_cnt
	FROM names
	GROUP BY name
	HAVING COUNT(DISTINCT year) = 1;


/*
	# 17) Q - How many names only appeared in the 1950s?

		  A - 661.
*/

	SELECT COUNT(DISTINCT name) AS name_cnt
	FROM names
	WHERE name IN
	(
		SELECT name
		FROM names
		GROUP BY name
		HAVING MAX(year) < 1960
			AND MIN(year) > 1949	
		-- WE ARE TREATING THE 1950s AS BEGINNING IN 1950 PER Question 9 -
		--		SEE INTERESTING ARTICLE AT scientificamerican.com/article/when-is-the-beginning-of/
	);
	

/*
	# 18) Q - How many names made their first appearance in the 2010s?

		  A - 11,270.
*/

	SELECT COUNT(DISTINCT name) AS name_cnt	
	FROM names								
	WHERE name IN
	(
		SELECT name
		FROM names
		GROUP BY name
		HAVING min(year) > 2009
		-- DATA SET ONLY GOES UP THROUGH 2018
	);


/*
	# 19) Q - Find the names that have not be used in the longest.

		  A - Top 10: Zilah, Roll, Crete, Ng, Sip, Lelie, Ottillie,
	  		    Byrde, Pembroke, and Etelka.
*/


	SELECT name, MAX(year) AS most_rec_year
	FROM names
	GROUP BY name
	ORDER BY most_rec_year
	LIMIT 10;

	-- JOSHUA DID 2018 - MAX(year) AS "YEARS SINCE USED"


/*
	# 20) Q - Come up with a question that you would like to answer using this dataset. Then write a query to answer this question.
*/

	CREATE TABLE names_test AS
	TABLE names;


	-- a) Q - IS THERE A PERFORMANCE DIFFERENCE BETWEEN RUNNING 
	--     Question 13 WITH "IN" vs "OR"?
	
	--	  A - YES, SLIGHTLY.  RUNNING "OR" IS ~ 6 ms FASTER.

	EXPLAIN ANALYZE
		SELECT name, sum(num_registered) AS sum_reg
	FROM names_test
	WHERE name IN ('Stephen', 'Steven')
	GROUP BY name	
	ORDER BY sum_reg DESC;


"Sort  (cost=31266.61..31266.88 rows=109 width=15) (actual time=105.062..108.398 rows=2 loops=1)"
"  Sort Key: (sum(num_registered)) DESC"
"  Sort Method: quicksort  Memory: 25kB"
"  ->  Finalize GroupAggregate  (cost=31250.21..31262.92 rows=109 width=15) (actual time=105.056..108.393 rows=2 loops=1)"
"        Group Key: name"
"        ->  Gather Merge  (cost=31250.21..31261.38 rows=90 width=15) (actual time=105.030..108.386 rows=6 loops=1)"
"              Workers Planned: 2"
"              Workers Launched: 2"
"              ->  Partial GroupAggregate  (cost=30250.18..30250.97 rows=45 width=15) (actual time=101.425..101.442 rows=2 loops=3)"
"                    Group Key: name"
"                    ->  Sort  (cost=30250.18..30250.30 rows=45 width=11) (actual time=101.397..101.408 rows=147 loops=3)"
"                          Sort Key: name"
"                          Sort Method: quicksort  Memory: 32kB"
"                          Worker 0:  Sort Method: quicksort  Memory: 32kB"
"                          Worker 1:  Sort Method: quicksort  Memory: 30kB"
"                          ->  Parallel Seq Scan on names_test  (cost=0.00..30248.95 rows=45 width=11) (actual time=0.274..101.179 rows=147 loops=3)"
"                                Filter: (name = ANY ('{Stephen,Steven}'::text[]))"
"                                Rows Removed by Filter: 652202"
"Planning Time: 0.089 ms"
"Execution Time: 108.430 ms"


	EXPLAIN ANALYZE
		SELECT name, sum(num_registered) AS sum_reg
	FROM names_test
	WHERE name = 'Stephen'
		OR name = 'Steven'
	GROUP BY name	
	ORDER BY sum_reg DESC;


"Sort  (cost=33305.20..33305.47 rows=109 width=15) (actual time=98.488..102.113 rows=2 loops=1)"
"  Sort Key: (sum(num_registered)) DESC"
"  Sort Method: quicksort  Memory: 25kB"
"  ->  Finalize GroupAggregate  (cost=33288.80..33301.51 rows=109 width=15) (actual time=98.482..102.108 rows=2 loops=1)"
"        Group Key: name"
"        ->  Gather Merge  (cost=33288.80..33299.97 rows=90 width=15) (actual time=98.418..102.090 rows=6 loops=1)"
"              Workers Planned: 2"
"              Workers Launched: 2"
"              ->  Partial GroupAggregate  (cost=32288.77..32289.56 rows=45 width=15) (actual time=95.298..95.331 rows=2 loops=3)"
"                    Group Key: name"
"                    ->  Sort  (cost=32288.77..32288.89 rows=45 width=11) (actual time=95.259..95.271 rows=147 loops=3)"
"                          Sort Key: name"
"                          Sort Method: quicksort  Memory: 33kB"
"                          Worker 0:  Sort Method: quicksort  Memory: 30kB"
"                          Worker 1:  Sort Method: quicksort  Memory: 31kB"
"                          ->  Parallel Seq Scan on names_test  (cost=0.00..32287.54 rows=45 width=11) (actual time=0.678..95.057 rows=147 loops=3)"
"                                Filter: ((name = 'Stephen'::text) OR (name = 'Steven'::text))"
"                                Rows Removed by Filter: 652202"
"Planning Time: 0.079 ms"
"Execution Time: 102.147 ms"



	-- b) DOES Question 11 PERFORM DIFFERENTLY IF YOU MAKE
	--		gender A BIT COLUMN?

	ALTER TABLE names_test
--	DROP COLUMN gender_bit	
	ADD COLUMN gender_bool BOOL NULL;

	UPDATE names_test
	SET gender_bool = FALSE
	WHERE gender = 'F';
	
	UPDATE names_test
	SET gender_bool = TRUE
	WHERE gender = 'M';	
	
	
	EXPLAIN
	SELECT name, sum(num_registered) AS reg_sum
	FROM names_test
	WHERE gender = 'F'
		AND name LIKE 'X%'
	GROUP BY name
	ORDER BY reg_sum DESC;


"Sort  (cost=22914.13..22914.51 rows=152 width=15)"
"  Sort Key: (sum(num_registered)) DESC"
"  ->  GroupAggregate  (cost=22905.96..22908.62 rows=152 width=15)"
"        Group Key: name"
"        ->  Sort  (cost=22905.96..22906.34 rows=152 width=11)"
"              Sort Key: name"
"              ->  Bitmap Heap Scan on names_test  (cost=220.69..22900.45 rows=152 width=11)"
"                    Filter: ((name ~~ 'X%'::text) AND (gender = 'F'::bpchar))"
"                    ->  Bitmap Index Scan on name_ix  (cost=0.00..220.65 rows=13622 width=0)"
"                          Index Cond: ((name >= 'X'::text) AND (name < 'Y'::text))"
	
	

	EXPLAIN
	SELECT name, sum(num_registered) AS reg_sum
	FROM names_test
	WHERE gender_bool = FALSE
		AND name LIKE 'X%'
	GROUP BY name
	ORDER BY reg_sum DESC;
	

"Sort  (cost=20036.10..20036.38 rows=113 width=15)"
"  Sort Key: (sum(num_registered)) DESC"
"  ->  GroupAggregate  (cost=20030.27..20032.25 rows=113 width=15)"
"        Group Key: name"
"        ->  Sort  (cost=20030.27..20030.55 rows=113 width=11)"
"              Sort Key: name"
"              ->  Bitmap Heap Scan on names_test  (cost=187.78..20026.41 rows=113 width=11)"
"                    Filter: ((NOT gender_bool) AND (name ~~ 'X%'::text))"
"                    ->  Bitmap Index Scan on name_ix  (cost=0.00..187.75 rows=10332 width=0)"
"                          Index Cond: ((name >= 'X'::text) AND (name < 'Y'::text))"



	-- c) WHAT IS THE COMBINATION OF THE FEWEST DISTINCT NAMES THAT WILL
	--		TAKE A CONCATENATED FIELD ABOVE THE "TOAST" SIZE THRESHOLD?
	
	ALTER TABLE names_test
	ADD COLUMN name_list TEXT NULL;

	INSERT INTO name_list
	SELECT 
	(
		SELECT string_agg(...)		-- PLUS generate_series?
		FROM 
	)

	
	
	
	-- d) IS THERE A DIFFERENCE IN PERFORMANCE BETWEEN
	--		A FULL-TABLE SCAN ON names AND A btree INDEX ON names_test?
	
	EXPLAIN
	SELECT name
	FROM names
	WHERE name LIKE 'X%'
	ORDER BY name;
	
"Gather Merge  (cost=23062.50..23081.17 rows=160 width=7)"
"  Workers Planned: 2"
"  ->  Sort  (cost=22062.48..22062.68 rows=80 width=7)"
"        Sort Key: name"
"        ->  Parallel Seq Scan on names  (cost=0.00..22059.95 rows=80 width=7)"
"              Filter: (name ~~ 'X%'::text)"

	
	CREATE INDEX name_ix
	ON names_test
	USING btree(name);
	
	
	EXPLAIN
	SELECT name
	FROM names_test
	WHERE name LIKE 'X%'
	ORDER BY name;
	
"Index Only Scan using name_ix on names_test  (cost=0.43..277.89 rows=193 width=7)"
"  Index Cond: ((name >= 'X'::text) AND (name < 'Y'::text))"
"  Filter: (name ~~ 'X%'::text)"



	
	
	
	
	