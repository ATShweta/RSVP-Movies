USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

select * from director_mapping;
select * from genre;
select * from movie;
select * from names;
select * from ratings;
select * from role_mapping;



-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Count rows in the movie table
SELECT COUNT(*) AS movie_count FROM movie;
-- Ans: 7997

-- Count rows in the genre table
SELECT COUNT(*) AS genre_count FROM genre;
-- Ans: 14662

-- Count rows in the director_mapping table
SELECT COUNT(*) AS director_mapping_count FROM director_mapping;
-- Ans: 3867

-- Count rows in the role_mapping table
SELECT COUNT(*) AS role_mapping_count FROM role_mapping;
-- Ans: 15615

-- Count rows in the names table
SELECT COUNT(*) AS names_count FROM names;
-- Ans: 25735

-- Count rows in the ratings table
SELECT COUNT(*) AS ratings_count FROM ratings;
-- Ans: 7997


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT
SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS Title_NULL,
SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS Year_NULL,
SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS DatePublished_NULL,
SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS Duration_NULL,
SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS Country_NULL,
SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS WorldWide_NULL,
SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS Language_NULL,
SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_NULL
FROM movie;

-- Answer : country has 20 null values, worldwide_gross_income has 3724 null values, languages has 194 null values and production_company has 528 null values. Rest has 0 null values.
-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 


-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select year, count(id) as number_of_movies
from movie
group by year;

-- Answer:
/* Total movies released each year
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944			|
|	2019		|	2001			|
*/

select month(date_published) as Month_number, count(id) as number_of_movies
from movie
group by Month_number
order by Month_number;

-- Answer: 
/* Month wise trend
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	3			|	 824 			|
|   4           |    680            |
|   5           |    625            |
|   6           |    580            |
|   7           |    493            |
|   8           |    678            |
|   9           |    809            |
|   10          |    801            |
|   11          |    625            |
|   12          |    438            |
+---------------+-------------------+
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(DISTINCT id) as Number_of_movies, year
FROM movie
where (country like '%INDIA%' OR country like '%USA%') and year = 2019;

-- Answer: number of movies in 2019 is 1059.



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre;

/* Answer:
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others */



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT g.genre, COUNT(*) AS num_movies
FROM  genre g
JOIN  movie m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY num_movies DESC
LIMIT 1;

-- Answer : 4285 movies were produced in Drama genre which is highest. 


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT  COUNT(*) AS num_movies_with_single_genre
FROM ( SELECT movie_id, COUNT(*) AS num_genres
    FROM genre
    GROUP BY movie_id
    HAVING num_genres = 1) AS single_genre_movies;

-- ANSWER : 3289 movies belong to only one genre






/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, ROUND(AVG(m.duration)) AS avg_duration
FROM genre g
JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY avg_duration DESC;

/* -- Answer
genre   avg_duration
Action	    113
Romance	    110
Drama	    107
Crime	    107
Fantasy	    105
Comedy	    103
Thriller	102
Adventure	102
Mystery	    102
Family	    101
Others	    100
Sci-Fi	    98
Horror	    93
*/





/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH 
genre_rank as
(
	select genre,
       count(movie_id) as movie_count,
       RANK() over(order by count(movie_id) desc) as genre_rank
       from genre
       group by genre
       )
select * 
from genre_rank
where genre = "Thriller";

/* -- Answer: Thriller genre has Rank 3 with 1484 movies
genre	|	movie_count	|	genre_rank	|
--------+---------------+---------------+
Thriller|	 1484		|		3		|
--------+---------------+---------------+
*/



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM 
    ratings;

/* ANSWER :
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1.0		|		10.0  	    |	      100		  |	    725138    		 |		1          |	  10		 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too


SELECT title, avg_rating, RANK() OVER (ORDER BY avg_rating DESC) AS movie_rank
FROM  ratings
JOIN  movie ON ratings.movie_id = movie.id
ORDER BY avg_rating DESC
LIMIT 10;

/* ANSWER:
title                      avg_rating  Rank
----------------------------------------------
Kirket	                        10.0	1
Love in Kilnerry	            10.0	1
Gini Helida Kathe	            9.8	    3
Runam	                        9.7	    4
Fan                             9.6	    5
Android Kunjappan Version 5.25	9.6	    5
Yeh Suhaagraat Impossible	    9.5 	7
Safe	                        9.5	    7
The Brighton Miracle	        9.5 	7
Shibu	                        9.4	   10

*/




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating, COUNT(*) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;

