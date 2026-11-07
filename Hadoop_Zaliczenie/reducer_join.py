
import sys

current_movie = None
rating_sum = 0.0
rating_count = 0
title = None

def show_result(movie_id, title, total, count):
    if movie_id is not None and title is not None and count > 0:
        average = total / count
        print("{}\t{}\t{:.2f}".format(movie_id, title, average))

for line in sys.stdin:
    parts = line.rstrip('\n').split('\t', 2)
    if len(parts) != 3:
        continue

    movie_id, record_type, value = parts

    if movie_id != current_movie:
        show_result(current_movie, title, rating_sum, rating_count)
        current_movie = movie_id
        rating_sum = 0.0
        rating_count = 0
        title = None

    if record_type == 'M':
        title = value
    elif record_type == 'R':
        rating_sum += float(value)
        rating_count += 1

show_result(current_movie, title, rating_sum, rating_count)
