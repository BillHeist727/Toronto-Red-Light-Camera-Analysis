#### Preamble ####
# Purpose: Simulates a dataset of Toronto red-light cameras, with one row per
#          camera location, to plan the cleaning, tests, and graphs.
# Author: Amina Mohamed
# Date: 11 November 2026
# Contact: aminanasree.mohamed@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install the tidyverse package with install.packages("tidyverse")


#### Workspace setup ####
library(tidyverse)

# A seed makes the random numbers the same every time the script runs
set.seed(123)


#### Simulate data ####
# We only simulate the variables we plan to use, not all 27 columns in the raw data.
n_cameras <- 301 # number of rows in the real data

districts <- c(
  "Etobicoke York",
  "North York",
  "Scarborough",
  "Toronto and East York"
)

simulated_data <-
  tibble(
    # Each camera has its own identifier
    rlc_id = as.character(6001:(6000 + n_cameras)),
    # Each camera sits in one of the four districts
    district = sample(districts, size = n_cameras, replace = TRUE),
    # Activation dates are drawn from a plausible range of days
    activation_date = sample(
      seq(as.Date("2007-01-01"), as.Date("2023-12-31"), by = "day"),
      size = n_cameras,
      replace = TRUE
    ),
    # Coordinates fall inside a box around the City of Toronto
    longitude = runif(n_cameras, min = -79.64, max = -79.12),
    latitude = runif(n_cameras, min = 43.58, max = 43.85)
  ) |>
  mutate(activation_year = year(activation_date))


#### Test simulated data ####
# stopifnot() stops the script with an error if any of these checks fail
stopifnot(
  nrow(simulated_data) == n_cameras,
  !anyDuplicated(simulated_data$rlc_id),
  all(simulated_data$district %in% districts),
  all(simulated_data$activation_date >= as.Date("2007-01-01")),
  all(simulated_data$latitude >= 43.58 & simulated_data$latitude <= 43.85)
)


#### Preview ####
simulated_data |> count(district)
simulated_data |> count(activation_year)
