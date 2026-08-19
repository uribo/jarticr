#' Create the observation location table for type B
#'
#' @description
#' Reduces a type B table to one row per observation location and splits
#' `location_name` into its start and end points on the arrow separator.
#'
#' @param data A type B table, as returned by [read_jartic_traffic()].
#' @return
#' A table of unique locations with `source_code`, `location_no`,
#' `location_from`, `location_to` and `meshcode10km`.
#' @examples
#' d <- read_jartic_traffic(
#'   system.file("dummy", "type_b.csv", package = "jarticr")
#' )
#' jartic_type_b_loc_tiny(d)
#' @export
jartic_type_b_loc_tiny <- function(data) {
  location_name <- NULL
  d <-
    unique(
      data[, jartic_vars$type_B$loc, with = FALSE],
      by = jartic_vars$type_B$loc
    )
  tidyr::separate(
    d,
    location_name,
    into = c("location_from", "location_to"),
    sep = "\u2192"
  )
}

jartic_vars <-
  list(
    type_B = list(
      core = c("datetime", "location_no", "traffic"),
      loc = c("source_code", "location_no", "location_name", "meshcode10km")
    )
  )
