local totals = {}
local seen = {}
local cursor = "0"

repeat
    local page = redis.call("SCAN", cursor, "MATCH", "movielens:rating:*", "COUNT", 1000)
    cursor = page[1]

    for _, key in ipairs(page[2]) do
        if not seen[key] then
            seen[key] = true
            local fields = redis.call("HMGET", key, "movieId", "rating")
            local movie_id = tonumber(fields[1])
            local rating = tonumber(fields[2])

            if movie_id and rating then
                local stats = totals[movie_id]
                if not stats then
                    stats = {sum = 0, count = 0}
                    totals[movie_id] = stats
                end
                stats.sum = stats.sum + rating
                stats.count = stats.count + 1
            end
        end
    end
until cursor == "0"

local movie_ids = {}
for movie_id in pairs(totals) do
    movie_ids[#movie_ids + 1] = movie_id
end
table.sort(movie_ids)

local output = {
    "Liczba filmow z ocenami: " .. #movie_ids,
    "movieId | srednia ocena"
}
for i = 1, math.min(20, #movie_ids) do
    local movie_id = movie_ids[i]
    local stats = totals[movie_id]
    output[#output + 1] = string.format("%d | %.6f", movie_id, stats.sum / stats.count)
end

return output