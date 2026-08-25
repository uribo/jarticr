---
name: project-status
description: 現在の進捗・直近の作業・次のステップ
type: project
updated: 2026-08-25
---

## 引き継ぎ（HANDOFF）

**現在採用している方針**（採用した方法と理由）:
xroad（国土交通省 交通量 API）クライアントは実装・マージ済み。挙動は公式仕様書ではなく**実機を叩いて録画した 19 本の応答**に合わせてある。仕様書は 4 か所で実機と食い違っていた: (1) 例示されている引用符つき CQL は HTTP 400 で通らない、(2) `count` は無視され打ち切りは起きない（実際の限界は約 6MB で、しかも HTTP 200 で失敗が返る）、(3) プロパティ名は PDF から転記できない（`収集時間フラグ（5分間／1時間）` にスペースは入らない）、(4) レイヤは 4 種だがスキーマは 3 種。`datetime` は `時間帯` ではなく `時間コード` から導出している。

**次に行う作業**（1 つだけ）:
引継ぎ B（`2607_tokushima_tourism_flow`）の実取得は 2026-08-25 に完了（197 リクエスト・失敗 0）。あちらは `xroad_build_request()` / `xroad_perform_request()` / `xroad_parse_traffic()` の 3 段を `sys.source()` で直接読んで使っている（`lubridate` を持たない renv 環境のため、パッケージとしてはロードしていない）。ハードチェックポイントは達成済みで、フォールバックは発動しなかった。

**試して失敗したこと**:
httptest2 を Suggests に足すことを検討したが、httr2 の `with_mocked_responses()` で足りるので不採用（ユーザー確認済み）。

**未確認の項目**:
様式 4 のテストは録画から抜いた 2 件に留まり、1 時間値 CCTV の欠測パターンを広く踏んでいない。

