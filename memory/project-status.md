---
name: project-status
description: 現在の進捗・直近の作業・次のステップ
type: project
updated: 2026-08-25
---

## 引き継ぎ（HANDOFF）

**現在採用している方針**（採用した方法と理由）:
xroad（国土交通省交通量 API）サポートを追加。JARTIC type B と異なる第 2 データソース。実データプローブ（19 リクエスト）で API 仕様を確認し、その結果に基づいて実装。Codex による実装 2 ラウンド、Claude によるレビュー＋プローブ設計。新規関数 xroad_build_request(), xroad_perform_request(), xroad_parse_traffic(), xroad_get_traffic()。

**次に行う作業**（1 つだけ）:
round 3 プローブで form 4（CCTV 1 時間値）を検証し、フィクスチャと列マップに反映してからコミット。commit 先（main 直接 or ブランチ＋PR）と tag はユーザー決定待ち。

**試して失敗したこと**:
httptest2 の Suggests 追加を検討したが、httr2 の with_mocked_responses() で充分なため不採用（ユーザーに確認済み）。

**未確認の項目**:
form 4 の 時間帯 フォーマット（仕様書 2 桁 vs hhmm の可能性）。GitHub Actions R-CMD-check 未実行。round 3 プローブスクリプト（scratchpad に ready）未実行。

**最後に実行した検証と結果**:
testthat::test_local() → 122 passing, 0 failures, 0 skips。R CMD check --no-manual → Status: OK。air format --check → clean。記録した golden response で acceptance table を再現（4 駅、座標と上下通行量）。

# jarticr — Status

