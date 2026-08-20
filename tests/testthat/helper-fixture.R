# Paths to the CP932-encoded type B fixtures shipped in inst/dummy.
# Regenerate the bytes with data-raw/dummy_typeB.R; never edit the CSVs by hand.
type_b_fixture <- function() {
  system.file("dummy", "type_b.csv", package = "jarticr", mustWork = TRUE)
}

# The 9-column layout published before 2018-02, with no link version.
type_b_9col_fixture <- function() {
  system.file("dummy", "type_b_9col.csv", package = "jarticr", mustWork = TRUE)
}
