results <- read.csv("data-raw/results.csv")

world_cup_matches <- results[results$tournament == "FIFA World Cup", ]
world_cup_matches$date <- as.Date(world_cup_matches$date)
world_cup_matches$year <- as.integer(format(world_cup_matches$date, "%Y"))
world_cup_matches$tournament <- NULL
rownames(world_cup_matches) <- NULL

usethis::use_data(world_cup_matches, overwrite = TRUE)
