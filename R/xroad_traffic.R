xroad_common_properties <- c(
  "\u5730\u65B9\u6574\u5099\u5C40\u7B49\u756A\u53F7" = "regional_bureau_code",
  "\u958B\u767A\u5EFA\u8A2D\u90E8\uFF0F\u90FD\u9053\u5E9C\u770C\u30B3\u30FC\u30C9" = "development_bureau_prefecture_code",
  "\u5E38\u6642\u89B3\u6E2C\u70B9\u30B3\u30FC\u30C9" = "station_code",
  "\u53CE\u96C6\u6642\u9593\u30D5\u30E9\u30B0\uFF085\u5206\u9593\uFF0F1\u6642\u9593\uFF09" = "collection_interval",
  "\u89B3\u6E2C\u5E74\u6708\u65E5" = "observation_date",
  "\u6642\u9593\u5E2F" = "time_slot"
)

xroad_fixed_properties <- c(
  "\u4E0A\u308A\u30FB\u5C0F\u578B\u4EA4\u901A\u91CF" = "up_small_volume",
  "\u4E0A\u308A\u30FB\u5927\u578B\u4EA4\u901A\u91CF" = "up_large_volume",
  "\u4E0A\u308A\u30FB\u8ECA\u7A2E\u5224\u5225\u4E0D\u80FD\u4EA4\u901A\u91CF" = "up_unclassified_volume",
  "\u4E0A\u308A\u30FB\u505C\u96FB" = "up_power_outage_status",
  "\u4E0A\u308A\u30FB\u30EB\u30FC\u30D7\u7570\u5E38" = "up_loop_error_status",
  "\u4E0A\u308A\u30FB\u8D85\u97F3\u6CE2\u7570\u5E38" = "up_ultrasonic_error_status",
  "\u4E0A\u308A\u30FB\u6B20\u6E2C" = "up_missing_status",
  "\u4E0B\u308A\u30FB\u5C0F\u578B\u4EA4\u901A\u91CF" = "down_small_volume",
  "\u4E0B\u308A\u30FB\u5927\u578B\u4EA4\u901A\u91CF" = "down_large_volume",
  "\u4E0B\u308A\u30FB\u8ECA\u7A2E\u5224\u5225\u4E0D\u80FD\u4EA4\u901A\u91CF" = "down_unclassified_volume",
  "\u4E0B\u308A\u30FB\u505C\u96FB" = "down_power_outage_status",
  "\u4E0B\u308A\u30FB\u30EB\u30FC\u30D7\u7570\u5E38" = "down_loop_error_status",
  "\u4E0B\u308A\u30FB\u8D85\u97F3\u6CE2\u7570\u5E38" = "down_ultrasonic_error_status",
  "\u4E0B\u308A\u30FB\u6B20\u6E2C" = "down_missing_status"
)

xroad_cctv_properties <- c(
  "\u4E0A\u308A\u30FB\u81EA\u52D5\u8ECA\u4EA4\u901A\u91CF\uFF08\u96C6\u8A08\u5024\uFF09" = "up_total_volume",
  "\u4E0A\u308A\u30FB\u5C0F\u578B\u4EA4\u901A\u91CF\uFF08\u96C6\u8A08\u5024\uFF09" = "up_small_volume",
  "\u4E0A\u308A\u30FB\u5927\u578B\u4EA4\u901A\u91CF\uFF08\u96C6\u8A08\u5024\uFF09" = "up_large_volume",
  "\u4E0A\u308A\u30FB\u5C0F\u578B\u5927\u578B\u5224\u5225\u4E0D\u80FD\u4EA4\u901A\u91CF\uFF08\u96C6\u8A08\u5024\uFF09" = "up_unclassified_volume",
  "\u4E0B\u308A\u30FB\u81EA\u52D5\u8ECA\u4EA4\u901A\u91CF\uFF08\u96C6\u8A08\u5024\uFF09" = "down_total_volume",
  "\u4E0B\u308A\u30FB\u5C0F\u578B\u4EA4\u901A\u91CF\uFF08\u96C6\u8A08\u5024\uFF09" = "down_small_volume",
  "\u4E0B\u308A\u30FB\u5927\u578B\u4EA4\u901A\u91CF\uFF08\u96C6\u8A08\u5024\uFF09" = "down_large_volume",
  "\u4E0B\u308A\u30FB\u5C0F\u578B\u5927\u578B\u5224\u5225\u4E0D\u80FD\u4EA4\u901A\u91CF\uFF08\u96C6\u8A08\u5024\uFF09" = "down_unclassified_volume",
  "\u30AB\u30E1\u30E9\u30D7\u30EA\u30BB\u30C3\u30C8\u4F4D\u7F6E" = "camera_preset_position_status",
  "\u6C17\u8C61\u5F71\u97FF\u306B\u3088\u308B\u6620\u50CF\u4E0D\u826F" = "weather_image_failure_status",
  "\u7167\u5EA6\u4E0D\u8DB3" = "insufficient_illumination_status",
  "\u7A81\u767A\u4E8B\u8C61\uFF08\u4EA4\u901A\u4E8B\u6545\u7B49\uFF09" = "sudden_event_status",
  "\u30B5\u30FC\u30D0\u306E\u7A3C\u50CD" = "server_operation_status",
  "\u30AB\u30E1\u30E9\u306E\u6620\u50CF\u53D7\u4FE1" = "camera_video_reception_status",
  "\u6620\u50CF\u306E\u30C7\u30B3\u30FC\u30C9\u51E6\u7406" = "video_decode_status",
  "\u30C7\u30B3\u30FC\u30C9\u6620\u50CF\u304B\u3089\u6620\u50CF\u89E3\u6790\u6A5F\u80FD\u3078\u306E\u53D6\u8FBC\u52A0\u5DE5\u51E6\u7406\u306E\u5931\u6557" = "ingestion_processing_failure_status",
  "\u6620\u50CF\u89E3\u6790\u6A5F\u80FD\u306E\u30D5\u30EA\u30FC\u30BA" = "video_analysis_freeze_status",
  "\u305D\u306E\u4ED6\u30A8\u30E9\u30FC" = "other_error_status"
)

