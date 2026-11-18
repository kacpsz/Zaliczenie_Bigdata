const movielens = db.getSiblingDB("movielens");

const averagesWithTitles = movielens.ratings.aggregate([
  {
    $group: {
      _id: "$movieId",
      averageRating: { $avg: "$rating" }
    }
  },
  {
    $lookup: {
      from: "movies",
      localField: "_id",
      foreignField: "movieId",
      as: "movie"
    }
  },
  { $unwind: "$movie" },
  { $sort: { _id: 1 } },
  {
    $project: {
      _id: 0,
      movieId: "$_id",
      title: "$movie.title",
      averageRating: 1
    }
  }
]).toArray();

print(`Liczba filmów z ocenami i tytułem: ${averagesWithTitles.length}`);
console.table(averagesWithTitles.slice(0, 20));