# Generate the CP932-encoded fixture used by tests/testthat.
#
# The JARTIC "type B" (cross-sectional traffic volume) files are headerless
# CP932 CSV. The fixture must be written as CP932 bytes, otherwise
# read_jartic_traffic()'s iconv(from = "cp932") step turns the Japanese
# location names into mojibake. Do not edit inst/dummy/type_b.csv by hand.
#
# Run with: Rscript data-raw/dummy_typeB.R

rows <- c(
  # datetime, source_code, location_no, location_name, meshcode10km,
  # link_type, link_no, traffic, to_link_end_10m, link_ver
  "202211010000,36,1,徳島駅前→県庁前,513376,1,101,120,0050,1",
  "202211010100,36,1,徳島駅前→県庁前,513376,1,101,80,0050,1",
  # Full-width letters and padding exercise the NFKC + squish cleanup: this
  # row must normalize to exactly the same location_name as the next one.
  "202211010000,36,2,  ＡＰＡホテル前→南口  ,513376,1,102,45,0120,1",
  # An empty traffic field must land as NA, not 0.
  "202211010100,36,2,APAホテル前→南口,513376,1,102,,0120,1"
)

path <- file.path("inst", "dummy", "type_b.csv")
dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)

con <- file(path, open = "wb")
on.exit(close(con), add = TRUE)
writeBin(
  iconv(
    paste0(rows, "\n", collapse = ""),
    from = "UTF-8",
    to = "CP932",
    toRaw = TRUE
  )[[1]],
  con
)
