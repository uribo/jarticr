# Rebuild the offline xROAD fixtures from the read-only probe archive recorded
# on 2026-08-25. Run from the package root.
source_dir <- file.path(
  "/Users/suryu/Documents/1_Projects/2607_tokushima_tourism_flow",
  "data-raw/jartic-open-traffic/probe-2026-08-25"
)
fixture_dir <- file.path("tests", "testthat", "fixtures")
dir.create(fixture_dir, recursive = TRUE, showWarnings = FALSE)

# These bodies are copied byte-for-byte from recorded responses.
recorded <- c(
  "xroad-golden.geojson" = "p0_golden_unquoted.json",
  "xroad-form2-1h.geojson" = "r4_form2_1h.json",
  "xroad-golden.csv" = "r3_golden_csv.csv",
  "xroad-zero.geojson" = "r8_expired.json",
  "xroad-payload-cap.json" = "r9_oversize.json",
  "xroad-bad-request.json" = "p1_golden_geojson.json"
)
copied <- file.copy(
  file.path(source_dir, unname(recorded)),
  file.path(fixture_dir, names(recorded)),
  overwrite = TRUE
)
if (!all(copied)) {
  stop("Failed to copy one or more recorded xROAD fixtures.")
}

write_subset <- function(source, destination, keep) {
  body <- jsonlite::read_json(
    file.path(source_dir, source),
    simplifyVector = FALSE
  )
  body$features <- body$features[keep]
  count <- length(body$features)
  body$totalFeatures <- count
  body$numberMatched <- count
  body$numberReturned <- count
  jsonlite::write_json(
    body,
    file.path(fixture_dir, destination),
    auto_unbox = TRUE,
    pretty = FALSE,
    null = "null",
    digits = NA
  )
}

# r1_range_1h.json feature indices 1, 2, 5, 6, 13, and 14 (R indexing):
# stations 8110231 and 8110232 at 19:05, 19:25, and 20:00.
write_subset(
  "r1_range_1h.json",
  "xroad-range.geojson",
  c(1L, 2L, 5L, 6L, 13L, 14L)
)

# r5_cctv_5m.json feature indices 1 and 3: the first has integer counts and the
# second has JSON null counts.
write_subset(
  "r5_cctv_5m.json",
  "xroad-cctv.geojson",
  c(1L, 3L)
)

# r6_cctv_kinki.json feature indices 1 and 16: both have empty indeterminate
# status flags, while the first has a non-empty prefecture code ("24").
write_subset(
  "r6_cctv_kinki.json",
  "xroad-cctv-indeterminate.geojson",
  c(1L, 16L)
)

# t1_form4_shikoku.json feature indices 1 and 3: the first has integer counts
# and "0" processing flags, while the second has JSON null counts and "2"
# processing flags.
write_subset(
  "t1_form4_shikoku.json",
  "xroad-form4-1h.geojson",
  c(1L, 3L)
)

# t3_form4_kinki.json feature indices 1 and 17: the first has a non-empty
# prefecture code ("24"), while the second has "2" processing flags.
write_subset(
  "t3_form4_kinki.json",
  "xroad-form4-chubu.geojson",
  c(1L, 17L)
)

# Synthetic fixture: count is ignored by the deployed service, so a truncated
# FeatureCollection has not been observed. This pins the defensive invariant.
writeLines(
  paste0(
    '{"type":"FeatureCollection","features":[],',
    '"totalFeatures":2,"numberMatched":2,"numberReturned":0,',
    '"timeStamp":"2026-08-25T00:00:00.000Z","crs":null}'
  ),
  file.path(fixture_dir, "xroad-synthetic-truncated.geojson"),
  useBytes = TRUE
)

# Synthetic fixture: quoted CQL is rejected by API Gateway with JSON before it
# reaches GeoServer, so the specification-derived OWS XML path was not observed.
writeLines(
  paste0(
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<ows:ExceptionReport xmlns:ows="http://www.opengis.net/ows/1.1">',
    '<ows:Exception exceptionCode="InvalidParameterValue" locator="typeName">',
    '<ows:ExceptionText>Feature type :t_travospublic_measure_50m unknown',
    '</ows:ExceptionText></ows:Exception></ows:ExceptionReport>'
  ),
  file.path(fixture_dir, "xroad-synthetic-ows-exception.xml"),
  useBytes = TRUE
)
