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

local output = {}
local matched = 0

for _, movie_id in ipairs(movie_ids) do
    local title = redis.call("HGET", "movielens:movie:" .. movie_id, "title")

    if title then
        matched = matched + 1

        if matched <= 20 then
            local stats = totals[movie_id]
            output[#output + 1] = string.format(
                "%d | %s | %.6f", movie_id, title, stats.sum / stats.count
            )
        end
    end
end

table.insert(output, 1, "movieId | tytul | srednia ocena")
table.insert(output, 1, "Liczba filmow z ocenami i tytulem: " .. matched)

return output