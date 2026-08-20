test_that("jartic_type_b_loc_tiny() reduces to one row per location", {
  loc <- jartic_type_b_loc_tiny(read_jartic_traffic(type_b_fixture()))

  expect_named(
    loc,
    c(
      "source_code",
      "location_no",
      "location_from",
      "location_to",
      "meshcode10km"
    )
  )
  expect_equal(nrow(loc), 2L)
  expect_equal(loc$location_no, c(1L, 2L))
})

test_that("jartic_type_b_loc_tiny() keeps the data.table class", {
  loc <- jartic_type_b_loc_tiny(read_jartic_traffic(type_b_fixture()))

  # tidyr::separate() used to drop the input to a plain data.frame, which
  # silently broke the documented return type.
  expect_s3_class(loc, "data.table")
})

test_that("jartic_type_b_loc_tiny() splits location_name on the arrow", {
  loc <- jartic_type_b_loc_tiny(read_jartic_traffic(type_b_fixture()))

  expect_identical(loc$location_from[[1]], "徳島駅前")
  expect_identical(loc$location_to[[1]], "県庁前")
  expect_false("location_name" %in% names(loc))
})

test_that("jartic_type_b_loc_tiny() splits on the first arrow only", {
  d <- data.table::data.table(
    source_code = "36",
    location_no = 1:4,
    location_name = c("A→B", "C", "D→E→F", NA_character_),
    meshcode10km = "513376"
  )
  loc <- jartic_type_b_loc_tiny(d)

  # A name without an arrow stays whole; extra arrows are kept in
  # location_to rather than discarded; NA stays NA on both sides.
  expect_identical(loc$location_from, c("A", "C", "D", NA))
  expect_identical(loc$location_to, c("B", NA, "E→F", NA))
  expect_no_warning(jartic_type_b_loc_tiny(d))
})