/* ANSWER: 
median_rating    movie_count
    1				94
	2				119
	3				283
	4				479
	5				985
	6				1975
	7				2257
	8				1030
	9				429
	10				346
*/




/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, COUNT(*) AS movie_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_company_rank
FROM movie
JOIN  ratings ON movie.id = ratings.movie_id
WHERE ratings.avg_rating > 8 AND
    production_company IS NOT NULL
GROUP BY production_company
ORDER BY movie_count DESC
LIMIT 1;

/* ANSWER:

production_company     | movie_count | prod_company_rank |
Dream Warrior Pictures |       3	 |         1		 |

*/





-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, COUNT(*) AS movie_count
FROM genre g
JOIN  movie m ON g.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
WHERE YEAR(m.date_published) = 2017 AND MONTH(m.date_published) = 3 AND
 m.country = 'USA' AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count desc;

/* ANSWER:
genre	| movie_count |
Drama		16
Comedy		8
Crime		5
Horror		5
Action		4
Sci-Fi		4
Thriller	4
Romance		3
Fantasy		2
Mystery		2
Family		1
*/

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title, MAX(r.avg_rating) AS avg_rating, MAX(g.genre) AS genre
FROM movie m
JOIN ratings r ON m.id = r.movie_id
JOIN genre g ON m.id = g.movie_id
WHERE m.title LIKE 'The%' AND r.avg_rating > 8
GROUP BY m.title
ORDER BY avg_rating DESC;

/* ANSWER
title									| avg_rating | genre |
The Brighton Miracle					|	9.5		 | Drama
The Colour of Darkness					|	9.1		 | Drama
The Blue Elephant 2						|	8.8		 | Mystery
The Irishman							| 	8.7		 | Drama
The Mystery of Godliness: The Sequel	|	8.5		 | Drama
The Gambinos							|	8.4		 | Drama
Theeran Adhigaaram Ondru				|	8.3		 | Thriller
The King and I							| 	8.2		 | Romance
*/


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT median_rating, COUNT(*) AS num_movies_median_8
FROM ratings
JOIN movie ON ratings.movie_id = movie.id
WHERE movie.date_published BETWEEN '2018-04-01' AND '2019-04-01' AND ratings.median_rating = 8;

/* ANSWER:
median_rating    num_movies_median_8
8	                361
*/




-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT
    SUM(CASE WHEN m.country = 'Germany' THEN r.total_votes ELSE 0 END) AS total_votes_german,
    SUM(CASE WHEN m.country = 'Italy' THEN r.total_votes ELSE 0 END) AS total_votes_italian
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.country IN ('Germany', 'Italy');

/* ANSWER: YES - German movies gets more votes than Italian movies
total_votes_german | total_votes_italian
106710			   |	77965




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/*ANSWER: 

+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|	   17335		|	       13431	  |	   15226	    	 |
+---------------+-------------------+---------------------+----------------------+*/




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


with top_3_genres as 
            ( select g.genre,
                     count(m.id) as movie_count
			  from genre g 
              inner join movie m
              on m.id = g.movie_id
              inner join ratings r 
              on m.id = r.movie_id
              where avg_rating > 8
              group by genre
              order by movie_count desc
              limit 3)
select n.name as director_name,
       count(d.movie_id) as movie_count
from director_mapping d
inner join genre g
on g.movie_id = d.movie_id
inner join names n  
on d.name_id = n.id
inner join top_3_genres 
using (genre)
inner join ratings r  
on r.movie_id = d.movie_id
where avg_rating > 8
group by director_name
order by movie_count desc
limit 3;

/* Answer :

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|Anthony Russo  |		3			|
|Soubin Shahir	|		3       	|
+---------------+-------------------+ */



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select n.name as actor_name,
       count(movie_id) as movie_count
from names n
inner join role_mapping rm
on n.id = rm.name_id
inner join ratings r 
using (movie_id)
where category = 'actor'
      and median_rating >= 8
group by actor_name
order by movie_count desc
limit 2;

/* ANSWER:
+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|  Mammootty    |		8			|
|	Mohanlal	|		5			|
+---------------+-------------------+ */




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company,
       sum(total_votes) as vote_count,
       RANK() OVER (order by sum(total_votes) desc) as prod_comp_rank
