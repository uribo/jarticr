#' Read a JARTIC type B traffic file
#'
#' @description
#' Reads one cross-sectional traffic volume ("type B") CSV file published by
#' the Japan Road Traffic Information Center. The files are headerless and
#' CP932-encoded; this function supplies the column names, converts the
#' encoding, parses `datetime` in JST, and normalizes `location_name` with
#' NFKC.
#'
#' @param path Path to a raw type B file (CSV format).
#' @importFrom data.table `:=` fread setkey
#' @importFrom lubridate ymd_hm
#' @importFrom stringi stri_trans_nfkc
#' @importFrom stringr str_squish
#' @return
#' A `data.table` of 10 columns, keyed on `datetime`:
#' \describe{
#'   \item{datetime}{Observation time (`POSIXct`, `Asia/Tokyo`).}
#'   \item{source_code}{Information source code.}
#'   \item{location_no}{Observation location number.}
#'   \item{location_name}{Observation location, as `from`\out{\U{2192}}`to`.}
#'   \item{meshcode10km}{10 km mesh code.}
#'   \item{link_type}{Link type.}
#'   \item{link_no}{Link number.}
#'   \item{traffic}{Traffic volume; missing observations are `NA`.}
#'   \item{to_link_end_10m}{Distance to the link end, in units of 10 m.
#'     Kept as character because the values are zero-padded.}
#'   \item{link_ver}{Link version.}
#' }
#' @examples
#' read_jartic_traffic(
#'   system.file("dummy", "type_b.csv", package = "jarticr")
#' )
#' @export
read_jartic_traffic <- function(path) {
  datetime <- location_name <- NULL
  d <- data.table::fread(
    path,
    colClasses = c(
      "character",
      "character",
      "integer",
      "character",
      "character",
      "integer",
      "integer",
      "integer",
      "character",
      "integer"
    ),
    col.names = c(
      "datetime",
      "source_code",
      "location_no",
      "location_name",
      "meshcode10km",
      "link_type",
      "link_no",
      "traffic",
      "to_link_end_10m",
      "link_ver"
    ),
    na.strings = c("", "NA"),
    fill = TRUE
  )
  d[,
    c("datetime", "location_name") := list(
      lubridate::ymd_hm(datetime, tz = "Asia/Tokyo"),
      stringi::stri_trans_nfkc(
        stringr::str_squish(
          iconv(location_name, from = "cp932", to = "utf8")
        )
      )
    )
  ]
  data.table::setkey(d, "datetime")
  d
}
