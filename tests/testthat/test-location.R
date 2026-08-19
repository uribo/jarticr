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

test_that("jartic_type_b_loc_tiny() splits location_name on the arrow", {
  loc <- jartic_type_b_loc_tiny(read_jartic_traffic(type_b_fixture()))

  expect_identical(loc$location_from[[1]], "徳島駅前")
  expect_identical(loc$location_to[[1]], "県庁前")
  expect_false("location_name" %in% names(loc))
})
