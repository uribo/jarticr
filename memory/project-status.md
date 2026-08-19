---
name: project-status
description: 現在の進捗・直近の作業・次のステップ
type: project
updated: 2026-08-19
---

# jarticr — Status

- **現在フェーズ**: 実装（未 CRAN、GitHub インストールのみ）
- **直近の作業**: リポジトリ整備。DESCRIPTION の実記入、.Rbuildignore / .gitignore 拡充、air・.vscode・.claude・.codex の設定、R-CMD-check / pkgdown ワークフロー、testthat 一式（CP932 フィクスチャ込み）、README / NEWS / CLAUDE.md / AGENTS.md / memory を追加。`R/read_jartic_trafifc.R` の綴り誤りを `R/read_jartic_traffic.R` に修正
- **次のステップ**:
    - roxygen2 を導入して `man/` を再生成（`@return` 欠落・`RoxygenNote` の更新はそれとセットで行う）
    - `CLAUDE.md`「既知の課題」の破壊的変更（`tidyr::separate()` の置き換え、`→` 無し行の扱い、type A 対応、arrow スキーマの再導入）をユーザーと相談して優先順位付け
- **ブロッカー**: なし

**How to apply:** セッション終了時に進捗が変化したらこのファイルを更新する。
