xroad_fixture <- function(name) {
  testthat::test_path("fixtures", name)
}

xroad_request_cql <- function(request) {
  url <- utils::URLdecode(request$url)
  sub(".*[?&]cql_filter=([^&]+).*", "\\1", url)
}

test_that("xroad_build_request() constructs the recorded working CQL exactly", {
  req <- xroad_build_request(
    interval = "5m",
    counter_type = "fixed",
    road_type = 3,
    time_code = 202608131900,
    bbox = c(134.45, 33.95, 134.70, 34.15)
  )

  expect_s3_class(req, "httr2_request")
  expect_identical(
    xroad_request_cql(req),
    paste0(
      "道路種別=3 AND 時間コード=202608131900 AND ",
      "BBOX(ジオメトリ,134.45,33.95,134.70,34.15,'EPSG:4326')"
    )
  )
  url <- utils::URLdecode(req$url)
  expect_match(url, "typeNames=t_travospublic_measure_5m", fixed = TRUE)
  expect_match(url, "outputFormat=application/json", fixed = TRUE)
  expect_identical(req$policies$throttle_realm, "jarticr-xroad-traffic")
})

test_that("xroad_build_request() selects layers and constructs ranges", {
  req <- xroad_build_request(
    interval = "1h",
    counter_type = "cctv",
    road_type = 1,
    time_code = c(202608131900, 202608132000),
    station_code = "01234567",
    output_format = "csv"
  )

  url <- utils::URLdecode(req$url)
  expect_match(url, "typeNames=t_travospublic_measure_1h_img", fixed = TRUE)
  expect_match(url, "outputFormat=csv", fixed = TRUE)
  expect_identical(
    xroad_request_cql(req),
    paste0(
      "道路種別=1 AND 時間コード>=202608131900 AND ",
      "時間コード<=202608132000 AND 常時観測点コード=01234567"
    )
  )
})

test_that("xroad_build_request() rejects invalid time codes", {
  expect_error(
    xroad_build_request("5m", "fixed", 3, 202608131902),
    "multiple of 5"
  )
  expect_error(
    xroad_build_request("1h", "fixed", 3, 202608131905),
    "must be 00"
  )
  expect_error(
    xroad_build_request("1h", "cctv", 3, 2026081319),
    "YYYYMMDDhhmm"
  )
  expect_error(
    xroad_build_request("1h", "fixed", 3, 202602301900),
    "invalid date or time"
  )
  expect_error(
    xroad_build_request(
      "1h",
      "fixed",
      3,
      c(202608132000, 202608131900)
    ),
    "ascending order"
  )
})

test_that("form 4 requests use 12-digit time codes despite two-digit time_slot", {
  req <- xroad_build_request("1h", "cctv", 3, 202608131900)

  expect_identical(
    xroad_request_cql(req),
    "道路種別=3 AND 時間コード=202608131900"
  )
})

test_that("the raw CQL escape hatch rejects specification-style quotes", {
  expect_error(
    xroad_build_request(
      interval = "5m",
      counter_type = "fixed",
      cql_filter = '"道路種別"=3'
    ),
    "must not contain double quotes.*specification"
  )
  expect_error(
    xroad_build_request(
      interval = "5m",
      counter_type = "fixed",
      road_type = 3,
      cql_filter = "道路種別=3"
    ),
    "cannot be combined"
  )
  req <- xroad_build_request(
    interval = "5m",
    counter_type = "fixed",
    cql_filter = "道路種別=3 AND 時間コード=202608131900"
  )
  expect_identical(
    xroad_request_cql(req),
    "道路種別=3 AND 時間コード=202608131900"
  )
})

test_that("xroad_perform_request() works with an httr2 mocked response", {
  body <- paste(
    readLines(xroad_fixture("xroad-zero.geojson"), warn = FALSE),
    collapse = "\n"
  )
  mock <- function(req) {
    httr2::response(
      status_code = 200,
      url = req$url,
      headers = list("content-type" = "application/json; charset=utf-8"),
      body = charToRaw(body)
    )
  }
  req <- xroad_build_request(
    "5m",
    "fixed",
    road_type = 3,
    time_code = 202608131900,
    max_tries = 1
  )

  result <- httr2::with_mocked_responses(mock, xroad_perform_request(req))
  expect_identical(result, body)
})

test_that("xroad_get_traffic() composes request, perform, and parse", {
  body <- paste(
    readLines(xroad_fixture("xroad-zero.geojson"), warn = FALSE),
    collapse = "\n"
  )
  mock <- function(req) {
    httr2::response(
      status_code = 200,
      url = req$url,
      headers = list("content-type" = "application/json; charset=utf-8"),
      body = charToRaw(body)
    )
  }

  result <- httr2::with_mocked_responses(
    mock,
    xroad_get_traffic(
      "5m",
      "fixed",
      road_type = 3,
      time_code = 202608131900,
      max_tries = 1
    )
  )
  expect_s3_class(result, "data.table")
  expect_equal(nrow(result), 0L)
})

