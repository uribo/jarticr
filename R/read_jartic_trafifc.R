#' Read jartic traffic file
#'
#' @description read type B file
#' @param path path to raw data (csv format)
#' @importFrom data.table `:=` fread setkey
#' @importFrom lubridate ymd_hm
#' @importFrom stringi stri_trans_nfkc
#' @importFrom stringr str_squish
#' @return data.frame (data.table)
#' @export
read_jartic_traffic <- function(path) {
  datetime <- location_name  <- NULL
  d <- data.table::fread(path,
                    colClasses = c("character", "character", "integer", "character", "character",
                                   "integer","integer", "integer", "character", "integer"),
                    col.names = c("datetime", "source_code", "location_no", "location_name",
                                  "meshcode10km", "link_type", "link_no", "traffic",
                                  "to_link_end_10m", "link_ver"),
                    na.strings = c("", "NA"),
                    fill = TRUE)
  d[ , c("datetime", "location_name") := list(lubridate::ymd_hm(datetime, tz = "Asia/Tokyo"),
                                              stringi::stri_trans_nfkc(
                                                stringr::str_squish(
                                                  iconv(location_name,
                                                        from = "cp932",
                                                        to = "utf8"))))]
  data.table::setkey(d, "datetime")
  d
}

arrow_schema <- list(
  typeB = arrow::schema(
    datetime = arrow::timestamp(unit = "ms", timezone = "Asia/Tokyo"),
    source_code = arrow::utf8(),
    location_no = arrow::int32(),
    location_name = arrow::utf8(),
    meshcode10km = arrow::utf8(),
    link_type = arrow::int32(),
    link_no = arrow::int32(),
    traffic = arrow::int32(),
    to_link_end_10m = arrow::utf8(),
    link_ver = arrow::int32(),
    year = arrow::int32(),
    month = arrow::int32())
)
