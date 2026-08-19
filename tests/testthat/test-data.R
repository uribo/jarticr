test_that("jartic_provider covers every JARTIC data provider", {
  # 47 prefectures, with Hokkaido split into its 5 police headquarters areas.
  expect_equal(nrow(jartic_provider), 51L)
  expect_named(jartic_provider, c("name", "name_en"))
  expect_false(any(duplicated(jartic_provider$name)))
  expect_false(any(duplicated(jartic_provider$name_en)))
  expect_false(any(is.na(jartic_provider)))
})
