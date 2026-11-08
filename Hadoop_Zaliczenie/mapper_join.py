
import sys
import csv

reader = csv.reader(sys.stdin)

for row in reader:
    if not row:
        continue

    if row[0] in ('userId', 'movieId'):
        continue

    if len(row) == 4:
        movie_id = row[1]
        rating = row[2]
        print("{}\tR\t{}".format(movie_id, rating))

    elif len(row) == 3:
        movie_id = row[0]
        title = row[1]
        print("{}\tM\t{}".format(movie_id, title))