# Form 4 map verified against t1_form4_shikoku.json and t3_form4_kinki.json.
xroad_cctv_hourly_properties <- c(
  "\u4E0A\u308A\u30FB\u81EA\u52D5\u8ECA\u4EA4\u901A\u91CF" = "up_total_volume",
  "\u4E0A\u308A\u30FB\u5C0F\u578B\u4EA4\u901A\u91CF" = "up_small_volume",
  "\u4E0A\u308A\u30FB\u5927\u578B\u4EA4\u901A\u91CF" = "up_large_volume",
  "\u4E0A\u308A\u30FB\u5C0F\u578B\u5927\u578B\u5224\u5225\u4E0D\u80FD\u4EA4\u901A\u91CF" = "up_unclassified_volume",
  "\u4E0A\u308A\u30FB5\u5206\u6B20\u6E2C\u51E6\u7406\u30D5\u30E9\u30B0" = "up_five_minute_missing_processing_flag",
  "\u4E0B\u308A\u30FB\u81EA\u52D5\u8ECA\u4EA4\u901A\u91CF" = "down_total_volume",
  "\u4E0B\u308A\u30FB\u5C0F\u578B\u4EA4\u901A\u91CF" = "down_small_volume",
  "\u4E0B\u308A\u30FB\u5927\u578B\u4EA4\u901A\u91CF" = "down_large_volume",
  "\u4E0B\u308A\u30FB\u5C0F\u578B\u5927\u578B\u5224\u5225\u4E0D\u80FD\u4EA4\u901A\u91CF" = "down_unclassified_volume",
  "\u4E0B\u308A\u30FB5\u5206\u6B20\u6E2C\u51E6\u7406\u30D5\u30E9\u30B0" = "down_five_minute_missing_processing_flag"
)

xroad_trailing_properties <- c(
  "\u9053\u8DEF\u7A2E\u5225" = "road_type",
  "\u6642\u9593\u30B3\u30FC\u30C9" = "time_code"
)

