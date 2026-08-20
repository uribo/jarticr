# Generate the CP932-encoded fixtures used by tests/testthat.
#
# The JARTIC "type B" (cross-sectional traffic volume) files are CP932 CSV with
# a header row and CRLF line endings. The fixtures must be written as CP932
# bytes, otherwise read_jartic_traffic()'s iconv(from = "cp932") step turns the
# Japanese location names into mojibake. Do not edit inst/dummy/*.csv by hand.
#
# Two layouts are shipped, because the published format changed:
#   type_b.csv      10 columns, as published from 2018-02 onwards
#   type_b_9col.csv  9 columns (no link version), as published before that
#
# Run with: Rscript data-raw/dummy_typeB.R

write_cp932_csv <- function(lines, file) {
  path <- file.path("inst", "dummy", file)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  con <- file(path, open = "wb")
  on.exit(close(con), add = TRUE)
  # The published files use CRLF; keep the fixture byte-compatible with them.
  writeBin(
    iconv(
      paste0(lines, "\r\n", collapse = ""),
      from = "UTF-8",
      to = "CP932",
      toRaw = TRUE
    )[[1]],
    con
  )
}

# 10 columns (2018-02 onwards) ------------------------------------------------
current <- c(
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
  "2022/11/01 00:00,36,1,徳島駅前→県庁前,513376,1,101,120,0050,202200",
  "2022/11/01 01:00,36,1,徳島駅前→県庁前,513376,1,101,80,0050,202200",
  # Full-width letters and padding exercise the NFKC + squish cleanup: this
  # row must normalize to exactly the same location_name as the next one.
  "2022/11/01 00:00,36,2,  ＡＰＡホテル前→南口  ,513376,1,102,45,0120,202200",
  # An empty traffic field must land as NA, not 0.
  "2022/11/01 01:00,36,2,APAホテル前→南口,513376,1,102,,0120,202200"
)

# 9 columns (before 2018-02) --------------------------------------------------
# No link version, the distance column is spelled with half-width parentheses,
# and this era's providers write the seconds in the timestamp.
legacy <- c(
  paste(
    "時刻",
    "情報源コード",
    "計測地点番号",
    "計測地点名称",
    "2次メッシュコード",
    "リンク区分",
    "リンク番号",
    "断面交通量",
    "リンク終端からの距離(10m)",
    sep = ","
  ),
  "2017/8/1 0:00:00,3028,1,徳島駅前→県庁前,513376,2,710,20,6",
  "2017/8/1 0:05:00,3028,1,徳島駅前→県庁前,513376,2,710,18,6",
  # Same month, second format: a few providers already wrote it without the
  # seconds, so both must parse in one read.
  "2017/08/01 00:10,3028,1,徳島駅前→県庁前,513376,2,710,15,6"
)

write_cp932_csv(current, "type_b.csv")
write_cp932_csv(legacy, "type_b_9col.csv")
