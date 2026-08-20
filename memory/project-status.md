---
name: project-status
description: 現在の進捗・直近の作業・次のステップ
type: project
updated: 2026-08-20
---

# jarticr — Status

- **現在フェーズ**: 実装（未 CRAN、GitHub インストールのみ）
- **直近の作業**:
    - リポジトリ整備（[PR #1](https://github.com/uribo/jarticr/pull/1) マージ済み）。DESCRIPTION の実記入、.Rbuildignore / .gitignore 拡充、air・.vscode・.claude・.codex の設定、R-CMD-check / pkgdown ワークフロー、testthat 一式（CP932 フィクスチャ込み）、README / NEWS / CLAUDE.md / AGENTS.md / memory を追加。`R/read_jartic_trafifc.R` の綴り誤りを修正
    - コード全体の見直し（2026-08-20）。`jartic_type_b_loc_tiny()` の `tidyr::separate()` を `stringi::stri_split_fixed(n = 2L)` に置換し、`tidyr` を Imports から撤去。**`separate()` は data.table を plain `data.frame` に落としていたため、公開 API の契約（data.table を返す）に既に違反していた**（CLAUDE.md「既知の課題」の前提が逆だった）。矢印なし・複数矢印・NA の挙動を契約として明文化。`read_jartic_traffic()` に `header = FALSE` を明示、`iconv` の `to` を `"UTF-8"` に正し、CP932 として不正なバイトを警告するようにした。テストを 28 → 36 に拡充（戻り値クラス・分割の境界・ヘッダなし契約・CP932 警告）
    - roxygen2 8.1.0 を導入し `man/` を再生成。`jartic_type_b_loc_tiny()` に欠けていた `@return` を追加、`read_jartic_traffic()` の返り値を列ごとに記述、同梱ダミーデータを使う `@examples` を 2 関数に追加。markdown 記法を有効化（`Roxygen: list(markdown = TRUE)`）。roxygen2 8.x は版を `Config/roxygen2/version` に記録し `RoxygenNote` は書かない
- **次のステップ**:
    - pkgdown が `gh-pages` を作った後、Settings → Pages でブランチを指定する（未設定だとサイトが 404 のままバッジだけ green になる）
    - 残る「既知の課題」（type A 対応、arrow スキーマの再導入）をユーザーと相談して優先順位付け
    - 未着手の軽微な整理: `jartic_vars` を `R/location.R` から別ファイルへ、`unique()` の冗長な `by=`、`jartic_provider` が tibble なのに tibble は Suggests
- **ブロッカー**: なし

**How to apply:** セッション終了時に進捗が変化したらこのファイルを更新する。
