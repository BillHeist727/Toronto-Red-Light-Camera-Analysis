## Preamble ####
# Purpose: Cleans the unedited Toronto red-light camera data and saves an
#          analysis dataset with one row per camera.
# Author: Amina Mohamed
# Date: 12 November 2026
# Contact: aminanasree.mohamed@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run scripts/00-download_data.R, which creates
#                 Inputs/data/unedited_data.geojson


#### Workspace setup ####
library(tidyverse)
library(sf)


#### Clean data ####
raw_data <- st_read("Inputs/data/unedited_data.geojson", quiet = TRUE)

analysis_data <-
  raw_data |>
  # Use lower-case column names
  rename_with(tolower) |>
  # The raw data uses the text "None" for missing values, so make them real NAs
  mutate(across(where(is.character), ~ na_if(.x, "None"))) |>
  mutate(
    # Keep the date part of the activation timestamp. The timestamps all end in
    # T20:00:00, which looks like a time-zone shift, so we only use dates and years.
    activation_date = as_date(ymd_hms(activation_date)),
    activation_year = year(activation_date)
  ) |>
  # Some intersections have more than one camera, so count the cameras at each
  group_by(intersection_id) |>
  mutate(cameras_at_intersection = n()) |>
  ungroup() |>
  # Keep only the variables we use
  select(
    rlc,
    intersection_id,
    name,
    district,
    ward_1,
    police_division_1,
    activation_date,
    activation_year,
    cameras_at_intersection
  ) |>
  # Each camera is a single point on the map
  st_cast("POINT")


#### Save data ####
st_write(
  analysis_data,
  "Outputs/data/analysis_data.geojson",
  delete_dsn = TRUE
)