test_that("the recorded golden GeoJSON reproduces the verified table", {
  d <- xroad_parse_traffic(
    xroad_fixture("xroad-golden.geojson"),
    "5m",
    "fixed"
  )

  expected <- data.table::data.table(
    station_code = c(8110231L, 8110232L, 8310070L, 8310080L),
    longitude = c(134.520514, 134.531005, 134.566429, 134.633932),
    latitude = c(34.038478, 34.041201, 34.010266, 33.973207),
    up_small_volume = c(33L, 36L, 69L, 34L),
    up_large_volume = c(0L, 0L, 2L, 0L),
    down_small_volume = c(9L, 17L, 78L, 25L),
    down_large_volume = c(0L, 0L, 0L, 2L)
  )
  expect_s3_class(d, "data.table")
  expect_identical(data.table::key(d), c("station_code", "datetime"))
  expect_s3_class(d$datetime, "POSIXct")
  expect_identical(attr(d$datetime, "tzone"), "Asia/Tokyo")
  expect_identical(
    d$datetime,
    rep(as.POSIXct("2026-08-13 19:00:00", tz = "Asia/Tokyo"), 4L)
  )
  expect_equal(
    d[, names(expected), with = FALSE],
    expected,
    tolerance = 1e-6,
    ignore_attr = TRUE
  )
  expect_true(all(d$regional_bureau_code == 88L))
  expect_true(all(d$collection_interval == "1"))
})

test_that("the recorded form 2 response uses the fixed-counter schema", {
  d <- xroad_parse_traffic(
    xroad_fixture("xroad-form2-1h.geojson"),
    "1h",
    "fixed"
  )

  expect_equal(nrow(d), 4L)
  expect_true(all(d$collection_interval == "2"))
  expect_true(all(d$time_slot == 1900L))
  expect_true(all(
    d$datetime ==
      as.POSIXct(
        "2026-08-13 19:00:00",
        tz = "Asia/Tokyo"
      )
  ))
  expect_false(any(grepl("202608131900$", d$feature_id)))
})

test_that("the recorded range response preserves stations and time codes", {
  d <- xroad_parse_traffic(
    xroad_fixture("xroad-range.geojson"),
    "5m",
    "fixed"
  )

  expect_equal(nrow(d), 6L)
  expect_setequal(d$station_code, c(8110231L, 8110232L))
  expect_setequal(
    d$time_code,
    c(202608131905, 202608131925, 202608132000)
  )
})

test_that("a recorded aged-out response is a typed, ambiguous zero", {
  d <- xroad_parse_traffic(
    xroad_fixture("xroad-zero.geojson"),
    "5m",
    "fixed"
  )

  expect_s3_class(d, "data.table")
  expect_equal(nrow(d), 0L)
  expect_identical(data.table::key(d), c("station_code", "datetime"))
  expect_type(d$station_code, "integer")
  expect_s3_class(d$datetime, "POSIXct")
  expect_type(d$up_small_volume, "integer")
  expect_type(d$up_missing_status, "character")
})

test_that("synthetic truncation remains a classed defensive failure", {
  # Synthetic: count is ignored by the deployed service, so truncation has not
  # been observed.
  expect_error(
    xroad_parse_traffic(
      xroad_fixture("xroad-synthetic-truncated.geojson"),
      "5m",
      "fixed"
    ),
    class = "xroad_truncation_error",
    regexp = "Narrow the time range or bounding box"
  )

  inconsistent <- paste0(
    '{"type":"FeatureCollection","features":[],',
    '"numberMatched":1,"numberReturned":1,"crs":null}'
  )
  expect_error(
    xroad_parse_traffic(inconsistent, "5m", "fixed"),
    class = "xroad_truncation_error",
    regexp = "features contains 0 records"
  )
})

test_that("the recorded HTTP 200 payload cap has its own error class", {
  expect_error(
    xroad_parse_traffic(
      xroad_fixture("xroad-payload-cap.json"),
      "5m",
      "fixed"
    ),
    class = "xroad_payload_cap_error",
    regexp = "approximately 6 MB.*Split the request"
  )
})

test_that("recorded JSON and synthetic OWS request errors expose details", {
  expect_error(
    xroad_parse_traffic(
      xroad_fixture("xroad-bad-request.json"),
      "5m",
      "fixed"
    ),
    class = "xroad_malformed_request_error",
    regexp = "Could not parse request body into json"
  )

  # Synthetic: the deployed quoted-CQL failure is JSON, so this OWS response is
  # retained only from the specification.
  expect_error(
    xroad_parse_traffic(
      xroad_fixture("xroad-synthetic-ows-exception.xml"),
      "5m",
      "fixed"
    ),
    class = "xroad_malformed_request_error",
    regexp = "InvalidParameterValue.*Feature type.*unknown"
  )
})

