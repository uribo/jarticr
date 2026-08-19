# Create the observation location table for type B

Reduces a type B table to one row per observation location and splits
`location_name` into its start and end points on the arrow separator.

## Usage

``` r
jartic_type_b_loc_tiny(data)
```

## Arguments

- data:

  A type B table, as returned by
  [`read_jartic_traffic()`](https://uribo.github.io/jarticr/reference/read_jartic_traffic.md).

## Value

A table of unique locations with `source_code`, `location_no`,
`location_from`, `location_to` and `meshcode10km`.

## Examples

``` r
d <- read_jartic_traffic(
  system.file("dummy", "type_b.csv", package = "jarticr")
)
jartic_type_b_loc_tiny(d)
#>   source_code location_no location_from location_to meshcode10km
#> 1          36           1      徳島駅前      県庁前       513376
#> 2          36           2   APAホテル前        南口       513376
```
