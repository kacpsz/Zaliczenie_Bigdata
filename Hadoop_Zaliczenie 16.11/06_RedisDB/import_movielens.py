import csv
import sys
from pathlib import Path

import redis


data_dir = Path(__file__).resolve().parent.parent / "Dane"
env_file = Path(sys.argv[1])

with env_file.open(encoding="utf-8-sig") as source:
    for line in source:
        name, separator, value = line.strip().partition("=")
        if separator and name.strip() == "REDIS_PASSWORD":
            password = value.strip().strip('"').strip("'")
            break
    else:
        raise SystemExit("Brak REDIS_PASSWORD w pliku .env.")

client = redis.Redis(host="localhost", port=6379, password=password)
client.ping()


def import_csv(filename, key_prefix, id_fields):
    count = 0
    with (data_dir / filename).open(encoding="utf-8-sig", newline="") as source:
        with client.pipeline(transaction=False) as batch:
            for row in csv.DictReader(source):
                record_id = ":".join(row[field] for field in id_fields)
                batch.hset(f"{key_prefix}:{record_id}", mapping=row)
                count += 1

                if count % 1000 == 0:
                    batch.execute()

            batch.execute()

    return count


ratings = import_csv("ratings.csv", "movielens:rating", ("userId", "movieId"))
movies = import_csv("movies.csv", "movielens:movie", ("movieId",))

print(f"Zapisano ocen: {ratings}")
print(f"Zapisano filmów: {movies}")