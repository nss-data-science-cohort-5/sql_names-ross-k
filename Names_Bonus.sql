		-- NAMES_BONUS - ROSS KIMBERLIN - NSS DS5 --
		
/*
	For this first set of questions, you might find it useful to refer to the PostgreSQL string functions (https://www.postgresql.org/docs/14/functions-string.html).

	# 1) Q - Find the longest name contained in this dataset. What do you notice about the long names?
	
		 A - There are 36 ties for 15 characters, which is the greatest name length in the data set.  I notice that these are all compound names, where it looks like the first and middle name were concatenated without a space.  I wouldn't be surprised if there is a 15-character limit in the data source's name field.
		 
		 By the way, even though it's only 13 characters, I think "Kamsiyochukwu" might be the most interesting and fun long name.
*/

SELECT name, LENGTH(name) AS name_lngt
FROM names
GROUP BY name
ORDER BY name_lngt DESC;


/*
	# 2) Q - How many names are palindromes (i.e. read the same backwards and forwards, such as Bob and Elle)?
	
	     A - 
*/


/*
	# 3) Q - Find all names that contain no vowels (for this question, we'll count a,e,i,o,u, and y as vowels). (Hint: you might find this page helpful: https://www.postgresql.org/docs/8.3/functions-matching.html)
*/


/*
	# 4) Q - How many double-letter names show up in the dataset? Double-letter means the same letter repeated back-to-back, like Matthew or Aaron. Are there any triple-letter names?
	
		 A -
*/


/*
	For the next few questions, you'll likely need to make use of subqueries. A subquery is a SQL query nested inside another query. You'll learn more about subqueries over the next few DataCamp assignments.

	# 5) Q - On question 17 of the first part of the exercise, you found names that only appeared in the 1950s. Now, find all names that did not appear in the 1950s but were used both before and after the 1950s. We'll answer this question in two steps.
	
		a. First, write a query that returns all names that appeared during the 1950s.
*/

	SELECT DISTINCT name
	FROM names
	WHERE name IN
	(
		SELECT name
		FROM names
		GROUP BY name
		HAVING MAX(year) < 1960
			AND MIN(year) > 1949	
	);
	

/*
		b. Now, make use of this query along with the IN keyword in order the find all names that did not appear in the 1950s but which were used both before and after the 1950s. See the example "A subquery with the IN operator." on this page: https://www.dofactory.com/sql/subquery.
*/

	SELECT DISTINCT name
	FROM names
	WHERE name NOT IN
	(
		SELECT name
		FROM names
		GROUP BY name
		HAVING MAX(year) < 1960
			AND MIN(year) > 1949	
	);
	

/*
	# 6) Q - In question 16, you found how many names appeared in only one year. Which year had the highest number of names that only appeared once?

		 A - 2018, with 1055 one-hit-wonder names!
*/

	SELECT year, COUNT(DISTINCT name) AS name_cnt
	FROM names 
	WHERE name IN
	(	
		SELECT name	--, COUNT(DISTINCT year) AS year_cnt	-- 21,123 ROWS
		FROM names
		GROUP BY name
		HAVING COUNT(DISTINCT year) = 1
	)
	GROUP BY year
	ORDER BY name_cnt DESC
	;


/*
	# 7) Q - Which year had the most new names (names that hadn't appeared in any years before that year)? For this question, you might find it useful to write a subquery and then select from this subquery. See this page about using subqueries in the from clause: https://www.geeksforgeeks.org/sql-sub-queries-clause/

		 A -
*/


/*
	# 8) Q - Is there more variety (more distinct names) for females or for males? Is this true for all years or are their any years where this is reversed? Hint: you may need to make use of multiple subqueries and JOIN them in order to answer this question.
	
		 A -
*/


/*
	# 9) Q - Which names are closest to being evenly split between male and female usage? For this question, consider only names that have been used at least 10000 times in total. 
	
		 A - 
*/


/*
	For the last questions, you might find window functions useful (see https://www.postgresql.org/docs/9.1/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS and https://www.postgresql.org/docs/9.1/functions-window.html for a list of window function available in PostgreSQL). A window function is like an aggregate function in that it can be applied across a group, but a window function does not collapse each group down to a single summary statistic. The groupings for a window function are specified using the PARTITION BY keyword (and can include an ORDER BY when it is needed). The PARTITION BY and ORDER BY associated with a window function are CONTAINED in an OVER clause.
	
	For example, to rank each row by the value of num_registered, we can use the query
```
SELECT name, year, num_registered, RANK() OVER(ORDER BY num_registered DESC)
FROM names;
```

	If I want to rank within gender, I can add a PARTITION BY:  
```
SELECT name, year, num_registered, RANK() OVER(PARTITION BY gender ORDER BY num_registered DESC)
FROM names;
```

	# 10) Q - Which names have been among the top 25 most popular names for their gender in every single year contained in the names table? Hint: you may have to combine a window function and a subquery to answer this question.
	
		  A - 
*/

/*
	# 11) Q - Find the name that had the biggest gap between years that it was used. 

		  A - 
*/

/*
	# 12) Q - Have there been any names that were not used in the first year of the dataset (1880) but which made it to be the most-used name for its gender in some year? Difficult follow-up: What is the shortest amount of time that a name has gone from not being used at all to being the number one used name for its gender in a year?
	
		  A - 
*/


