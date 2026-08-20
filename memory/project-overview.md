---
name: project-overview
description: jarticr の目的・構成・技術スタック
type: project
updated: 2026-08-19
---

# jarticr — Overview

**Why:** 日本道路交通情報センター（JARTIC）が公開する断面交通量情報（type B）は、都道府県別・月別の CP932 CSV（ヘッダ行あり・CRLF）で配布され、列数と日時書式が年月・提供元で揺れる。読み込みのたびに文字コード・列名・型を書き直す手間を無くし、解析側（[uribo/jartic_storage](https://github.com/uribo/jartic_storage) 等）が中身に集中できるようにするのが本パッケージの役割。

## 技術スタック

- R パッケージ。依存の正典は `DESCRIPTION`（**renv は使わない**）
- 中核は `data.table`（読み込み・キー）＋ `lubridate` / `stringi` / `stringr`（正規化・地点名の分割）。`tidyr` 依存は 2026-08-20 に撤去した
- テストは testthat 3rd edition。`inst/dummy/type_b.csv`（CP932 バイト固定）に対して読み込みの契約を検証する
- CI は `R-CMD-check`（5 プラットフォーム）と `pkgdown`
- フォーマッタは air。Claude Code / Codex 設定で `R_ENVIRON_USER=/dev/null` と `LC_COLLATE=C` を固定

## 公開 API

- `read_jartic_traffic(path)`: type B CSV → `data.table`（`datetime` キー、JST）。先頭行からヘッダの有無と列数（9/10）を判定し、9 列期（2018-02 より前）は `link_ver` を `NA` で補って常に 10 列を返す
- `jartic_type_b_loc_tiny(data)`: 観測地点テーブル（`location_name` を**最初の** `→` で分割。矢印なしは全体を `location_from` に残す）
- `jartic_provider`: 提供元 51 件（47 都道府県、北海道のみ 5 方面）

**How to apply:** 新しいタスクに着手する前にこのファイルで全体像を確認する。詳細な規約は `CLAUDE.md` を参照。
