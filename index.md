# jarticr

[日本道路交通情報センター（JARTIC）](https://www.jartic.or.jp)が公開するオープンデータのうち、**断面交通量情報（type
B）**を R で読み込むためのパッケージ。

生データは都道府県別・月別の CP932 エンコーディング
CSV（ヘッダ行あり・CRLF）で配布される。[`read_jartic_traffic()`](https://uribo.github.io/jarticr/reference/read_jartic_traffic.md)
が文字コード変換・列名付与・型変換をまとめて処理し、`data.table`
を返す。配布形式は年月によって揺れており、2018 年 2 月より前のファイルは
`link_ver`（リンクバージョン）を持たない 9
列で、日時の書式も提供元ごとに異なる。いずれも同じ 10 列の `data.table`
として読み込める（9 列期の `link_ver` は `NA`）。

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