#' Build an xROAD traffic-volume API request
#'
#' @description
#' Builds a WFS `GetFeature` request from typed traffic constraints. This
#' function only constructs an `httr2_request`; it does not access the network.
#'
#' @param interval Aggregation interval: `"5m"` or `"1h"`.
#' @param counter_type Counter type: `"fixed"` for a permanent traffic counter
#'   or `"cctv"` for an image-recognition counter.
#' @param road_type Road type: `1` for a national expressway or `3` for a
#'   general national highway. Required unless `cql_filter` is supplied.
#' @param time_code One `YYYYMMDDhhmm` value, or two values defining a closed
#'   range. Required unless `cql_filter` is supplied. Minutes must be a multiple
#'   of 5 for 5-minute layers and `00` for hourly layers.
#' @param bbox Optional numeric `c(xmin, ymin, xmax, ymax)` bounding box.
#' @param station_code Optional station code, supplied as digits.
#' @param cql_filter Optional raw CQL escape hatch. It cannot be combined with
#'   the typed filter arguments and must not contain double quotes. The API
#'   rejects the double-quoted field names printed in its own specification.
#' @param output_format Response format: `"geojson"` or `"csv"`.
#' @param throttle_seconds Minimum average interval in seconds between
#'   requests in the same throttle pool. Defaults to 3 seconds.
#' @param max_tries Maximum number of attempts for transport failures, HTTP
#'   429, and HTTP 5xx responses. Use 1 to disable retries.
#' @return An `httr2_request`.
#'
#' @details
#' The deployed service ignores the WFS `count` parameter. Large requests are
#' instead limited by a 6,291,556-byte response cap, returned as an HTTP 200
#' error body. Split the time range or shrink the bounding box when that occurs.
#' An empty response is a successful, typed zero-row result; the API does not
#' distinguish an aged-out time window from a bounding box with no stations.
#'
#' @section Data source, quality, and attribution:
#' The xROAD traffic-volume API provides reference values owned by the
#' Ministry of Land, Infrastructure, Transport and Tourism (MLIT), not JARTIC
#' type B data. The data guide states that
#' 「事前に職員によるデータチェック等は実施していない」 and warns that
#' observation accuracy can vary with environmental and equipment conditions.
#'
#' When publishing unprocessed API data, the terms require the attribution
#' 「交通量 API（国土交通省）機能による交通量(参考値)」. For processed data,
#' use 「国土交通省 API 機能による交通量(参考値)を加工して作成」. Do not
#' publish results in a manner suggesting that MLIT authored them.
#'
#' @examples
#' req <- xroad_build_request(
#'   interval = "5m",
#'   counter_type = "fixed",
#'   road_type = 3,
#'   time_code = 202608131900,
#'   bbox = c(134.45, 33.95, 134.70, 34.15)
#' )
#' req
#' @export
xroad_build_request <- function(
  interval,
  counter_type,
  road_type = NULL,
  time_code = NULL,
  bbox = NULL,
  station_code = NULL,
  cql_filter = NULL,
  output_format = c("geojson", "csv"),
  throttle_seconds = 3,
  max_tries = 3
) {
  interval <- match.arg(interval, c("5m", "1h"))
  counter_type <- match.arg(counter_type, c("fixed", "cctv"))
  output_format <- match.arg(output_format)
  layer <- xroad_layer(interval, counter_type)
  cql_filter <- xroad_cql_filter(
    interval = interval,
    road_type = road_type,
    time_code = time_code,
    bbox = bbox,
    station_code = station_code,
    cql_filter = cql_filter
  )
  xroad_assert_positive_number(throttle_seconds, "throttle_seconds")
  xroad_assert_positive_integer(max_tries, "max_tries")

  req <- httr2::request("https://api.jartic-open-traffic.org/geoserver") |>
    httr2::req_url_query(
      service = "WFS",
      version = "2.0.0",
      request = "GetFeature",
      typeNames = layer,
      srsName = "EPSG:4326",
      outputFormat = if (output_format == "geojson") {
        "application/json"
      } else {
        "csv"
      },
      exceptions = "application/json",
      cql_filter = cql_filter
    )

  req <- req |>
    httr2::req_user_agent(
      "jarticr (https://github.com/uribo/jarticr)"
    ) |>
    httr2::req_throttle(
      capacity = 1,
      fill_time_s = throttle_seconds,
      realm = "jarticr-xroad-traffic"
    ) |>
    httr2::req_error(is_error = \(resp) FALSE)

  if (max_tries > 1L) {
    req <- httr2::req_retry(
      req,
      max_tries = max_tries,
      retry_on_failure = TRUE,
      is_transient = \(resp) {
        status <- httr2::resp_status(resp)
        status == 429L || (status >= 500L && status <= 599L)
      }
    )
  }
  req
}

#' Perform an xROAD traffic-volume API request
#'
#' @description
#' Performs a request created by [xroad_build_request()] and returns its body.
#' The body is not interpreted here, because the API can return error payloads
#' with a successful HTTP status. Pass the result to [xroad_parse_traffic()].
#'
#' @param request An `httr2_request`, normally from [xroad_build_request()].
#' @return The response body as a length-one character vector.
#' @inheritSection xroad_build_request Data source, quality, and attribution
#' @export
xroad_perform_request <- function(request) {
  if (!inherits(request, "httr2_request")) {
    stop("`request` must be an httr2_request.", call. = FALSE)
  }
  request |>
    httr2::req_perform() |>
    httr2::resp_body_string()
}

