# jarticr 0.0.0.9000

* `read_jartic_traffic()` reads a JARTIC type B (cross-sectional traffic
  volume) CSV file, converting it from CP932 and returning a `data.table`
  keyed on `datetime` (JST).
* `jartic_type_b_loc_tiny()` derives the observation-location table by
  splitting `location_name` into `location_from` / `location_to`. The split
  happens on the first arrow only and returns a `data.table`, so the class
  matches the rest of the API; names without an arrow keep the whole value in
  `location_from`, and names with more than one arrow keep the remainder in
  `location_to` instead of discarding it. This drops the `tidyr` dependency.
* `read_jartic_traffic()` now warns instead of staying silent when bytes in
  `location_name` are not valid CP932 and decode to `NA`.
* `read_jartic_traffic()` reads the layout off the first line of the file
  instead of assuming one (#3). Every published file carries a header row,
  which is now dropped rather than read as an observation; a file that starts
  with an observation is still read in full. Files published before 2018-02
  have nine columns and no link version, and are returned with the same ten
  columns as the current layout, with `link_ver` set to `NA`. A file whose
  width is neither 9 nor 10 is an error rather than a silent misread.
* `read_jartic_traffic()` accepts the `2017/8/1 0:00:00` timestamp used by most
  providers before 2018-02, alongside the current `2026/06/01 00:00`, and warns
  when a value still fails to parse instead of leaving `NA` unannounced (#3).
* `jartic_provider` records the 51 JARTIC data providers (47 prefectures, with
  Hokkaido split into its 5 police headquarters areas).
