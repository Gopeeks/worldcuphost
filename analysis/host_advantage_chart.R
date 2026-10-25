# Builds the checkpoint chart: each host nation's World Cup win percentage
# when hosting vs. not hosting. Run from the package root after
# devtools::load_all(). Uses ggplot2, which is not a package dependency.

library(ggplot2)

hosts <- sort(unique(world_cup_matches$country))
rows <- lapply(hosts, function(h) {
  p <- host_performance(h)
  data.frame(country = h,
             host_years = paste(get_host_years(h), collapse = ", "),
             host_matches = p$matches[1],
             host_win = p$win_pct[1],
             away_win = p$win_pct[2])
})
summary_table <- do.call(rbind, rows)
summary_table$label <- paste0(summary_table$country, " (",
                              summary_table$host_years, ")  n=",
                              summary_table$host_matches)
summary_table$label <- factor(summary_table$label,
  levels = summary_table$label[order(summary_table$host_win - summary_table$away_win)])

# Not-hosting points first so hosting points draw on top when they overlap
long <- rbind(
  data.frame(label = summary_table$label, group = "Not hosting", win = summary_table$away_win),
  data.frame(label = summary_table$label, group = "Hosting", win = summary_table$host_win)
)

host_col <- "#2a78d6"
away_col <- "#eb6834"

chart <- ggplot() +
  geom_segment(data = summary_table,
               aes(x = away_win, xend = host_win, y = label, yend = label),
               colour = "#c3c2b7", linewidth = 1) +
  geom_point(data = long, aes(x = win, y = label, colour = group), size = 3) +
  scale_colour_manual(breaks = c("Hosting", "Not hosting"),
                      values = c("Hosting" = host_col, "Not hosting" = away_col),
                      name = NULL) +
  scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 25),
                     labels = function(x) paste0(x, "%")) +
  labs(title = "Most World Cup hosts win more often at home",
       subtitle = "Win percentage in hosting years vs. all other World Cups, 1930-2026.\nn = matches played as host. Sorted by the size of the gap. Shootouts count as draws.",
       x = "Win percentage", y = NULL,
       caption = "Data: J\u00fcrisoo, International Football Results (Kaggle). Chart: worldcuphost package.") +
  theme_minimal(base_size = 11) +
  theme(legend.position = "top", legend.justification = "left",
        panel.grid.major.y = element_blank(), panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold"),
        plot.title.position = "plot", plot.caption.position = "plot",
        plot.subtitle = element_text(colour = "#555555"),
        plot.caption = element_text(colour = "#777777", hjust = 0),
        plot.background = element_rect(fill = "white", colour = NA))

ggsave("analysis/host_advantage.png", chart, width = 7.5, height = 6, dpi = 300)

# Pooled comparison across all hosts
pooled <- do.call(rbind, lapply(hosts, function(h) {
  p <- host_performance(h)
  data.frame(group = p$hosting, matches = p$matches,
             wins = round(p$matches * p$win_pct / 100))
}))
print(aggregate(cbind(matches, wins) ~ group, pooled, sum))
print(summary_table[, c("country", "host_years", "host_matches", "host_win", "away_win")])
