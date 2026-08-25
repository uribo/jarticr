# Perform an xROAD traffic-volume API request

Performs a request created by
[`xroad_build_request()`](https://uribo.github.io/jarticr/reference/xroad_build_request.md)
and returns its body. The body is not interpreted here, because the API
can return error payloads with a successful HTTP status. Pass the result
to
[`xroad_parse_traffic()`](https://uribo.github.io/jarticr/reference/xroad_parse_traffic.md).

## Usage

``` r
xroad_perform_request(request)
```

## Arguments

- request:

  An `httr2_request`, normally from
  [`xroad_build_request()`](https://uribo.github.io/jarticr/reference/xroad_build_request.md).

## Value

The response body as a length-one character vector.

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
