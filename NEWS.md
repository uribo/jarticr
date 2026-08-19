# jarticr 0.0.0.9000

* `read_jartic_traffic()` reads a JARTIC type B (cross-sectional traffic
  volume) CSV file, converting it from CP932 and returning a `data.table`
  keyed on `datetime` (JST).
* `jartic_type_b_loc_tiny()` derives the observation-location table by
  splitting `location_name` into `location_from` / `location_to`.
* `jartic_provider` records the 51 JARTIC data providers (47 prefectures, with
  Hokkaido split into its 5 police headquarters areas).
