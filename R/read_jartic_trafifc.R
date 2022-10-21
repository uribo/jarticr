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
                                  "to_link_end_10m", "link_ver"))
  d[ , c("datetime", "location_name") := list(lubridate::ymd_hm(datetime, tz = "Asia/Tokyo"),
                                              stringi::stri_trans_nfkc(
                                                stringr::str_squish(
                                                  iconv(location_name,
                                                        from = "cp932",
                                                        to = "utf8"))))]
  data.table::setkey(d, "datetime")
  d
}
