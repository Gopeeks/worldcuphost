#' Get the years a country hosted the World Cup
#'
#' Returns the years in which at least one World Cup match was played in
#' the given country. Co-hosted tournaments, such as 2002 in Japan and
#' South Korea, are counted for each host.
#'
#' @param country A single country name, as it appears in the data
#'   (for example, "Brazil").
#' @param data A data frame of World Cup matches. Defaults to
#'   \code{world_cup_matches}.
#'
#' @return An integer vector of years, sorted from earliest to latest.
#'   Returns an empty vector if the country never hosted.
#' @export
#'
#' @examples
#' get_host_years("Brazil")
get_host_years <- function(country, data = worldcuphost::world_cup_matches) {
  if (!is.character(country) || length(country) != 1) {
    stop("country must be a single country name, such as \"Brazil\".")
  }
  if (!country %in% c(data$home_team, data$away_team)) {
    stop("'", country, "' was not found in the World Cup data. Check the spelling.")
  }
  sort(unique(data$year[data$country == country]))
}

#' Compare a team's World Cup results as host versus not host
#'
#' Summarizes a team's World Cup matches in the years it hosted the
#' tournament and in all other years.
#'
#' @inheritParams get_host_years
#'
#' @return A data frame with one row for hosting years and one for all
#'   other years, giving matches played, win percentage, and goals per game.
#'   Matches decided by penalty shootouts count as draws.
#' @export
#'
#' @examples
#' host_performance("Brazil")
host_performance <- function(country, data = worldcuphost::world_cup_matches) {
  host_years <- get_host_years(country, data)
  if (length(host_years) == 0) {
    stop("'", country, "' has never hosted a World Cup match.")
  }
  games <- data[data$home_team == country | data$away_team == country, ]
  is_home <- games$home_team == country
  goals_for <- ifelse(is_home, games$home_score, games$away_score)
  goals_against <- ifelse(is_home, games$away_score, games$home_score)
  hosting <- games$year %in% host_years
  summarise_group <- function(keep) {
    c(matches = sum(keep),
      win_pct = round(mean(goals_for[keep] > goals_against[keep]) * 100, 1),
      goals_per_game = round(mean(goals_for[keep]), 2))
  }
  result <- as.data.frame(rbind(summarise_group(hosting), summarise_group(!hosting)))
  cbind(hosting = c("Host", "Not host"), result)
}