#' Parse an xROAD traffic-volume API response
#'
#' @description
#' Parses a saved GeoJSON or JSON-encoded CSV response without making a network
#' request. It detects API error payloads from their content, verifies GeoJSON
#' completeness, maps Japanese properties to stable English names, and
#' preserves all status flags. CSV and GeoJSON return identical schemas; CSV
#' retains the service's higher coordinate precision.
#'
#' @details
#' A well-formed empty collection is returned as a fully typed zero-row table.
#' It can mean either that the time is outside the available window or that no
#' station matches the spatial filter; the API does not distinguish them.
#' CCTV 5-minute status flags preserve an empty string as the observed
#' indeterminate state. Form 4 returns `time_slot` as a two-digit hour (`19`),
#' while every other recorded form returns `hhmm` (`1900`); `time_slot` is kept
#' unnormalized. `datetime` is derived from the unambiguous 12-digit
#' `time_code`. Recorded form 4 processing flags are `"0"` and `"2"`, although
#' the specification documents `"1"` and `"2"`; the character values are kept
#' without domain validation.
#'
#' @param body A length-one response string or the path to a saved response.
#' @inheritParams xroad_build_request
#' @return A `data.table` keyed on `station_code` and `datetime`. Traffic counts
#'   are integers and missing counts remain `NA_integer_`. Status flags remain
#'   character values: `"0"`, `"1"`, or `""` when the CCTV service could not
#'   judge a flag. `longitude` and `latitude` contain the first point of each
#'   `MultiPoint` geometry.
#'
#' @section Errors:
#' API failures have the shared parent class `xroad_api_error`. More specific
#' classes are `xroad_truncation_error`, `xroad_payload_cap_error`,
#' `xroad_malformed_request_error`, and `xroad_response_error`.
#' @inheritSection xroad_build_request Data source, quality, and attribution
#' @export
xroad_parse_traffic <- function(body, interval, counter_type) {
  interval <- match.arg(interval, c("5m", "1h"))
  counter_type <- match.arg(counter_type, c("fixed", "cctv"))
  layer <- xroad_layer(interval, counter_type)
  text <- xroad_read_body(body)
  trimmed <- trimws(text)

  if (grepl("<ows:ExceptionReport", trimmed, fixed = TRUE)) {
    xroad_abort_ows(trimmed)
  }

  # The recorded API Gateway HTTP 400 body is almost JSON, but escapes single
  # quotes as \\', which JSON does not permit. Normalize that observed defect so
  # the message can still be classified and surfaced to the caller.
  json_text <- gsub("\\'", "'", trimmed, fixed = TRUE)
  parsed <- tryCatch(
    jsonlite::fromJSON(json_text, simplifyVector = FALSE),
    error = function(cnd) {
      xroad_abort(
        "xroad_response_error",
        paste0(
          "The xROAD response is neither valid JSON nor an OWS exception: ",
          conditionMessage(cnd)
        )
      )
    }
  )

  if (is.character(parsed) && length(parsed) == 1L) {
    return(xroad_parse_csv(parsed, layer))
  }
  if (!is.list(parsed)) {
    xroad_abort(
      "xroad_response_error",
      "The xROAD response is neither a response object nor JSON-encoded CSV."
    )
  }

  if (!is.null(parsed$errorMessage) || !is.null(parsed$errorType)) {
    message <- xroad_scalar_character(parsed$errorMessage)
    type <- xroad_scalar_character(parsed$errorType)
    if (
      identical(type, "Function.ResponseSizeTooLarge") ||
        grepl("payload size exceeded", message, ignore.case = TRUE)
    ) {
      xroad_abort(
        "xroad_payload_cap_error",
        paste(
          "The xROAD response exceeded the approximately 6 MB payload cap.",
          "Split the request into a smaller time range or bounding box."
        )
      )
    }
  }

  if (!is.null(parsed$message)) {
    xroad_abort(
      "xroad_malformed_request_error",
      paste0(
        "The xROAD API rejected the request: ",
        xroad_scalar_character(parsed$message)
      )
    )
  }

  if (!is.list(parsed) || !identical(parsed$type, "FeatureCollection")) {
    xroad_abort(
      "xroad_response_error",
      "The xROAD response is not a GeoJSON FeatureCollection."
    )
  }

  features <- parsed$features
  if (is.null(features)) {
    features <- list()
  }
  if (!is.list(features)) {
    xroad_abort(
      "xroad_response_error",
      "The xROAD FeatureCollection has a non-list `features` member."
    )
  }

  number_matched <- xroad_required_count(parsed$numberMatched, "numberMatched")
  number_returned <- xroad_required_count(
    parsed$numberReturned,
    "numberReturned"
  )
  if (number_matched > number_returned) {
    xroad_abort(
      "xroad_truncation_error",
      sprintf(
        paste(
          "The xROAD response was truncated: numberMatched is %d but",
          "numberReturned is %d. Narrow the time range or bounding box."
        ),
        number_matched,
        number_returned
      )
    )
  }
  if (length(features) != number_returned) {
    xroad_abort(
      "xroad_truncation_error",
      sprintf(
        paste(
          "The xROAD response is incomplete: features contains %d records but",
          "numberReturned is %d. Narrow the time range or bounding box."
        ),
        length(features),
        number_returned
      )
    )
  }

  property_map <- xroad_property_map(layer)
  column_types <- xroad_column_types(layer)
  if (length(features) == 0L) {
    return(xroad_empty_table(column_types))
  }

  rows <- lapply(features, xroad_parse_feature, property_map = property_map)
  out <- data.table::rbindlist(rows, use.names = TRUE)
  out <- xroad_cast_columns(out, column_types)
  data.table::setkeyv(out, c("station_code", "datetime"))
  out
}

