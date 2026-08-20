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
