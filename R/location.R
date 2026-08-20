#' Create the observation location table for type B
#'
#' @description
#' Reduces a type B table to one row per observation location and splits
#' `location_name` into its start and end points on the arrow separator.
#'
#' @details
#' The name is split on the *first* arrow (\out{\U{2192}}) only, which makes
#' the result well defined for every value:
#'
#' * no arrow: the whole name stays in `location_from` and `location_to` is
#'   `NA`;
#' * more than one arrow: everything after the first arrow is kept in
#'   `location_to`, so no part of the original name is discarded;
#' * `NA`: both columns are `NA`.
#'
#' @param data A type B table, as returned by [read_jartic_traffic()].
#' @importFrom data.table setcolorder
#' @importFrom stringi stri_split_fixed
#' @return
#' A `data.table` of unique locations with `source_code`, `location_no`,
#' `location_from`, `location_to` and `meshcode10km`.
#' @examples
#' d <- read_jartic_traffic(
#'   system.file("dummy", "type_b.csv", package = "jarticr")
#' )
#' jartic_type_b_loc_tiny(d)
#' @export
jartic_type_b_loc_tiny <- function(data) {
  d <-
    unique(
      data[, jartic_vars$type_B$loc, with = FALSE],
      by = jartic_vars$type_B$loc
    )
  pieces <- stringi::stri_split_fixed(
    d[["location_name"]],
    "\u2192",
    n = 2L,
    simplify = NA
  )
  d[,
    c("location_from", "location_to", "location_name") := list(
      pieces[, 1L],
      pieces[, 2L],
      NULL
    )
  ]
  data.table::setcolorder(
    d,
    c(
      "source_code",
      "location_no",
      "location_from",
      "location_to",
      "meshcode10km"
    )
  )
  d[]
}

jartic_vars <-
  list(
    type_B = list(
      core = c("datetime", "location_no", "traffic"),
      loc = c("source_code", "location_no", "location_name", "meshcode10km")
    )
  )