from movie m
inner join ratings r
on m.id = r.movie_id
group by production_company
limit 3;

/* Answer :
+----------------------+--------------------+---------------------+
|production_company    |   vote_count		|		prod_comp_rank|
+----------------------+--------------------+---------------------+
| Marvel Studios	   |	2656967 		|		1	  		  |
|Twentieth Century Fox |	2411163			|		2       	  |
|	Warner Bros.	   |	2396057			|		3   		  |
+----------------------+--------------------+---------------------+*/




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating,
    RANK() OVER (ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) DESC) AS actor_rank
FROM names n
INNER JOIN role_mapping rm ON n.id = rm.name_id
INNER JOIN ratings r ON rm.movie_id = r.movie_id
INNER JOIN movie m ON m.id = r.movie_id
WHERE rm.category = 'actor' AND m.country = 'India'
GROUP BY actor_name
HAVING COUNT(r.movie_id) >= 5;

/* ANSWER:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|Vijay Sethupathi|	23114			|	       5		  |	   8.42	    		 |		1	       |
|Fahadh Faasil	|	13557			|	       5		  |	   7.99	    		 |		2	       |
|Yogi Babu		|		8500		|	       11		  |	   7.83	    		 |		3	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/







-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
    n.NAME AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating,
    RANK() OVER (ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actress_rank
FROM 
    movie m
INNER JOIN 
    ratings r ON m.id = r.movie_id
INNER JOIN 
    role_mapping AS rm ON m.id = rm.movie_id
INNER JOIN 
    names AS n ON rm.name_id = n.id
WHERE 
    category = 'ACTRESS'
    AND country = 'INDIA'
    AND languages LIKE '%HINDI%'
GROUP BY 
    n.NAME
HAVING 
    movie_count >= 3;

/* ANSWER:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|Taapsee Pannu  |			18061	|	       3		  |	   7.74	    		 |		1	       |
|Kriti Sanon	|			21967	|	      3			  |	   7.05	    		 |		2	       |
|Divya Dutta	|			8579	|	       3		  |	   6.88	    		 |		3	       |
|Shraddha Kapoor|			26779	|	       3		  |	   6.63	    		 |		4	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT m.title AS movie_title, r.avg_rating AS average_rating,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit movies'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS movie_category
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
INNER JOIN genre g ON m.id = g.movie_id
WHERE g.genre = 'Thriller';

/* Answer:

-------------------------------------------------------------
movie_title		|	average_rating	|	movie_category		|
-------------------------------------------------------------
	Safe				9.5				Superhit movies		|	
	Digbhayam			9.2				Superhit movies		|
	Abstruse			9.0				Superhit movies		|
    .														|
    .														|
-------------------------------------------------------------
*/




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT g.genre,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(AVG(m.duration)) OVER (ORDER BY g.genre) AS running_total_duration,
    AVG(AVG(m.duration)) OVER (ORDER BY g.genre) AS moving_avg_duration
FROM movie m
INNER JOIN genre g ON m.id = g.movie_id
GROUP BY g.genre ;

/* Answer :

genre      avg_duration  running_total_duration   moving_avg_duration
Action	    112.88	         112.8829	              112.88290000
Adventure	101.87	         214.7543	              107.37715000
Comedy	    102.62	         317.3770	              105.79233333
Crime	    107.05	         424.4287	              106.10717500
Drama	    106.77	         531.2033	              106.24066000
Family	    100.97	         632.1702	              105.36170000
Fantasy	    105.14	         737.3106	              105.33008571
Horror	    92.72	         830.0349	              103.75436250
Mystery	    101.80	         931.8349	              103.53721111
Others	    100.16	         1031.9949	              103.19949000
Romance	    109.53	         1141.5291	              103.77537273
Sci-Fi	    97.94	         1239.4704	              103.28920000
Thriller	101.58	         1341.0465	              103.15742308
*/





-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top3_genre
AS (SELECT genre,
	COUNT(movie_id) as movie_count
	FROM genre
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3),
top5_movie 
AS (SELECT genre,
           YEAR,
           title as movie_name,
           worlwide_gross_income,
DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
WHERE genre IN(SELECT genre FROM top3_genre))
SELECT *
FROM top5_movie
WHERE movie_rank<=5;


