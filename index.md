# jarticr

jarticr は、日本の道路交通量に関する2つの異なるデータ源を R
で扱うためのパッケージ。JARTIC の断面交通量情報（type
B）ファイルの読み込みと、国土交通省 xROAD 交通量 API
のリクエスト作成・取得・GeoJSON／CSV
解析を提供する。データの読み込み・解析を担う関数は `data.table`
を返すが、2つのデータ源では主体、内容、利用規約、必要な出典表記が異なる。

## 2つのデータ源

| データ源 | 提供主体・内容 | jarticr の関数 |
|----|----|----|
| 断面交通量情報（type B） | 日本道路交通情報センター（JARTIC）が公開する都道府県別・月別 CSV | [`read_jartic_traffic()`](https://uribo.github.io/jarticr/reference/read_jartic_traffic.md) |
| xROAD 交通量 API | 国土交通省が常設トラカンと CCTV トラカンから提供する交通量（参考値）。JARTIC は API を媒介する | [`xroad_build_request()`](https://uribo.github.io/jarticr/reference/xroad_build_request.md)、[`xroad_perform_request()`](https://uribo.github.io/jarticr/reference/xroad_perform_request.md)、[`xroad_parse_traffic()`](https://uribo.github.io/jarticr/reference/xroad_parse_traffic.md)、[`xroad_get_traffic()`](https://uribo.github.io/jarticr/reference/xroad_get_traffic.md) |

### JARTIC 断面交通量情報（type B）

生データは都道府県別・月別の CP932 エンコーディング
CSV（ヘッダ行あり・CRLF）で配布される。[`read_jartic_traffic()`](https://uribo.github.io/jarticr/reference/read_jartic_traffic.md)
が文字コード変換・列名付与・型変換をまとめて処理し、`data.table`
を返す。配布形式は年月によって揺れており、2018 年 2 月より前のファイルは
`link_ver`（リンクバージョン）を持たない 9
列で、日時の書式も提供元ごとに異なる。いずれも同じ 10 列の `data.table`
として読み込める（9 列期の `link_ver` は `NA`）。

### 国土交通省 xROAD 交通量 API

4つのレイヤ（常設トラカン／CCTV
トラカンの5分値／1時間値）を扱う。リクエスト作成、HTTP
実行、本文解析を分離しているため、保存済み GeoJSON または CSV
応答はネットワークなしで解析できる。レイヤ名と CQL
は、観測間隔、カウンター種別、道路種別、時間、範囲から組み立てる。公式仕様に掲載された二重引用符付きの
CQL 項目名は実際の API では HTTP 400
になるため、クライアントは実動作が確認された引用符なしの形式を生成する。

常設トラカンの5分値・1時間値、CCTV の5分値、CCTV
の1時間値は3種類の戻り値スキーマを持つ。CCTV 5分値の判定不能状態は空文字
`""` のまま保持され、正常値 `"0"` と区別できる。CCTV 1時間値（様式4）は
`time_slot` を `19` のような2桁の時として返す一方、ほかの様式は `1900`
のような `hhmm` で返すため、`time_slot` は原値を保持し、`datetime`
は全様式で12桁の `time_code` から導出する。様式4の `5分欠測処理フラグ`
は仕様書の `"1"`／`"2"` と異なり、実応答では `"0"`／`"2"`
が観測されたため、文字列のまま保持して値域を制限しない。API
のデータは参考値であり、利用の手引きには「事前に職員によるデータチェック等は実施していない」と明記されている。環境条件や機器条件により精度が変動し得るため、返される状態フラグを確認すること。

``` r

req <- xroad_build_request(
  interval = "5m",
  counter_type = "fixed",
  road_type = 3,
  time_code = 202608131900,
  bbox = c(134.45, 33.95, 134.70, 34.15)
)

# 通信は明示的に実行する。既定で約3秒に1回へ抑制される。
body <- xroad_perform_request(req)
d_xroad <- xroad_parse_traffic(body, interval = "5m", counter_type = "fixed")

# 保存済みレスポンスは通信なしで解析できる。
d_saved <- xroad_parse_traffic("response.geojson", "5m", "fixed")
```

この API では WFS の `count`
パラメータが無視されることが実測されている。大きな応答は切り詰められず、6,291,556
バイトの上限を超えると HTTP 200
のエラー本文になるため、時間範囲を分割するか bounding box
を狭める必要がある。CSV は JSON 文字列として返されるが、GeoJSON
の約3分の1のサイズで、座標精度も高い。`output_format = "csv"`
を指定すれば、クライアントが JSON の解包と WKT 座標の解析を行い、GeoJSON
と同じ列・型を返す。

空の正常応答は0行の型付き `data.table`
になる。提供期間外の時間と範囲内に観測点がない場合は同じ応答になるため、クライアントは両者を区別せず、提供期間による入力制限も行わない。

## インストール

``` r

# install.packages("remotes")
remotes::install_github("uribo/jarticr")
```

## 使い方

``` r

library(jarticr)

# 断面交通量情報（type B）の CSV を読み込む
d <- read_jartic_traffic("data-raw/typeB/36_tokushima/202211_36.csv")

# 観測地点の一覧を作る（location_name を起点・終点に分割）
jartic_type_b_loc_tiny(d)

# データ提供元（47 都道府県。北海道のみ 5 方面に分割され計 51 件）
jartic_provider
```

パッケージに同梱したダミーデータで動作を確認できる。

``` r

read_jartic_traffic(system.file("dummy", "type_b.csv", package = "jarticr"))
```

## 断面交通量情報（type B）の列

| 列 | 型 | 内容 |
|----|----|----|
| `datetime` | POSIXct (`Asia/Tokyo`) | 観測時刻。読み込み後にこの列でキーが張られる |
| `source_code` | character | 情報源コード |
| `location_no` | integer | 観測地点番号 |
| `location_name` | character | 観測地点名（`起点→終点`）。NFKC 正規化・空白圧縮済み |
| `meshcode10km` | character | 10km メッシュコード |
| `link_type` | integer | リンク種別 |
| `link_no` | integer | リンク番号 |
| `traffic` | integer | 交通量。欠測は `NA` |
| `to_link_end_10m` | character | リンク終端までの距離（10m 単位、ゼロ埋め） |
| `link_ver` | integer | リンクバージョン |

## 元データについて

- 配布元: <https://www.jartic.or.jp/service/opendata/>
- 更新: 月初（平日）に 2
  か月前のデータが公表される。それより前のデータは配布元から取得できない
- 取得・アーカイブのワークフローは別リポジトリ
  [uribo/jartic_storage](https://github.com/uribo/jartic_storage) にある
- 生データはリポジトリにコミットしない（`.gitignore` で `data-raw/`
  以下の CSV / ZIP を除外）

## 出典・利用規約

### JARTIC 断面交通量情報（type B）

本パッケージが読み込むデータは JARTIC
の[利用規約](https://www.jartic.or.jp/d/opendata/riyou_kiyaku.pdf)（クリエイティブ・コモンズ
表示 4.0
国際と互換）のもとで公開されている。複製・公衆送信・翻案は商用を含めて自由だが、公表・提供にあたっては出典の記載が求められる。

> 出典：「断面交通量情報」（公益財団法人日本道路交通情報センター）<https://www.jartic.or.jp/service/opendata/>（〇年〇月〇日に利用）

編集・加工したうえで公表する場合は、上記の出典とは別に加工した旨を明示する。JARTIC
または国・府省等が作成したかのような態様で公表してはならない。

> 「断面交通量情報」（公益財団法人日本道路交通情報センター）<https://www.jartic.or.jp/service/opendata/>を加工して作成

同梱データについて。

- `jartic_provider` の提供元区分（北海道のみ 5
  方面に分割される等）は上記オープンデータページに基づく
- `inst/dummy/*.csv` は配布形式を模して `data-raw/dummy_typeB.R`
  が生成した合成データで、JARTIC のデータそのものは含まない

（利用規約は 2026-08-21
に確認した。規約は事前告知なく変更されることがある）

### 国土交通省 xROAD 交通量 API

xROAD 交通量 API のデータは国土交通省の交通量（参考値）であり、JARTIC
の断面交通量情報（type B）ではない。API
データをウェブサイトや資料等で公表する場合は、次の出典表記が求められる。

> 交通量 API（国土交通省）機能による交通量(参考値)

加工した API データを公表する場合は、次のように記載する。

> 国土交通省 API 機能による交通量(参考値)を加工して作成

国土交通省が作成したかのような態様で結果を公表してはならない。また、短時間の大量アクセスは禁止されているため、API
クライアントは既定で約3秒に1回へ通信を抑制する。利用前に最新の交通量 API
利用規約を確認すること。

## 開発

``` bash
# ビルドとチェック
R CMD build .
R CMD check jarticr_*.tar.gz

# テストのみ
Rscript -e 'testthat::test_local()'

# フォーマット（VS Code / Positron では保存時に自動実行）
air format .
```

規約は [CLAUDE.md](https://uribo.github.io/jarticr/CLAUDE.md)（Codex
向けの補足は
[AGENTS.md](https://uribo.github.io/jarticr/AGENTS.md)）を参照。

## ライセンス

MIT © Shinya Uryu
