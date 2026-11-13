#### Preamble ####
# Purpose: Downloads the Toronto red-light camera locations from Open Data Toronto
#          and saves them, unedited, to the inputs folder.
# Author: Amina Mohamed
# Date: 11 November 2026
# Contact: aminanasree.mohamed@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install the opendatatoronto, tidyverse, and sf packages


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(sf)


#### Download data ####
# Name of the dataset ("package") on Open Data Toronto
package_name <- "red-light-cameras"

# Most recently updated GeoJSON, in standard latitude/longitude (EPSG:4326)
resource_name <- "Red Light Cameras Data - 4326.geojson"

resources <- list_package_resources(package_name)

camera_data <-
  resources |>
  filter(name == resource_name) |>
  get_resource()

# Record when the data were downloaded, for citing in the paper
message("Data downloaded on ", format(Sys.Date(), "%d %B %Y"))


#### Save data ####
# The data are saved exactly as downloaded, with no cleaning.
# GeoJSON keeps the coordinates (the geometry column) intact.
st_write(
  camera_data,
  "Inputs/data/unedited_data.geojson",
  delete_dsn = TRUE
)

# Check that the file was saved and has rows
stopifnot(
  file.exists("Inputs/data/unedited_data.geojson"),
  nrow(camera_data) > 0
)