/*	Answer 
   genre    year    movie_name               worldwide_gross_income  movie_rank
---------------------------------------------------------------------------------
    Drama	2017	Shatamanam Bhavati	        INR 530500000         	1
	Drama	2017	Winner	                    INR 250000000	        2
	Drama	2017	Thank You for Your Service	$ 9995692	            3
	Comedy	2017	The Healer	                $ 9979800	            4
	Drama	2017	The Healer	                $ 9979800	            4
*/





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

Select production_company,
       COUNT(id) as movie_count,
       RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE median_rating>=8
AND production_company IS NOT NULL
AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;

/* ANSWER:
+----------------------+-------------------+---------------------+
|production_company    |movie_count		|		prod_comp_rank|
+----------------------+-------------------+---------------------+
| Star Cinema		   |		7			|		1	  		  |
|Twentieth Century Fox |		4			|		2   		  |
+-------------------+-------------------+---------------------+*/



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT name as actress_name, 
       SUM(total_votes) AS total_votes, COUNT(rm.movie_id) as movie_id, 
       Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating,
       RANK() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actress_rank
FROM names n
INNER JOIN role_mapping rm
ON n.id = rm.name_id
INNER JOIN ratings r
ON r.movie_id = rm.movie_id
INNER JOIN genre g
ON g.movie_id = r.movie_id
WHERE category="actress" AND avg_rating>8 AND g.genre="Drama"
GROUP BY name
LIMIT 3;

/* Answer :
+-------------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	    |	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+-------------------+-------------------+---------------------+----------------------+-----------------+
|Parvathy Thiruvothu|		4974    	|	       2		  |	   8.25			     |		1	       |
|	Susan Brown		|		656 		|	       2		  |	   8.94	    		 |		1	       |
|Amanda Lawrence	|		656	    	|	       2    	  |	   8.94	    		 |		1	       |
+-------------------+-------------------+---------------------+----------------------+-----------------+*/



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH TopDirectors AS (
    SELECT
        dm.name_id AS director_id,
        n.name AS director_name,
        COUNT(*) AS number_of_movies,
        AVG(COALESCE(m1.inter_movie_days, 0)) AS avg_inter_movie_days,
        AVG(COALESCE(r.avg_rating, 0)) AS avg_rating,
        SUM(COALESCE(r.total_votes, 0)) AS total_votes,
        MIN(COALESCE(r.avg_rating, 0)) AS min_rating,
        MAX(COALESCE(r.avg_rating, 0)) AS max_rating,
        SUM(COALESCE(m.duration, 0)) AS total_duration
    FROM
        director_mapping dm
    INNER JOIN
        names n ON dm.name_id = n.id
    INNER JOIN
        movie m ON dm.movie_id = m.id
    INNER JOIN
        ratings r ON m.id = r.movie_id
    LEFT JOIN (
        SELECT 
            id AS movie_id,
            DATEDIFF(date_published, lag(date_published) OVER (PARTITION BY id ORDER BY date_published)) AS inter_movie_days
        FROM 
            movie
    ) AS m1 ON m.id = m1.movie_id
    GROUP BY
        dm.name_id, n.name
    ORDER BY
        number_of_movies DESC
    LIMIT 9
)
SELECT
    director_id,
    director_name,
    number_of_movies,
    ROUND(avg_inter_movie_days, 2) AS avg_inter_movie_days,
    ROUND(avg_rating, 2) AS avg_rating,
    total_votes,
    ROUND(min_rating, 2) AS min_rating,
    ROUND(max_rating, 2) AS max_rating,
    total_duration
FROM
    TopDirectors;


/* ANSWER:

+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
	nm1777967		A.L. Vijay					5					0.00				5.42			1754		3.7				6.9			613
	nm2096009		Andrew Jones				5					0.00				3.02			1989		2.7				3.2			432
	nm0831321		Chris Stokes				4					0.00				4.33			3664		4.0				4.6			352
	nm2691863		Justin Price				4					0.00				4.50			5343		3.0				5.8			346
	nm0425364		Jesse V. Johnson			4					0.00				5.45			14778		4.2				6.5			383
	nm0001752		Steven Soderbergh			4					0.00				6.48			171684		6.2				7.0			401
	nm0814469		Sion Sono					4					0.00				6.03			2972		5.4				6.4			502
	nm6356309		Özgür Bakar					4					0.00				3.75			1092		3.1				4.9			374
	nm0515005		Sam Liu						4					0.00				6.23			28557		5.8				6.7			312
    */



