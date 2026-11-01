# worldcuphost

worldcuphost measures whether national teams have a home country advantage in the FIFA World Cup. It compares how a team performs in the years its country hosts the tournament versus all other years.

## Who it's for

Sports analysts, students, and anyone involved in World Cup hosting decisions. Countries usually host for tourism and revenue, and this package helps show whether hosting also helps the team on the field.

## Installation

```r
# install.packages("devtools")
devtools::install_github("Gopeeks/worldcuphost")
```

## Basic usage

```r
library(worldcuphost)

# Years a country hosted the World Cup
get_host_years("Brazil")
#> [1] 1950 2014

# Results when hosting vs. not hosting
host_performance("Brazil")
```

## How hosts are defined

A country counts as the host in any year a World Cup match was played there, based on the match location in the data. This means co-hosted tournaments, like Japan and South Korea in 2002 or the United States, Canada, and Mexico in 2026, count for each host.

## Limitations

- Matches decided by penalty shootouts are recorded as draws, so win percentage slightly undercounts wins in knockout matches.
- Some countries have very few home matches (Brazil has 13), so results for a single country can swing a lot.

## Data

The package includes world_cup_matches, a dataset of every men's World Cup match from 1930 to 2026, taken from Mart Jürisoo's international football results dataset on Kaggle.
