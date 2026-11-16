const movielens = db.getSiblingDB("movielens");

const averages = movielens.ratings.aggregate([
  {
    $group: {
      _id: "$movieId",
      averageRating: { $avg: "$rating" }
    }
  },
  { $sort: { _id: 1 } },
  {
    $project: {
      _id: 0,
      movieId: "$_id",
      averageRating: 1
    }
  }
]).toArray();

print(`Liczba filmów z ocenami: ${averages.length}`);
console.table(averages.slice(0, 20));