test_that("recorded CCTV null counts remain integer NA", {
  d <- xroad_parse_traffic(
    xroad_fixture("xroad-cctv.geojson"),
    "5m",
    "cctv"
  )

  expect_identical(d[d$station_code == 8810010L, ]$up_total_volume, 8L)
  expect_true(is.na(d[d$station_code == 8810050L, ]$up_total_volume))
  expect_type(d$up_total_volume, "integer")
  expect_false("up_power_outage_status" %in% names(d))
})

test_that("recorded CCTV indeterminate flags stay empty character values", {
  d <- xroad_parse_traffic(
    xroad_fixture("xroad-cctv-indeterminate.geojson"),
    "5m",
    "cctv"
  )

  expect_identical(
    d[d$station_code == 5810210L, ]$development_bureau_prefecture_code,
    "24"
  )
  expect_identical(
    d[d$station_code == 6810010L, ]$development_bureau_prefecture_code,
    ""
  )
  expect_true(all(d$weather_image_failure_status == ""))
  expect_true(all(d$sudden_event_status == ""))
  expect_true(all(d$video_analysis_freeze_status == ""))
  expect_type(d$weather_image_failure_status, "character")
})

test_that("recorded CSV and GeoJSON agree except coordinate precision", {
  geojson <- xroad_parse_traffic(
    xroad_fixture("xroad-golden.geojson"),
    "5m",
    "fixed"
  )
  csv <- xroad_parse_traffic(
    xroad_fixture("xroad-golden.csv"),
    "5m",
    "fixed"
  )

  expect_named(csv, names(geojson))
  expect_identical(
    vapply(csv, typeof, character(1)),
    vapply(geojson, typeof, character(1))
  )
  compare <- setdiff(names(csv), c("longitude", "latitude"))
  expect_equal(
    csv[, compare, with = FALSE],
    geojson[, compare, with = FALSE]
  )
  expect_identical(csv$longitude[[1L]], 134.520513564348)
  expect_identical(geojson$longitude[[1L]], 134.52051356)
  expect_equal(csv$longitude, geojson$longitude, tolerance = 1e-7)
  expect_equal(csv$latitude, geojson$latitude, tolerance = 1e-7)
})

test_that("recorded form 4 uses time_slot hour but datetime remains 19:00", {
  d <- xroad_parse_traffic(
    xroad_fixture("xroad-form4-1h.geojson"),
    "1h",
    "cctv"
  )

  expect_equal(nrow(d), 2L)
  expect_true("up_total_volume" %in% names(d))
  expect_true("up_five_minute_missing_processing_flag" %in% names(d))
  expect_true("down_five_minute_missing_processing_flag" %in% names(d))
  expect_false("camera_preset_position_status" %in% names(d))
  expect_identical(d$time_slot, c(19L, 19L))
  expect_identical(
    d$datetime,
    rep(as.POSIXct("2026-08-13 19:00:00", tz = "Asia/Tokyo"), 2L)
  )
  expect_false(any(
    d$datetime ==
      as.POSIXct(
        "2026-08-13 00:19:00",
        tz = "Asia/Tokyo"
      )
  ))
})

test_that("recorded form 4 preserves null counts and observed flag domain", {
  shikoku <- xroad_parse_traffic(
    xroad_fixture("xroad-form4-1h.geojson"),
    "1h",
    "cctv"
  )
  chubu <- xroad_parse_traffic(
    xroad_fixture("xroad-form4-chubu.geojson"),
    "1h",
    "cctv"
  )

  expect_identical(
    shikoku[shikoku$station_code == 8810010L, ]$up_total_volume,
    99L
  )
  expect_true(is.na(
    shikoku[shikoku$station_code == 8810050L, ]$up_total_volume
  ))
  expect_type(shikoku$up_total_volume, "integer")
  expect_type(shikoku$up_five_minute_missing_processing_flag, "character")
  expect_setequal(
    shikoku$up_five_minute_missing_processing_flag,
    c("0", "2")
  )
  expect_identical(
    chubu[chubu$station_code == 5810210L, ]$development_bureau_prefecture_code,
    "24"
  )
  expect_identical(
    chubu[
      chubu$station_code == 6810020L,
    ]$up_five_minute_missing_processing_flag,
    "2"
  )
})

test_that("MultiPoint geometries warn before discarding extra points", {
  body <- paste0(
    '{"type":"FeatureCollection","features":[{',
    '"type":"Feature","id":"multi","geometry":{"type":"MultiPoint",',
    '"coordinates":[[134.5,34.0],[134.6,34.1]]},"properties":{',
    '"常時観測点コード":1,"時間コード":202608131900}}],',
    '"numberMatched":1,"numberReturned":1}'
  )
  expect_warning(
    d <- xroad_parse_traffic(body, "5m", "fixed"),
    "has 2 points"
  )
  expect_identical(d$longitude, 134.5)
  expect_identical(d$latitude, 34.0)
})
