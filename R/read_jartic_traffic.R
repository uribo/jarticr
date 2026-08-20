#' Read a JARTIC type B traffic file
#'
#' @description
#' Reads one cross-sectional traffic volume ("type B") CSV file published by
#' the Japan Road Traffic Information Center. The files are CP932-encoded and
#' carry a header row; this function drops that row, supplies stable column
#' names, parses `datetime` in JST, and normalizes `location_name` with NFKC.
#'
#' @details
#' The published layout has changed over time, so the header row is inspected
#' before the file is read:
#'
#' * Files from 2018-02 onwards have 10 columns. Earlier files have 9 and no
#'   `link_ver`; for those, `link_ver` is filled with `NA` so that the returned
#'   columns are the same in either case.
#' * A file whose first row is already an observation (no header) is read in
#'   full; the first row is not consumed as a header.
#' * `datetime` is written as `2026/06/01 00:00` by most providers, but the
#'   pre-2018-02 files also use `2017/8/1 0:00:00`. Both are parsed, and values
#'   that survive as `NA` are reported with a warning rather than passed on
#'   silently.
#'
#' Bytes that are not valid CP932 cannot be decoded and leave `NA` in
#' `location_name`. That is reported with a warning too, because the rest of
#' the row still looks intact.
#'
#' @param path Path to a raw type B file (CSV format).
#' @importFrom data.table `:=` fread setkey
#' @importFrom lubridate ymd_hm ymd_hms
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
#'   \item{to_link_end_10m}{Distance to the link end, in units of 10 m. Kept as
#'     character so that whatever the source writes -- padding included --
#'     survives the read.}
#'   \item{link_ver}{Link version; `NA` for files published before 2018-02.}
#' }
#' @examples
#' read_jartic_traffic(
#'   system.file("dummy", "type_b.csv", package = "jarticr")
#' )
#' @export
read_jartic_traffic <- function(path) {
  datetime <- link_ver <- NULL
  layout <- type_b_layout(path)
  d <- data.table::fread(
    path,
    # The layout is settled by type_b_layout(); do not let fread guess it
    # again, or the two reads could disagree about where the data starts.
    header = FALSE,
    sep = ",",
    skip = layout$skip,
    colClasses = layout$col_classes,
    col.names = layout$col_names,
    na.strings = c("", "NA"),
    fill = TRUE
  )
  if (!"link_ver" %in% names(d)) {
    d[, link_ver := NA_integer_]
  }
  raw_name <- d[["location_name"]]
  decoded <- iconv(raw_name, from = "cp932", to = "UTF-8")
  undecodable <- sum(is.na(decoded) & !is.na(raw_name))
  if (undecodable > 0L) {
    warning(
      sprintf(
        "%d location_name value(s) are not valid CP932 and became NA.",
        undecodable
      ),
      call. = FALSE
    )
  }
  d[,
    c("datetime", "location_name") := list(
      parse_type_b_datetime(datetime),
      stringi::stri_trans_nfkc(stringr::str_squish(decoded))
    )
  ]
  data.table::setkey(d, "datetime")
  d
}

# Column names, column types and the number of leading lines to drop, decided
# from the first line of `path`.
#
# Two things vary across the published files: whether `link_ver` is present
# (added in 2018-02) and whether the first line is the header. Both are read
# off the first line, which keeps the caller from having to know the era.
type_b_layout <- function(path) {
  col_names <- c(
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
  )
  col_classes <- c(
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
  )
  # Two lines, so that a file holding nothing but its header can be told
  # apart from one that has observations.
  head_lines <- data.table::fread(
    path,
    nrows = 2L,
    header = FALSE,
    sep = ",",
    colClasses = "character"
  )
  n_col <- ncol(head_lines)
  if (!n_col %in% c(9L, 10L)) {
    stop(
      sprintf(
        "A type B file has 9 or 10 columns, but '%s' has %d.",
        basename(path),
        n_col
      ),
      call. = FALSE
    )
  }
  # An observation always starts with a four-digit year; a header does not.
  # Compare bytes, because the header is CP932 and would not survive being
  # treated as UTF-8.
  is_header <- !grepl("^[0-9]{4}", head_lines[[1L]][[1L]], useBytes = TRUE)
  if (is_header && nrow(head_lines) < 2L) {
    # data.table would stop here too, but on skip= rather than on the file,
    # and a monthly file with no observations is a failed download.
    stop(
      sprintf("'%s' has a header row but no observations.", basename(path)),
      call. = FALSE
    )
  }
  keep <- seq_len(n_col)
  list(
    col_names = col_names[keep],
    col_classes = col_classes[keep],
    skip = as.integer(is_header)
  )
}

# Parse the `datetime` column, allowing for the second format used before
# 2018-02. Values that neither format accepts stay NA, which is worth a
# warning: nothing else in the row shows that the time was lost.
parse_type_b_datetime <- function(x) {
  parsed <- suppressWarnings(lubridate::ymd_hm(x, tz = "Asia/Tokyo"))
  retry <- is.na(parsed) & !is.na(x)
  if (any(retry)) {
    parsed[retry] <- suppressWarnings(
      lubridate::ymd_hms(x[retry], tz = "Asia/Tokyo")
    )
  }
  unparsed <- sum(is.na(parsed) & !is.na(x))
  if (unparsed > 0L) {
    warning(
      sprintf(
        "%d datetime value(s) could not be parsed and became NA.",
        unparsed
      ),
      call. = FALSE
    )
  }
  parsed
}
