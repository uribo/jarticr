# Path to the CP932-encoded type B fixture shipped in inst/dummy.
# Regenerate the bytes with data-raw/dummy_typeB.R; never edit the CSV by hand.
type_b_fixture <- function() {
  system.file("dummy", "type_b.csv", package = "jarticr", mustWork = TRUE)
}
