# Read a JARTIC type B traffic file

Reads one cross-sectional traffic volume ("type B") CSV file published
by the Japan Road Traffic Information Center. The files are
CP932-encoded and carry a header row; this function drops that row,
supplies stable column names, parses `datetime` in JST, and normalizes
`location_name` with NFKC.

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

  Distance to the link end, in units of 10 m. Kept as character so that
  whatever the source writes – padding included – survives the read.

- link_ver:

  Link version; `NA` for files published before 2018-02.

## Details

The published layout has changed over time, so the header row is
inspected before the file is read:

- Files from 2018-02 onwards have 10 columns. Earlier files have 9 and
  no `link_ver`; for those, `link_ver` is filled with `NA` so that the
  returned columns are the same in either case.

- A file whose first row is already an observation (no header) is read
  in full; the first row is not consumed as a header.

- `datetime` is written as `2026/06/01 00:00` by most providers, but the
  pre-2018-02 files also use `2017/8/1 0:00:00`. Both are parsed, and
  values that survive as `NA` are reported with a warning rather than
  passed on silently.

Bytes that are not valid CP932 cannot be decoded and leave `NA` in
`location_name`. That is reported with a warning too, because the rest
of the row still looks intact.

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
#> 1:         1     101     120            0050   202200
#> 2:         1     102      45            0120   202200
#> 3:         1     101      80            0050   202200
#> 4:         1     102      NA            0120   202200
```
