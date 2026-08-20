test_that("read_jartic_traffic() returns the documented type B columns", {
  d <- read_jartic_traffic(type_b_fixture())

  expect_s3_class(d, "data.table")
  expect_named(
    d,
    c(
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
  )
  expect_equal(nrow(d), 4L)
  expect_type(d$source_code, "character")
  expect_type(d$location_no, "integer")
  expect_type(d$traffic, "integer")
  # Padded identifiers must stay character; dropping to integer loses the zeros.
  expect_type(d$to_link_end_10m, "character")
  expect_identical(d$to_link_end_10m[[1]], "0050")
})

test_that("read_jartic_traffic() parses datetime in JST and keys on it", {
  d <- read_jartic_traffic(type_b_fixture())

  expect_s3_class(d$datetime, "POSIXct")
  expect_identical(attr(d$datetime, "tzone"), "Asia/Tokyo")
  expect_identical(
    d$datetime[[1]],
    as.POSIXct("2022-11-01 00:00:00", tz = "Asia/Tokyo")
  )
  expect_identical(data.table::key(d), "datetime")
  expect_false(is.unsorted(d$datetime))
})

test_that("read_jartic_traffic() decodes CP932 and normalizes location names", {
  d <- read_jartic_traffic(type_b_fixture())

  expect_identical(
    unique(d[d$location_no == 1L, ]$location_name),
    "徳島駅前→県庁前"
  )
  # NFKC folds the full-width letters and str_squish() drops the padding, so
  # the two spellings of location 2 must collapse to one value.
  expect_identical(
    unique(d[d$location_no == 2L, ]$location_name),
    "APAホテル前→南口"
  )
})

test_that("read_jartic_traffic() keeps an empty traffic field as NA", {
  d <- read_jartic_traffic(type_b_fixture())

  expect_true(is.na(d$traffic[[4]]))
  expect_equal(sum(is.na(d$traffic)), 1L)
})

test_that("read_jartic_traffic() keeps the first row of a headerless file", {
  path <- tempfile(fileext = ".csv")
  on.exit(unlink(path), add = TRUE)
  writeLines("202211010000,36,1,AAA,513376,1,101,120,0050,1", path)

  d <- read_jartic_traffic(path)

  expect_equal(nrow(d), 1L)
  expect_identical(d$to_link_end_10m, "0050")
})

test_that("read_jartic_traffic() warns when location_name is not CP932", {
  path <- tempfile(fileext = ".csv")
  on.exit(unlink(path), add = TRUE)
  con <- file(path, open = "wb")
  writeBin(
    c(
      charToRaw("202211010000,36,1,"),
      as.raw(c(0x81, 0x20)), # a lead byte with no valid trail byte
      charToRaw(",513376,1,101,120,0050,1\n")
    ),
    con
  )
  close(con)

  expect_warning(d <- read_jartic_traffic(path), "not valid CP932")
  expect_true(is.na(d$location_name))
})

test_that("read_jartic_traffic() drops the header row shipped with the file", {
  d <- read_jartic_traffic(type_b_fixture())

  # The header would arrive as an observation whose location_name is the
  # column label; it must not be in the table at all.
  expect_false("計測地点名称" %in% d$location_name)
  expect_false(any(is.na(d$datetime)))
})

test_that("read_jartic_traffic() reads the 9-column layout used before 2018-02", {
  d <- read_jartic_traffic(type_b_9col_fixture())

  expect_s3_class(d, "data.table")
  # A caller must not have to know the era: the columns are the same either way.
  expect_named(
    d,
    c(
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
  )
  expect_equal(nrow(d), 3L)
  expect_type(d$link_ver, "integer")
  expect_true(all(is.na(d$link_ver)))
  expect_type(d$to_link_end_10m, "character")
})

test_that("read_jartic_traffic() parses both datetime spellings of one file", {
  d <- read_jartic_traffic(type_b_9col_fixture())

  expect_s3_class(d$datetime, "POSIXct")
  expect_identical(attr(d$datetime, "tzone"), "Asia/Tokyo")
  # "2017/8/1 0:00:00" (with seconds) and "2017/08/01 00:10" both appear.
  expect_false(any(is.na(d$datetime)))
  expect_identical(
    d$datetime,
    as.POSIXct(
      c("2017-08-01 00:00:00", "2017-08-01 00:05:00", "2017-08-01 00:10:00"),
      tz = "Asia/Tokyo"
    )
  )
})

test_that("read_jartic_traffic() warns when a datetime cannot be parsed", {
  path <- tempfile(fileext = ".csv")
  on.exit(unlink(path), add = TRUE)
  writeLines("20221101,36,1,AAA,513376,1,101,120,0050,1", path)

  expect_warning(d <- read_jartic_traffic(path), "could not be parsed")
  expect_true(is.na(d$datetime))
})

test_that("read_jartic_traffic() rejects a file with an unexpected width", {
  path <- tempfile(fileext = ".csv")
  on.exit(unlink(path), add = TRUE)
  writeLines("202211010000,36,1,AAA,513376", path)

  expect_error(read_jartic_traffic(path), "9 or 10 columns")
})

test_that("read_jartic_traffic() rejects a file that is only a header", {
  path <- tempfile(fileext = ".csv")
  on.exit(unlink(path), add = TRUE)
  con <- file(path, open = "wb")
  writeBin(
    iconv(
      paste0(
        paste(
          "時刻",
          "情報源コード",
          "計測地点番号",
          "計測地点名称",
          "2次メッシュコード",
          "リンク区分",
          "リンク番号",
          "断面交通量",
          "リンク終端からの距離（×10m）",
          "リンクバージョン",
          sep = ","
        ),
        "\r\n"
      ),
      from = "UTF-8",
      to = "CP932",
      toRaw = TRUE
    )[[1]],
    con
  )
  close(con)

  # A monthly file with no observations is a failed download, not an empty
  # result to pass downstream.
  expect_error(read_jartic_traffic(path), "no observations")
})
