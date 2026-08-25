# Build an xROAD traffic-volume API request

Builds a WFS `GetFeature` request from typed traffic constraints. This
function only constructs an `httr2_request`; it does not access the
network.

## Usage

``` r
xroad_build_request(
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

An `httr2_request`.

## Details

The deployed service ignores the WFS `count` parameter. Large requests
are instead limited by a 6,291,556-byte response cap, returned as an
HTTP 200 error body. Split the time range or shrink the bounding box
when that occurs. An empty response is a successful, typed zero-row
result; the API does not distinguish an aged-out time window from a
bounding box with no stations.

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

## Examples

``` r
req <- xroad_build_request(
  interval = "5m",
  counter_type = "fixed",
  road_type = 3,
  time_code = 202608131900,
  bbox = c(134.45, 33.95, 134.70, 34.15)
)
req
#> <httr2_request>
#> GET https://api.jartic-open-traffic.org/geoserver?service=WFS&version=2.0.0&request=GetFeature&typeNames=t_travospublic_measure_5m&srsName=EPSG%3A4326&outputFormat=application%2Fjson&exceptions=application%2Fjson&cql_filter=%E9%81%93%E8%B7%AF%E7%A8%AE%E5%88%A5%3D3%20AND%20%E6%99%82%E9%96%93%E3%82%B3%E3%83%BC%E3%83%89%3D202608131900%20AND%20BBOX%28%E3%82%B8%E3%82%AA%E3%83%A1%E3%83%88%E3%83%AA%2C134.45%2C33.95%2C134.70%2C34.15%2C%27EPSG%3A4326%27%29
#> Body: empty
#> Options:
#> * useragent: "jarticr (https://github.com/uribo/jarticr)"
#> Policies:
#> * throttle_realm         : "jarticr-xroad-traffic"
#> * error_is_error         : <function>
#> * retry_max_tries        : 3
#> * retry_on_failure       : TRUE
#> * retry_is_transient     : <function>
#> * retry_failure_threshold: Inf
#> * retry_failure_timeout  : 30
#> * retry_realm            : "api.jartic-open-traffic.org"
```
