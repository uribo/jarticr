# Parse an xROAD traffic-volume API response

Parses a saved GeoJSON or JSON-encoded CSV response without making a
network request. It detects API error payloads from their content,
verifies GeoJSON completeness, maps Japanese properties to stable
English names, and preserves all status flags. CSV and GeoJSON return
identical schemas; CSV retains the service's higher coordinate
precision.

## Usage

``` r
xroad_parse_traffic(body, interval, counter_type)
```

## Arguments

- body:

  A length-one response string or the path to a saved response.

- interval:

  Aggregation interval: `"5m"` or `"1h"`.

- counter_type:

  Counter type: `"fixed"` for a permanent traffic counter or `"cctv"`
  for an image-recognition counter.

## Value

A `data.table` keyed on `station_code` and `datetime`. Traffic counts
are integers and missing counts remain `NA_integer_`. Status flags
remain character values: `"0"`, `"1"`, or `""` when the CCTV service
could not judge a flag. `longitude` and `latitude` contain the first
point of each `MultiPoint` geometry.

## Details

A well-formed empty collection is returned as a fully typed zero-row
table. It can mean either that the time is outside the available window
or that no station matches the spatial filter; the API does not
distinguish them. CCTV 5-minute status flags preserve an empty string as
the observed indeterminate state. Form 4 returns `time_slot` as a
two-digit hour (`19`), while every other recorded form returns `hhmm`
(`1900`); `time_slot` is kept unnormalized. `datetime` is derived from
the unambiguous 12-digit `time_code`. Recorded form 4 processing flags
are `"0"` and `"2"`, although the specification documents `"1"` and
`"2"`; the character values are kept without domain validation.

## Errors

API failures have the shared parent class `xroad_api_error`. More
specific classes are `xroad_truncation_error`,
`xroad_payload_cap_error`, `xroad_malformed_request_error`, and
`xroad_response_error`.

## Data source, quality, and attribution

The xROAD traffic-volume API provides reference values owned by the
Ministry of Land, Infrastructure, Transport and Tourism (MLIT), not
JARTIC type B data. The data guide states that
「事前に職員によるデータチェック等は実施していない」 and warns that
observation accuracy can vary with environmental and equipment
conditions.

When publishing unprocessed API data, the terms require the attribution
「交通量 API（国土交通省）機能による交通量(参考値)」. For processed
data, use 「国土交通省 API 機能による交通量(参考値)を加工して作成」. Do
not publish results in a manner suggesting that MLIT authored them.
