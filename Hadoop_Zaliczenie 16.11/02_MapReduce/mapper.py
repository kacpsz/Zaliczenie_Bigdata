
import sys
import csv

reader = csv.reader(sys.stdin)

for row in reader:
    if row[0] == 'userId':
        continue

    movie_id = row[1]
    rating = float(row[2])

    print("{}\t{}".format(movie_id, rating))
