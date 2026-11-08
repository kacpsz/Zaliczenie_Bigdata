
import sys

current_movie = None
rating_sum = 0.0
rating_count = 0

for line in sys.stdin:
    movie_id, rating = line.strip().split('\t')
    rating = float(rating)

    if current_movie != movie_id:
        if current_movie is not None:
            average = rating_sum / rating_count
            print("{}\t{:.2f}".format(current_movie, average))

        current_movie = movie_id
        rating_sum = 0.0
        rating_count = 0

    rating_sum += rating
    rating_count += 1

if current_movie is not None:
    average = rating_sum / rating_count
    print("{}\t{:.2f}".format(current_movie, average))
