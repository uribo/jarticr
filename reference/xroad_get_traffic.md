# Retrieve xROAD traffic-volume data

Convenience wrapper that composes
[`xroad_build_request()`](https://uribo.github.io/jarticr/reference/xroad_build_request.md),
[`xroad_perform_request()`](https://uribo.github.io/jarticr/reference/xroad_perform_request.md),
and
[`xroad_parse_traffic()`](https://uribo.github.io/jarticr/reference/xroad_parse_traffic.md).

## Usage

``` r
xroad_get_traffic(
  interval,
  counter_type,
  road_type = NULL,
  time_code = NULL,
  bbox = NULL,
  station_code = NULL,
  cql_filter = NULL,
  output_format = c("geojson", "csv"),
  throttle_seconds = 3,
  max_tries = 3
)
```

## Arguments

- interval:

  Aggregation interval: `"5m"` or `"1h"`.

- counter_type:

  Counter type: `"fixed"` for a permanent traffic counter or `"cctv"`
  for an image-recognition counter.

- road_type:

  Road type: `1` for a national expressway or `3` for a general national
  highway. Required unless `cql_filter` is supplied.

- time_code:

  One `YYYYMMDDhhmm` value, or two values defining a closed range.
  Required unless `cql_filter` is supplied. Minutes must be a multiple
  of 5 for 5-minute layers and `00` for hourly layers.

- bbox:

  Optional numeric `c(xmin, ymin, xmax, ymax)` bounding box.

- station_code:

  Optional station code, supplied as digits.

- cql_filter:

  Optional raw CQL escape hatch. It cannot be combined with the typed
  filter arguments and must not contain double quotes. The API rejects
  the double-quoted field names printed in its own specification.

- output_format:

  Response format: `"geojson"` or `"csv"`.

- throttle_seconds:

  Minimum average interval in seconds between requests in the same
  throttle pool. Defaults to 3 seconds.

- max_tries:

  Maximum number of attempts for transport failures, HTTP 429, and HTTP
  5xx responses. Use 1 to disable retries.

## Value

A `data.table` as described by
[`xroad_parse_traffic()`](https://uribo.github.io/jarticr/reference/xroad_parse_traffic.md).

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
