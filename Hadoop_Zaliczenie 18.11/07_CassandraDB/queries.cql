-- 7.2. Średnie oceny filmów według identyfikatora
SELECT movie_id, AVG(rating) AS average_rating
FROM movielens.ratings_by_movie
GROUP BY movie_id;

-- 7.3. Średnie oceny filmów wraz z tytułami
SELECT title, movie_id, AVG(rating) AS average_rating
FROM movielens.ratings_by_title
GROUP BY title, movie_id;