**最後に実行した検証と結果**:
[PR #5](https://github.com/uribo/jarticr/pull/5) を作成し、Copilot の指摘 4 件に返信・修正して resolve、`991c7b0` として main へマージ（2026-08-25 17:47 JST）。GitHub Actions は 6 ジョブすべて通過（Ubuntu の release / devel / oldrel-1、macOS、Windows、pkgdown）。`oldrel-1` が通ったことで `Depends: R (>= 4.1)` への引き上げも実地で確認できた。`testthat::test_local()` は 137 通過・失敗 0・skip 0、`R CMD check` は `Status: OK`。`xroad_bbox()` と `xroad_digits()` に `decimal.mark = "."` を固定し、`OutDec = ","` 下でも golden フィルタがバイト一致することを回帰テストで押さえた。

# jarticr — Status

- **現在フェーズ**: 実装完了（未 CRAN、GitHub インストールのみ）。第 2 データソース（xroad）のサポート追加完了・マージ済み
- **直近の作業**:
    - xroad API（国土交通省交通量 API）のサポート追加（[PR #5](https://github.com/uribo/jarticr/pull/5)・2026-08-25 マージ）。新規ファイル R/xroad_traffic.R、data-raw/xroad_fixtures.R、tests/testthat/test-xroad_traffic.R、tests/testthat/fixtures/（9 ファイル）。新規関数 xroad_build_request(), xroad_perform_request(), xroad_parse_traffic(), xroad_get_traffic()。DESCRIPTION に httr2 と jsonlite を追加、Depends を R >= 4.1 に上げた（httr2 の要件）。README / NEWS / NAMESPACE / man/ も更新。CLAUDE.md に xroad scope を追加。
    - 実データプローブ（19 リクエスト）により API 仕様を確認。frozen PDF 仕様と異なる事実を 9 件記録: (1) CQL で double quote は AWS API Gateway で reject（unquoted のみ可）、(2) WFS count パラメータは無視（ページング実装なし）、(3) 実制限は約 6 MB 応答上限で HTTP 200 + JSON error body、(4) 結果ゼロと時間切れは同じ empty FeatureCollection（区別不可）、(5) outputFormat=csv は JSON エスケープ CSV 文字列で JSON 量 1/3、(6) フィールド名は PDF 転記でなく実応答から取得（スペース混在など）、(7) null count は NA_integer_、CCTV フラグは 3 値("0", "1", "")、(8) レイヤは 4 種だがスキーマは **3 種**（様式 1・2 の常設トラカンが同一、様式 3 の CCTV 5 分値がカメラ状態フラグ 10 種を持ち、様式 4 の CCTV 1 時間値はカメラフラグを一切持たず `5分欠測処理フラグ` を持つ第 3 のスキーマ。「様式 3・4 が同一スキーマ」は Claude のブリーフの誤りで、Codex の指摘が正しかった）、(9) CCTV 観測地点は Kinki だけでなく Shikoku にも 78 件。
    - 検証: testthat::test_local() 137 passing、R CMD check Status: OK、air format --check clean。golden response で acceptance table 再現。CQL byte-identical 確認。GitHub Actions all six jobs passed (Ubuntu release/devel/oldrel-1, macOS, Windows, pkgdown)。
    - 様式 4（CCTV 1 時間値）を録画で確定（第 3 ラウンドのプローブ）。`時間帯` は 2 桁時（`19`）で返る一方 `時間コード` は `hhmm`（`202608131900`）なので、`hhmm` 前提で組み立てると 19:00 が 00:19 になる。`datetime` は `時間コード` から導出して回避済み。リクエスト側の `時間コード` は様式 4 でも 12 桁必須（10 桁は 0 件）。`5分欠測処理フラグ` の実測値は `"0"` と `"2"` で、仕様書の `"1"`/`"2"` と食い違うため値域の検証はかけていない。欠測は JSON `null` で `NA_integer_` に落とす。`開発建設部／都道府県コード` は中部で埋まる（`"24"`・地方整備局等番号 85）
    - 上記の直前のセッション（2026-08-20～21）の内容は以下:
    - リポジトリ整備（[PR #1](https://github.com/uribo/jarticr/pull/1) マージ済み）。DESCRIPTION の実記入、.Rbuildignore / .gitignore 拡充、air・.vscode・.claude・.codex の設定、R-CMD-check / pkgdown ワークフロー、testthat 一式（CP932 フィクスチャ込み）、README / NEWS / CLAUDE.md / AGENTS.md / memory を追加。`R/read_jartic_trafifc.R` の綴り誤りを修正
    - コード全体の見直し（2026-08-20）。`jartic_type_b_loc_tiny()` の `tidyr::separate()` を `stringi::stri_split_fixed(n = 2L)` に置換し、`tidyr` を Imports から撤去。**`separate()` は data.table を plain `data.frame` に落としていたため、公開 API の契約（data.table を返す）に既に違反していた**（CLAUDE.md「既知の課題」の前提が逆だった）。矢印なし・複数矢印・NA の挙動を契約として明文化。`read_jartic_traffic()` に `header = FALSE` を明示（**これは誤り。実データは全期間でヘッダ行を持つため、この変更で現行月のファイルすら読めなくなった。翌日 [#3](https://github.com/uribo/jarticr/issues/3) の対応で先頭行のスニフに置き換えた**）、`iconv` の `to` を `"UTF-8"` に正し、CP932 として不正なバイトを警告するようにした。テストを 28 → 36 に拡充（戻り値クラス・分割の境界・ヘッダなし契約・CP932 警告）
    - roxygen2 8.1.0 を導入し `man/` を再生成。`jartic_type_b_loc_tiny()` に欠けていた `@return` を追加、`read_jartic_traffic()` の返り値を列ごとに記述、同梱ダミーデータを使う `@examples` を 2 関数に追加。markdown 記法を有効化（`Roxygen: list(markdown = TRUE)`）。roxygen2 8.x は版を `Config/roxygen2/version` に記録し `RoxygenNote` は書かない
- **[#3](https://github.com/uribo/jarticr/issues/3) 対応（2026-08-20、ブランチ `fix/typeb-header-and-9col`）**: 2018-02 より前の 9 列ファイルと秒つき日時に対応。調査の過程で、**「ヘッダ行なし」という前提そのものが実データと食い違っていた**ことが判明した（2017-08 の 51 提供元、2026-06 の現行ファイルともヘッダ行あり・CRLF）。`read_jartic_traffic()` は先頭 1 行だけを読んでヘッダの有無と列数を判定し、`skip` / `colClasses` / `col.names` を切り替える。9 列期は `link_ver = NA_integer_` で補い戻り値は常に 10 列。日時は `ymd_hm()` → NA のみ `ymd_hms()` にフォールバックし、残った NA を件数つきで警告。9/10 以外の列数はエラー。フィクスチャを実データ準拠（ヘッダ＋CRLF）に作り直し、9 列用 `inst/dummy/type_b_9col.csv` を追加。testthat の expectation 数 36 → 51（テストブロック数ではなくアサーション数）。実ファイル（akita 2017-08 の 30 万行、tokushima 2026-06）で検証済み
- **[PR #4](https://github.com/uribo/jarticr/pull/4) の Copilot レビュー対応（2026-08-20）**: 「ヘッダのみのファイルが空の `data.table` を静かに返す」という指摘は事実誤認（data.table 1.18.4 では `fread()` が `skip=1 but the input only has 1 line` でエラーになる）。ただしエラー文言が data.table の内部由来でファイル名も本当の問題も示さないため、スニフを 1 行から 2 行に増やして明示的に弾くようにした（`'<file>' has a header row but no observations.`）。**指摘の前提は実際に走らせて検証してから受け入れる**
- **未解決の疑問**: roxygen の「`to_link_end_10m` はゼロ埋めだから character」という根拠は実データに見当たらない（2017-08 / 2026-06 でゼロ埋めゼロ件）。型は公開 API なので据え置き、文言のみ修正した。フィクスチャの `202211010000`（コンパクト日時）と `"0050"` も実データでは未確認の合成値
- **公開（2026-08-21）**: リポジトリを public にした。JARTIC の[利用規約](https://www.jartic.or.jp/d/opendata/riyou_kiyaku.pdf)は政府標準利用規約 2.0 型・CC BY 4.0 互換で、複製・公衆送信・翻案は商用含め自由。義務は出典記載と編集・加工の明示なので、README に「出典・利用規約」節を追加した。pkgdown サイト <https://uribo.github.io/jarticr/> は public 化と同時に Pages の build が走って解決（`gh-pages` と Pages 設定は既にあり、private が理由で 404 だった）
- **未対応・課題**:
    - **プローブの保管場所**: 実機を叩いた 19 本の応答と `probe_xroad_round1〜3.sh` は `2607_tokushima_tourism_flow/data-raw/jartic-open-traffic/probe-2026-08-25/` に `SHA256SUMS` 付きで退避済み（gitignored。本パッケージのフィクスチャはそこから抜いたもの）
    - **保持期間を実測した**（2026-08-25、二分探索）。**ガイダンスサイトの公称は両方とも短すぎる**: 5 分値の下限は `202607120900` が返り `202607110900` が 0 件（公称 1 ヶ月に対し実測 45 日）、1 時間値は `202605120900` が返り `202605100900` が 0 件（公称 3 ヶ月に対し実測約 105 日）。**規約第 11 条により告知なく変わりうるので保証として扱わない**。なお 1 時間値は同じ BBOX で 5 観測点、5 分値は 4 観測点で、**1 時間値にしか現れない観測点がある**
    - **様式 4 のテストの薄さ**: 録画から抜いた 2 件しか使っておらず、1 時間値 CCTV の欠測パターンやカメラ状態フラグの分布を広く踏んでいない
    - 残る「既知の課題」（type A 対応、arrow スキーマの再導入）はユーザーと相談して優先順位付け
    - 未着手の軽微な整理: `jartic_vars` を `R/location.R` から別ファイルへ、`unique()` の冗長な `by=`、`jartic_provider` が tibble なのに tibble は Suggests

**How to apply:** セッション終了時に進捗が変化したらこのファイルを更新する。
