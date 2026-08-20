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

A `data.table` of unique locations with `source_code`, `location_no`,
`location_from`, `location_to` and `meshcode10km`.

## Details

The name is split on the *first* arrow (\U{2192}) only, which makes the
result well defined for every value:

- no arrow: the whole name stays in `location_from` and `location_to` is
  `NA`;

- more than one arrow: everything after the first arrow is kept in
  `location_to`, so no part of the original name is discarded;

- `NA`: both columns are `NA`.

## Examples

``` r
d <- read_jartic_traffic(
  system.file("dummy", "type_b.csv", package = "jarticr")
)
jartic_type_b_loc_tiny(d)
#>    source_code location_no location_from location_to meshcode10km
#>         <char>       <int>        <char>      <char>       <char>
#> 1:          36           1      徳島駅前      県庁前       513376
#> 2:          36           2   APAホテル前        南口       513376
```
