#' Create location table for type B
#' @param data type B data
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
