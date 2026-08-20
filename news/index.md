# Changelog

## jarticr 0.0.0.9000

- [`read_jartic_traffic()`](https://uribo.github.io/jarticr/reference/read_jartic_traffic.md)
  reads a JARTIC type B (cross-sectional traffic volume) CSV file,
  converting it from CP932 and returning a `data.table` keyed on
  `datetime` (JST).
- [`jartic_type_b_loc_tiny()`](https://uribo.github.io/jarticr/reference/jartic_type_b_loc_tiny.md)
  derives the observation-location table by splitting `location_name`
  into `location_from` / `location_to`. The split happens on the first
  arrow only and returns a `data.table`, so the class matches the rest
  of the API; names without an arrow keep the whole value in
  `location_from`, and names with more than one arrow keep the remainder
  in `location_to` instead of discarding it. This drops the `tidyr`
  dependency.
- [`read_jartic_traffic()`](https://uribo.github.io/jarticr/reference/read_jartic_traffic.md)
  now warns instead of staying silent when bytes in `location_name` are
  not valid CP932 and decode to `NA`.
- `jartic_provider` records the 51 JARTIC data providers (47
  prefectures, with Hokkaido split into its 5 police headquarters
  areas).
