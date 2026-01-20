# src/utils/paths.R
library(yaml)
library(here)

get_paths <- function() {
  # Find the config file (works from anywhere in the project)
  config_file <- here::here("config", "config.yml")

  # Check if config exists
  if (!file.exists(config_file)) {
    stop(
      "config.yml not found!\n",
      "Copy config.template.yml to config.yml and fill in your paths.\n",
      "See config/README.md for instructions."
    )
  }

  # Read the YAML file into an R list
  config <- yaml::read_yaml(config_file)

  # Normalize paths for cross-platform compatibility
  config$data_root <- normalizePath(config$data_root, mustWork = TRUE)
  config$output_root <- normalizePath(config$output_root, mustWork = FALSE)

  return(config)
}

# Helper function to build data paths
get_data_path <- function(...) {
  paths <- get_paths()
  file.path(paths$data_root, ...)
}

# Helper function to build output paths
get_output_path <- function(...) {
  paths <- get_paths()
  output_dir <- file.path(paths$output_root, ...)

  # Create directory if it doesn't exist
  dir.create(dirname(output_dir), recursive = TRUE, showWarnings = FALSE)

  return(output_dir)
}