#' Retrieve xROAD traffic-volume data
#'
#' @description
#' Convenience wrapper that composes [xroad_build_request()],
#' [xroad_perform_request()], and [xroad_parse_traffic()].
#'
#' @inheritParams xroad_build_request
#' @return A `data.table` as described by [xroad_parse_traffic()].
#' @inheritSection xroad_build_request Data source, quality, and attribution
#' @export
xroad_get_traffic <- function(
  interval,
  counter_type,
  road_type = NULL,
  time_code = NULL,
  bbox = NULL,
  station_code = NULL,
  cql_filter = NULL,
  output_format = c("geojson", "csv"),
  throttle_seconds = 3,
  max_tries = 3
) {
  req <- xroad_build_request(
    interval = interval,
    counter_type = counter_type,
    road_type = road_type,
    time_code = time_code,
    bbox = bbox,
    station_code = station_code,
    cql_filter = cql_filter,
    output_format = output_format,
    throttle_seconds = throttle_seconds,
    max_tries = max_tries
  )
  body <- xroad_perform_request(req)
  xroad_parse_traffic(body, interval = interval, counter_type = counter_type)
}

xroad_layer <- function(interval, counter_type) {
  unname(c(
    "5m.fixed" = "t_travospublic_measure_5m",
    "1h.fixed" = "t_travospublic_measure_1h",
    "5m.cctv" = "t_travospublic_measure_5m_img",
    "1h.cctv" = "t_travospublic_measure_1h_img"
  )[[paste(interval, counter_type, sep = ".")]])
}

xroad_cql_filter <- function(
  interval,
  road_type,
  time_code,
  bbox,
  station_code,
  cql_filter
) {
  if (!is.null(cql_filter)) {
    xroad_assert_scalar_character(cql_filter, "cql_filter")
    if (grepl("\"", cql_filter, fixed = TRUE)) {
      stop(
        paste(
          "'cql_filter' must not contain double quotes.",
          "The xROAD specification's quoted field names are rejected by the deployed API."
        ),
        call. = FALSE
      )
    }
    if (
      !all(vapply(
        list(road_type, time_code, bbox, station_code),
        is.null,
        logical(1)
      ))
    ) {
      stop(
        "'cql_filter' cannot be combined with typed filter arguments.",
        call. = FALSE
      )
    }
    return(cql_filter)
  }

  road_type <- xroad_road_type(road_type)
  time_code <- xroad_time_code(time_code, interval)
  parts <- paste0("\u9053\u8DEF\u7A2E\u5225=", road_type)
  if (length(time_code) == 1L) {
    parts <- c(parts, paste0("\u6642\u9593\u30B3\u30FC\u30C9=", time_code))
  } else {
    parts <- c(
      parts,
      paste0("\u6642\u9593\u30B3\u30FC\u30C9>=", time_code[[1L]]),
      paste0("\u6642\u9593\u30B3\u30FC\u30C9<=", time_code[[2L]])
    )
  }
  if (!is.null(bbox)) {
    bbox <- xroad_bbox(bbox)
    parts <- c(
      parts,
      paste0(
        "BBOX(\u30B8\u30AA\u30E1\u30C8\u30EA,",
        paste(bbox, collapse = ","),
        ",'EPSG:4326')"
      )
    )
  }
  if (!is.null(station_code)) {
    station_code <- xroad_digits(station_code, "station_code")
    if (length(station_code) != 1L) {
      stop("'station_code' must contain one value.", call. = FALSE)
    }
    parts <- c(
      parts,
      paste0(
        "\u5E38\u6642\u89B3\u6E2C\u70B9\u30B3\u30FC\u30C9=",
        station_code
      )
    )
  }
  paste(parts, collapse = " AND ")
}

