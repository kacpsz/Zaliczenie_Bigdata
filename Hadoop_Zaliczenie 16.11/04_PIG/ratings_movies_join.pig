ratings = LOAD '/tmp/ratings.csv'
    USING PigStorage(',')
    AS (userId:int, movieId:int, rating:double, timestamp:long);

ratings_clean = FILTER ratings BY userId IS NOT NULL
    AND movieId IS NOT NULL
    AND rating IS NOT NULL;

grouped = GROUP ratings_clean BY movieId;

averages = FOREACH grouped GENERATE
    group AS movieId,
    AVG(ratings_clean.rating) AS average_rating;

movies = LOAD '/tmp/movies.tsv'
    USING PigStorage('\t')
    AS (movieId:int, title:chararray);

joined = JOIN averages BY movieId, movies BY movieId;

result = FOREACH joined GENERATE
    movies::title AS title,
    averages::average_rating AS average_rating;

ordered = ORDER result BY title;

limited = LIMIT ordered 20;

DUMP limited;
