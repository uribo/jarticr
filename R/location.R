#' Create location table for type B
#' @param data type B data
#' @export
jartic_type_b_loc_tiny <- function(data) {
  location_name <- NULL
  d <-
    unique(data[, c("source_code",
                    "location_no",
                    "location_name",
                    "meshcode10km"),
                with = FALSE],
           by = c("source_code",
                  "location_no",
                  "location_name",
                  "meshcode10km"))
  tidyr::separate(d,
                  location_name,
                  into = c("location_from", "location_to"),
                  sep = "\u2192")
}
