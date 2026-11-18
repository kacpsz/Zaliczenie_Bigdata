CREATE KEYSPACE IF NOT EXISTS movielens
WITH replication = {'class': 'NetworkTopologyStrategy', 'dc1': 1};

CREATE TABLE IF NOT EXISTS movielens.ratings_by_movie (
    user_id int,
    movie_id int,
    rating double,
    rated_at bigint,
    PRIMARY KEY ((movie_id), user_id)
);

CREATE TABLE IF NOT EXISTS movielens.movies (
    movie_id int PRIMARY KEY,
    title text,
    genres text
);