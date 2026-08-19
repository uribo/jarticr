# Read a JARTIC type B traffic file

Reads one cross-sectional traffic volume ("type B") CSV file published
by the Japan Road Traffic Information Center. The files are headerless
and CP932-encoded; this function supplies the column names, converts the
encoding, parses `datetime` in JST, and normalizes `location_name` with
NFKC.

## Usage

``` r
read_jartic_traffic(path)
```

## Arguments

- path:

  Path to a raw type B file (CSV format).

## Value

A `data.table` of 10 columns, keyed on `datetime`:

- datetime:

  Observation time (`POSIXct`, `Asia/Tokyo`).

- source_code:

  Information source code.

- location_no:

  Observation location number.

- location_name:

  Observation location, as `from`\U{2192}`to`.

- meshcode10km:

  10 km mesh code.

- link_type:

  Link type.

- link_no:

  Link number.

- traffic:

  Traffic volume; missing observations are `NA`.

- to_link_end_10m:

  Distance to the link end, in units of 10 m. Kept as character because
  the values are zero-padded.

- link_ver:

  Link version.

## Examples

``` r
read_jartic_traffic(
  system.file("dummy", "type_b.csv", package = "jarticr")
)
#> Key: <datetime>
#>               datetime source_code location_no    location_name meshcode10km
#>                 <POSc>      <char>       <int>           <char>       <char>
#> 1: 2022-11-01 00:00:00          36           1  徳島駅前→県庁前       513376
#> 2: 2022-11-01 00:00:00          36           2 APAホテル前→南口       513376
#> 3: 2022-11-01 01:00:00          36           1  徳島駅前→県庁前       513376
#> 4: 2022-11-01 01:00:00          36           2 APAホテル前→南口       513376
#>    link_type link_no traffic to_link_end_10m link_ver
#>        <int>   <int>   <int>          <char>    <int>
#> 1:         1     101     120            0050        1
#> 2:         1     102      45            0120        1
#> 3:         1     101      80            0050        1
#> 4:         1     102      NA            0120        1
```
