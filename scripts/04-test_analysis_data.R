## Preamble ####
# Purpose: Tests the cleaned red-light camera data.
# Author: Amina Mohamed
# Date: 12 November 2026
# Contact: aminanasree.mohamed@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run scripts/03-clean_data.R first, which creates
#                 Outputs/data/analysis_data.geojson


#### Workspace setup ####
library(tidyverse)
library(sf)

analysis_data <- st_read("Outputs/data/analysis_data.geojson", quiet = TRUE)

districts <- c(
  "Etobicoke York",
  "North York",
  "Scarborough",
  "Toronto and East York"
)

activation_dates <- as.Date(analysis_data$activation_date)
coordinates <- st_coordinates(analysis_data)


#### Test data ####
# stopifnot() stops the script with an error if any check fails
stopifnot(
  # Same number of cameras as the unedited data (301)
  nrow(analysis_data) == 301,
  # Each camera code appears once
  !anyDuplicated(analysis_data$rlc),
  # The 301 cameras sit at 282 distinct intersections
  n_distinct(analysis_data$intersection_id) == 282,
  # Every camera has a valid district
  !any(is.na(analysis_data$district)),
  all(analysis_data$district %in% districts),
  # Every camera has a plausible activation date
  !any(is.na(activation_dates)),
  all(activation_dates >= as.Date("2000-01-01")),
  all(activation_dates <= Sys.Date()),
  # Activation years agree with the dates
  all(analysis_data$activation_year == year(activation_dates)),
  # Every camera is a point inside a box around Toronto
  all(st_geometry_type(analysis_data) == "POINT"),
  all(coordinates[, "X"] > -79.7 & coordinates[, "X"] < -79.1),
  all(coordinates[, "Y"] > 43.5 & coordinates[, "Y"] < 43.9)
)

message("All tests passed")