- **現在フェーズ**: 実装（未 CRAN、GitHub インストールのみ）。第 2 データソース（xroad）のサポート追加中
- **直近の作業**:
    - xroad API（国土交通省交通量 API）のサポート追加（2026-08-25）。新規ファイル R/xroad_traffic.R、data-raw/xroad_fixtures.R、tests/testthat/test-xroad_traffic.R、tests/testthat/fixtures/（9 ファイル）。新規関数 xroad_build_request(), xroad_perform_request(), xroad_parse_traffic(), xroad_get_traffic()。DESCRIPTION に httr2 と jsonlite を追加、Depends を R >= 4.1 に上げた（httr2 の要件）。README / NEWS / NAMESPACE / man/ も更新。
    - 実データプローブ（19 リクエスト）により API 仕様を確認。frozen PDF 仕様と異なる事実を 9 件記録: (1) CQL で double quote は AWS API Gateway で reject（unquoted のみ可）、(2) WFS count パラメータは無視（ページング実装なし）、(3) 実制限は約 6 MB 応答上限で HTTP 200 + JSON error body、(4) 結果ゼロと時間切れは同じ empty FeatureCollection（区別不可）、(5) outputFormat=csv は JSON エスケープ CSV 文字列で JSON 量 1/3、(6) フィールド名は PDF 転記でなく実応答から取得（スペース混在など）、(7) null count は NA_integer_、CCTV フラグは 3 値("0", "1", "")、(8) レイヤは 4 種だがスキーマは **3 種**（様式 1・2 の常設トラカンが同一、様式 3 の CCTV 5 分値がカメラ状態フラグ 10 種を持ち、様式 4 の CCTV 1 時間値はカメラフラグを一切持たず `5分欠測処理フラグ` を持つ第 3 のスキーマ。「様式 3・4 が同一スキーマ」は Claude のブリーフの誤りで、Codex の指摘が正しかった）、(9) CCTV 観測地点は Kinki だけでなく Shikoku にも 78 件。
    - 検証: testthat::test_local() 122 passing、R CMD check --no-manual Status: OK、air format --check clean。golden response で acceptance table 再現（4 駅、座標と上下通行量）。CQL byte-identical 確認。
    - 未確定: form 4（CCTV 1 時間値）のスキーマは仕様書由来（未 recorded）。時間帯フォーマット（2 桁 vs hhmm）未確認。round 3 プローブスクリプト ready だが未実行（scratchpad path）。
    - 上記の直前のセッション（2026-08-20～21）の内容は以下:
    - リポジトリ整備（[PR #1](https://github.com/uribo/jarticr/pull/1) マージ済み）。DESCRIPTION の実記入、.Rbuildignore / .gitignore 拡充、air・.vscode・.claude・.codex の設定、R-CMD-check / pkgdown ワークフロー、testthat 一式（CP932 フィクスチャ込み）、README / NEWS / CLAUDE.md / AGENTS.md / memory を追加。`R/read_jartic_trafifc.R` の綴り誤りを修正
    - コード全体の見直し（2026-08-20）。`jartic_type_b_loc_tiny()` の `tidyr::separate()` を `stringi::stri_split_fixed(n = 2L)` に置換し、`tidyr` を Imports から撤去。**`separate()` は data.table を plain `data.frame` に落としていたため、公開 API の契約（data.table を返す）に既に違反していた**（CLAUDE.md「既知の課題」の前提が逆だった）。矢印なし・複数矢印・NA の挙動を契約として明文化。`read_jartic_traffic()` に `header = FALSE` を明示（**これは誤り。実データは全期間でヘッダ行を持つため、この変更で現行月のファイルすら読めなくなった。翌日 [#3](https://github.com/uribo/jarticr/issues/3) の対応で先頭行のスニフに置き換えた**）、`iconv` の `to` を `"UTF-8"` に正し、CP932 として不正なバイトを警告するようにした。テストを 28 → 36 に拡充（戻り値クラス・分割の境界・ヘッダなし契約・CP932 警告）
    - roxygen2 8.1.0 を導入し `man/` を再生成。`jartic_type_b_loc_tiny()` に欠けていた `@return` を追加、`read_jartic_traffic()` の返り値を列ごとに記述、同梱ダミーデータを使う `@examples` を 2 関数に追加。markdown 記法を有効化（`Roxygen: list(markdown = TRUE)`）。roxygen2 8.x は版を `Config/roxygen2/version` に記録し `RoxygenNote` は書かない
- **[#3](https://github.com/uribo/jarticr/issues/3) 対応（2026-08-20、ブランチ `fix/typeb-header-and-9col`）**: 2018-02 より前の 9 列ファイルと秒つき日時に対応。調査の過程で、**「ヘッダ行なし」という前提そのものが実データと食い違っていた**ことが判明した（2017-08 の 51 提供元、2026-06 の現行ファイルともヘッダ行あり・CRLF）。`read_jartic_traffic()` は先頭 1 行だけを読んでヘッダの有無と列数を判定し、`skip` / `colClasses` / `col.names` を切り替える。9 列期は `link_ver = NA_integer_` で補い戻り値は常に 10 列。日時は `ymd_hm()` → NA のみ `ymd_hms()` にフォールバックし、残った NA を件数つきで警告。9/10 以外の列数はエラー。フィクスチャを実データ準拠（ヘッダ＋CRLF）に作り直し、9 列用 `inst/dummy/type_b_9col.csv` を追加。testthat の expectation 数 36 → 51（テストブロック数ではなくアサーション数）。実ファイル（akita 2017-08 の 30 万行、tokushima 2026-06）で検証済み
- **[PR #4](https://github.com/uribo/jarticr/pull/4) の Copilot レビュー対応（2026-08-20）**: 「ヘッダのみのファイルが空の `data.table` を静かに返す」という指摘は事実誤認（data.table 1.18.4 では `fread()` が `skip=1 but the input only has 1 line` でエラーになる）。ただしエラー文言が data.table の内部由来でファイル名も本当の問題も示さないため、スニフを 1 行から 2 行に増やして明示的に弾くようにした（`'<file>' has a header row but no observations.`）。**指摘の前提は実際に走らせて検証してから受け入れる**
- **未解決の疑問**: roxygen の「`to_link_end_10m` はゼロ埋めだから character」という根拠は実データに見当たらない（2017-08 / 2026-06 でゼロ埋めゼロ件）。型は公開 API なので据え置き、文言のみ修正した。フィクスチャの `202211010000`（コンパクト日時）と `"0050"` も実データでは未確認の合成値
- **公開（2026-08-21）**: リポジトリを public にした。JARTIC の[利用規約](https://www.jartic.or.jp/d/opendata/riyou_kiyaku.pdf)は政府標準利用規約 2.0 型・CC BY 4.0 互換で、複製・公衆送信・翻案は商用含め自由。義務は出典記載と編集・加工の明示なので、README に「出典・利用規約」節を追加した。pkgdown サイト <https://uribo.github.io/jarticr/> は public 化と同時に Pages の build が走って解決（`gh-pages` と Pages 設定は既にあり、private が理由で 404 だった）
- **未対応・課題**:
    - **xroad round 3 プローブ（form 4 CCTV 1 時間値）**: scratchpad の probe/probe_xroad_round3.sh が ready だが未実行。セッション終了時に path が失われるため再作成の可能性あり。結果取得後、フィクスチャと列マップ（現在は provisional spec-derived）を更新。
    - **form 4 の 時間帯 フォーマット**: 仕様書は 2 桁 hour（0-23）と記述、他は hhmm（form 2 実績 1900）。実データで確認まで、実装は datetime 導出を 時間コード 由来にして hhmm 仮定を回避（実解析は pending）。
    - **GitHub Actions R-CMD-check**: 何も push されていないため未実行。ローカル check は Status: OK。
    - **hard checkpoint**: 2026-09-05 までにエンドツーエンド fetching が機能しない場合、packaging を abandoned にして 2607_tokushima_tourism_flow 内に minimal script として実装。理由: 阿波おどり期（2026-08-12～15）の 5 分値有効期限が 2026-09-12～15 ごろで、代替不能な履歴データ。
    - 残る「既知の課題」（type A 対応、arrow スキーマの再導入）はユーザーと相談して優先順位付け
    - 未着手の軽微な整理: `jartic_vars` を `R/location.R` から別ファイルへ、`unique()` の冗長な `by=`、`jartic_provider` が tibble なのに tibble は Suggests

**How to apply:** セッション終了時に進捗が変化したらこのファイルを更新する。