xroad_road_type <- function(road_type) {
  value <- xroad_digits(road_type, "road_type")
  if (length(value) != 1L || !value %in% c("1", "3")) {
    stop("'road_type' must be 1 or 3.", call. = FALSE)
  }
  value
}

xroad_time_code <- function(time_code, interval) {
  values <- xroad_digits(time_code, "time_code")
  if (!length(values) %in% c(1L, 2L) || any(nchar(values) != 12L)) {
    stop(
      "'time_code' must contain one or two YYYYMMDDhhmm values.",
      call. = FALSE
    )
  }
  parsed <- strptime(values, format = "%Y%m%d%H%M", tz = "Asia/Tokyo")
  valid <- !is.na(parsed) &
    format(parsed, "%Y%m%d%H%M", tz = "Asia/Tokyo") == values
  if (!all(valid)) {
    stop("'time_code' contains an invalid date or time.", call. = FALSE)
  }
  minutes <- as.integer(substr(values, 11L, 12L))
  if (interval == "5m" && any(minutes %% 5L != 0L)) {
    stop(
      "Minutes in 'time_code' must be a multiple of 5 for a 5-minute layer.",
      call. = FALSE
    )
  }
  if (interval == "1h" && any(minutes != 0L)) {
    stop(
      "Minutes in 'time_code' must be 00 for an hourly layer.",
      call. = FALSE
    )
  }
  if (length(values) == 2L && values[[1L]] > values[[2L]]) {
    stop("The 'time_code' range must be in ascending order.", call. = FALSE)
  }
  values
}

xroad_bbox <- function(bbox) {
  if (
    !is.numeric(bbox) ||
      length(bbox) != 4L ||
      any(!is.finite(bbox)) ||
      bbox[[1L]] >= bbox[[3L]] ||
      bbox[[2L]] >= bbox[[4L]]
  ) {
    stop(
      "'bbox' must be finite numeric c(xmin, ymin, xmax, ymax) with increasing bounds.",
      call. = FALSE
    )
  }
  format(bbox, scientific = FALSE, trim = TRUE)
}

xroad_digits <- function(value, name) {
  if (is.null(value) || !is.atomic(value) || anyNA(value)) {
    stop(sprintf("'%s' must contain digits only.", name), call. = FALSE)
  }
  if (is.numeric(value)) {
    if (any(!is.finite(value)) || any(value != floor(value))) {
      stop(sprintf("'%s' must contain whole numbers.", name), call. = FALSE)
    }
    value <- format(value, scientific = FALSE, trim = TRUE)
  } else {
    value <- as.character(value)
  }
  if (length(value) == 0L || any(!grepl("^[0-9]+$", value))) {
    stop(sprintf("'%s' must contain digits only.", name), call. = FALSE)
  }
  value
}

xroad_property_map <- function(layer) {
  traffic_properties <- if (identical(layer, "t_travospublic_measure_5m_img")) {
    xroad_cctv_properties
  } else if (identical(layer, "t_travospublic_measure_1h_img")) {
    xroad_cctv_hourly_properties
  } else {
    xroad_fixed_properties
  }
  c(xroad_common_properties, traffic_properties, xroad_trailing_properties)
}

