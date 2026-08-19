---
name: project-status
description: 現在の進捗・直近の作業・次のステップ
type: project
updated: 2026-08-19
---

# jarticr — Status

- **現在フェーズ**: 実装（未 CRAN、GitHub インストールのみ）
- **直近の作業**:
    - リポジトリ整備（[PR #1](https://github.com/uribo/jarticr/pull/1) マージ済み）。DESCRIPTION の実記入、.Rbuildignore / .gitignore 拡充、air・.vscode・.claude・.codex の設定、R-CMD-check / pkgdown ワークフロー、testthat 一式（CP932 フィクスチャ込み）、README / NEWS / CLAUDE.md / AGENTS.md / memory を追加。`R/read_jartic_trafifc.R` の綴り誤りを修正
    - roxygen2 8.1.0 を導入し `man/` を再生成。`jartic_type_b_loc_tiny()` に欠けていた `@return` を追加、`read_jartic_traffic()` の返り値を列ごとに記述、同梱ダミーデータを使う `@examples` を 2 関数に追加。markdown 記法を有効化（`Roxygen: list(markdown = TRUE)`）。roxygen2 8.x は版を `Config/roxygen2/version` に記録し `RoxygenNote` は書かない
- **次のステップ**:
    - pkgdown が `gh-pages` を作った後、Settings → Pages でブランチを指定する（未設定だとサイトが 404 のままバッジだけ green になる）
    - `CLAUDE.md`「既知の課題」の破壊的変更（`tidyr::separate()` の置き換え、`→` 無し行の扱い、type A 対応、arrow スキーマの再導入）をユーザーと相談して優先順位付け
- **ブロッカー**: なし

**How to apply:** セッション終了時に進捗が変化したらこのファイルを更新する。
