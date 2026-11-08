
ratings = LOAD '/tmp/ratings.csv'
    USING PigStorage(',')
    AS (userId:int, movieId:int, rating:double, timestamp:long);

ratings_clean = FILTER ratings BY userId IS NOT NULL;

grouped = GROUP ratings_clean BY movieId;

averages = FOREACH grouped GENERATE
    group AS movieId,
    AVG(ratings_clean.rating) AS average_rating;

ordered = ORDER averages BY movieId;

limited = LIMIT ordered 20;

DUMP limited;