xroad_parse_csv <- function(csv, layer) {
  raw <- tryCatch(
    data.table::fread(
      text = csv,
      colClasses = "character",
      na.strings = NULL,
      encoding = "UTF-8",
      check.names = FALSE
    ),
    error = function(cnd) {
      xroad_abort(
        "xroad_response_error",
        paste0(
          "The xROAD CSV response could not be parsed: ",
          conditionMessage(cnd)
        )
      )
    }
  )
  property_map <- xroad_property_map(layer)
  required <- c(
    "FID",
    names(property_map),
    "\u30B8\u30AA\u30E1\u30C8\u30EA"
  )
  missing <- setdiff(required, names(raw))
  if (length(missing) > 0L) {
    xroad_abort(
      "xroad_response_error",
      paste0(
        "The xROAD CSV response is missing required columns: ",
        paste(missing, collapse = ", "),
        "."
      )
    )
  }
  column_types <- xroad_column_types(layer)
  if (nrow(raw) == 0L) {
    return(xroad_empty_table(column_types))
  }
  rows <- lapply(seq_len(nrow(raw)), function(index) {
    properties <- as.list(raw[index, names(property_map), with = FALSE])
    feature <- list(
      id = raw[["FID"]][[index]],
      geometry = list(
        coordinates = xroad_wkt_coordinates(
          raw[["\u30B8\u30AA\u30E1\u30C8\u30EA"]][[index]]
        )
      ),
      properties = properties
    )
    xroad_parse_feature(feature, property_map)
  })
  out <- data.table::rbindlist(rows, use.names = TRUE)
  out <- xroad_cast_columns(out, column_types)
  data.table::setkeyv(out, c("station_code", "datetime"))
  out
}

xroad_wkt_coordinates <- function(wkt) {
  number <- "-?[0-9]+(?:\\.[0-9]+)?(?:[eE][+-]?[0-9]+)?"
  pairs <- regmatches(
    wkt,
    gregexpr(paste0(number, "\\s+", number), wkt, perl = TRUE)
  )[[1L]]
  if (length(pairs) == 0L || identical(pairs, character(0))) {
    return(list())
  }
  lapply(strsplit(pairs, "\\s+"), as.numeric)
}

xroad_column_types <- function(layer) {
  count_columns <- if (grepl("_img$", layer)) {
    c(
      "up_total_volume",
      "up_small_volume",
      "up_large_volume",
      "up_unclassified_volume",
      "down_total_volume",
      "down_small_volume",
      "down_large_volume",
      "down_unclassified_volume"
    )
  } else {
    c(
      "up_small_volume",
      "up_large_volume",
      "up_unclassified_volume",
      "down_small_volume",
      "down_large_volume",
      "down_unclassified_volume"
    )
  }
  property_columns <- unname(xroad_property_map(layer))
  types <- stats::setNames(
    rep("character", length(property_columns)),
    property_columns
  )
  types[c(
    "regional_bureau_code",
    "station_code",
    "observation_date",
    "time_slot"
  )] <- "integer"
  types[count_columns] <- "integer"
  types["time_code"] <- "numeric"
  c(
    feature_id = "character",
    types[seq_len(6L)],
    datetime = "POSIXct",
    types[-seq_len(6L)],
    longitude = "numeric",
    latitude = "numeric"
  )
}

xroad_parse_feature <- function(feature, property_map) {
  if (!is.list(feature) || !is.list(feature$properties)) {
    xroad_abort(
      "xroad_response_error",
      "An xROAD feature is missing its `properties` object."
    )
  }
  values <- lapply(names(property_map), function(source_name) {
    xroad_property_value(feature$properties, source_name)
  })
  names(values) <- unname(property_map)

  coordinates <- feature$geometry$coordinates
  point_count <- if (is.list(coordinates)) length(coordinates) else 0L
  if (point_count > 1L) {
    warning(
      sprintf(
        "Feature '%s' has %d points; only the first was retained.",
        xroad_scalar_character(feature$id),
        point_count
      ),
      call. = FALSE
    )
  }
  first_point <- if (point_count >= 1L) {
    coordinates[[1L]]
  } else {
    c(NA_real_, NA_real_)
  }
  if (length(first_point) < 2L) {
    first_point <- c(NA_real_, NA_real_)
  }

  c(
    list(feature_id = xroad_scalar_character(feature$id)),
    values[seq_len(6L)],
    list(datetime = xroad_datetime(values$time_code)),
    values[-seq_len(6L)],
    list(
      longitude = suppressWarnings(as.numeric(first_point[[1L]])),
      latitude = suppressWarnings(as.numeric(first_point[[2L]]))
    )
  )
}

xroad_property_value <- function(properties, name) {
  value <- properties[[name]]
  # Counts are cast to integer later, so null, an absent key, and an empty count
  # all become NA. Empty character flags must remain "": the deployed CCTV
  # response uses it for the distinct "could not be judged" state.
  if (is.null(value) || length(value) == 0L) {
    return(NA)
  }
  value[[1L]]
}

xroad_cast_columns <- function(data, column_types) {
  for (name in names(column_types)) {
    type <- column_types[[name]]
    value <- data[[name]]
    data.table::set(
      data,
      j = name,
      value = switch(
        type,
        integer = suppressWarnings(as.integer(value)),
        numeric = suppressWarnings(as.numeric(value)),
        character = as.character(value),
        POSIXct = as.POSIXct(value, tz = "Asia/Tokyo")
      )
    )
  }
  data
}

xroad_empty_table <- function(column_types) {
  columns <- lapply(column_types, function(type) {
    switch(
      type,
      integer = integer(),
      numeric = numeric(),
      character = character(),
      POSIXct = as.POSIXct(character(), tz = "Asia/Tokyo")
    )
  })
  out <- data.table::as.data.table(columns)
  data.table::setnames(out, names(column_types))
  data.table::setkeyv(out, c("station_code", "datetime"))
  out
}

xroad_datetime <- function(time_code) {
  value <- xroad_scalar_character(time_code)
  if (is.na(value)) {
    return(as.POSIXct(NA_character_, tz = "Asia/Tokyo"))
  }
  value <- sub("\\.0+$", "", value)
  # Verified in t1_form4_shikoku.json: form 4 returns time_slot as a two-digit
  # hour (19), while time_code remains 202608131900. Deriving from time_code
  # prevents the silent and incorrect 00:19 interpretation.
  as.POSIXct(strptime(value, format = "%Y%m%d%H%M", tz = "Asia/Tokyo"))
}

xroad_read_body <- function(body) {
  xroad_assert_scalar_character(body, "body")
  trimmed <- trimws(body)
  looks_like_body <- startsWith(trimmed, "{") ||
    startsWith(trimmed, "[") ||
    startsWith(trimmed, "<") ||
    startsWith(trimmed, "\"")
  if (!looks_like_body && file.exists(body)) {
    return(paste(
      readLines(body, warn = FALSE, encoding = "UTF-8"),
      collapse = "\n"
    ))
  }
  body
}

xroad_required_count <- function(value, name) {
  if (is.null(value) || length(value) != 1L || is.na(value)) {
    xroad_abort(
      "xroad_response_error",
      sprintf("The xROAD FeatureCollection is missing `%s`.", name)
    )
  }
  count <- suppressWarnings(as.integer(value))
  if (is.na(count) || count < 0L) {
    xroad_abort(
      "xroad_response_error",
      sprintf("The xROAD FeatureCollection has an invalid `%s`.", name)
    )
  }
  count
}

xroad_abort_ows <- function(body) {
  code <- xroad_regex_capture(body, "exceptionCode=\"([^\"]+)\"")
  text <- xroad_regex_capture(
    body,
    "(?s)<(?:ows:)?ExceptionText>(.*?)</(?:ows:)?ExceptionText>"
  )
  text <- xroad_decode_xml(text)
  xroad_abort(
    "xroad_malformed_request_error",
    sprintf("The xROAD API rejected the request (%s): %s", code, trimws(text))
  )
}

xroad_regex_capture <- function(text, pattern) {
  match <- regexec(pattern, text, perl = TRUE)
  captures <- regmatches(text, match)[[1L]]
  if (length(captures) < 2L) "unknown" else captures[[2L]]
}

xroad_decode_xml <- function(text) {
  replacements <- c(
    "&amp;" = "&",
    "&quot;" = "\"",
    "&apos;" = "'",
    "&lt;" = "<",
    "&gt;" = ">"
  )
  for (entity in names(replacements)) {
    text <- gsub(entity, replacements[[entity]], text, fixed = TRUE)
  }
  text
}

xroad_abort <- function(class, message) {
  condition <- structure(
    list(message = message, call = NULL),
    class = c(class, "xroad_api_error", "error", "condition")
  )
  stop(condition)
}

xroad_scalar_character <- function(value) {
  if (is.null(value) || length(value) == 0L) {
    return(NA_character_)
  }
  as.character(value[[1L]])
}

xroad_assert_scalar_character <- function(value, name) {
  if (
    !is.character(value) ||
      length(value) != 1L ||
      is.na(value) ||
      !nzchar(value)
  ) {
    stop(
      sprintf("`%s` must be one non-empty character value.", name),
      call. = FALSE
    )
  }
}

xroad_assert_positive_number <- function(value, name) {
  if (!is.numeric(value) || length(value) != 1L || is.na(value) || value <= 0) {
    stop(sprintf("`%s` must be one positive number.", name), call. = FALSE)
  }
}

xroad_assert_positive_integer <- function(value, name) {
  xroad_assert_positive_number(value, name)
  if (value != as.integer(value)) {
    stop(sprintf("`%s` must be a whole number.", name), call. = FALSE)
  }
  as.integer(value)
}
