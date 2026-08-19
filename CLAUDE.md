# jarticr

> 日本道路交通情報センター（JARTIC）オープンデータ「断面交通量情報（type
> B）」を R で読み込む R パッケージ。

本ファイルはセッション開始時に読み込まれるプロジェクトの一次知識源。R
パッケージとしての規約を定める（`targets`
パイプラインの研究プロジェクトではない）。

## プロジェクト概要

- **GitHub リポジトリ**: `uribo/jarticr`
- **pkgdown**: <https://uribo.github.io/jarticr/>
- **関連リポジトリ**:
  [uribo/jartic_storage](https://github.com/uribo/jartic_storage)（ダウンロード・parquet
  変換のワークフロー。本パッケージを利用する側）
- **公開状況**: 未 CRAN。GitHub からのインストールのみ

## ディレクトリ構成

    jarticr/
    ├── DESCRIPTION        # 依存マニフェスト（renv は使わない。理由は下記）
    ├── NAMESPACE          # roxygen2 生成物。手で編集しない
    ├── R/                 # 関数定義・データドキュメント
    ├── man/               # roxygen2 生成物。手で編集しない
    ├── data/              # エクスポートするデータ（.rda）
    ├── data-raw/          # data/ と inst/dummy/ の生成スクリプト（.Rbuildignore 済み）
    ├── inst/dummy/        # テスト用の小さな固定データ（CP932）
    ├── tests/testthat/    # testthat（3rd edition）
    ├── .github/workflows/ # R-CMD-check, pkgdown
    ├── memory/            # プロジェクト固有知識（会話間引き継ぎ）
    ├── CLAUDE.md          # 本ファイル
    ├── AGENTS.md          # Codex 固有の補足規約
    └── .codex/config.toml # Codex の sandbox・環境変数ポリシー

> **`.vscode/` の追跡方針**: 作者のグローバル gitignore は `.vscode`
> を無視するが、本リポジトリでは `.gitignore` の `!.vscode/`
> で再包含し意図的に追跡する。内容はワークフロー設定（air の
> formatOnSave・推奨拡張）に限り、テーマ・フォント等の個人的好みは置かない。

## 依存管理は renv ではなく DESCRIPTION

本リポジトリは **renv を使わない**。R パッケージは `DESCRIPTION` の
`Imports` / `Suggests`
が依存の正典であり、CI（`r-lib/actions/setup-r-dependencies`）もそこから解決する。依存を足したら
`DESCRIPTION` に書く。`renv.lock` / `.Rprofile`
を持ち込まない（research-project-template の renv 一式は、あちらが
`DESCRIPTION`
を持たない解析プロジェクトだから必要なものであって、ここでは二重管理になる）。

## R コード記述

### スタイル

- [tidyverse スタイル](https://style.tidyverse.org/)を
  [air](https://posit-dev.github.io/air/)
  でフォーマット（`air.toml`、編集時に hook で自動実行）
- 関数にはパッケージ名前空間プレフィックスを付ける:
  [`data.table::fread()`](https://rdrr.io/pkg/data.table/man/fread.html)、[`stringr::str_squish()`](https://stringr.tidyverse.org/reference/str_trim.html)
- roxygen2 の `@importFrom`
  で宣言した関数のみ、プレフィックスなしで使ってよい
- 変数名は英語のみ。コメント・ドキュメント・コミットメッセージは英語
- モダン tidyverse パターンを優先し superseded
  パターンを避ける。**ただし本パッケージの戻り値は `data.table`
  であることが公開 API
  の一部**なので、[`tidyr::separate()`](https://tidyr.tidyverse.org/reference/separate.html)
  → `separate_wider_delim()`
  のような置き換えは戻り値のクラスを変える。破壊的変更として別途扱う（下記「既知の課題」）

### 生成物を手で編集しない

`NAMESPACE` と `man/*.Rd` は roxygen2 の生成物。roxygen
コメントを直したら再生成する。

``` bash
Rscript -e 'roxygen2::roxygenise()'
```

roxygen2 8.x はバージョンを `DESCRIPTION` の `Config/roxygen2/version`
に記録する（7.x までの `RoxygenNote`
は書かれない）。**再生成なしにこのフィールドだけ書き換えない**（`man/`
の内容と食い違う）。roxygen コメントは markdown
記法で書く（`Roxygen: list(markdown = TRUE)`）。

### データとフィクスチャ

- `data/*.rda` は `data-raw/DATASET.R` から
  [`usethis::use_data()`](https://usethis.r-lib.org/reference/use_data.html)
  で生成する
- `inst/dummy/type_b.csv` は `data-raw/dummy_typeB.R`
  から生成する。**CP932 バイト列なので手で編集しない**。UTF-8
  で書き直すと
  [`read_jartic_traffic()`](https://uribo.github.io/jarticr/reference/read_jartic_traffic.md)
  の `iconv(from = "cp932")`
  が地点名を文字化けさせ、テストが無意味な値を検証する状態になる
- 生の JARTIC データ（都道府県別 CSV /
  ZIP）はコミットしない。`.gitignore` で除外済み

## テスト

- testthat 3rd edition（`Config/testthat/edition: 3`）
- フィクスチャのパスは `tests/testthat/helper-fixture.R` の
  `type_b_fixture()`
  経由で取る（[`system.file()`](https://rdrr.io/r/base/system.file.html)
  を各テストに散らさない）
- 検証は「読み込みの契約」に集中する:
  列名・列の型・タイムゾーン・キー・欠測の扱い・CP932 と NFKC
  の正規化結果
- **ゼロ埋め識別子（`to_link_end_10m` 等）が character
  のままであること**を必ず検証する。integer
  に落ちるとゼロが消え、静かにデータが壊れる

``` bash
Rscript -e 'testthat::test_local()'
```

## 共通コマンド

``` bash
# ビルド・チェック（devtools 非依存）
R CMD build .
R CMD check jarticr_*.tar.gz

# ドキュメント再生成（roxygen2 が必要）
Rscript -e 'roxygen2::roxygenise()'

# フォーマット（通常は編集時 hook で自動実行される）
air format .

# フィクスチャ再生成
Rscript data-raw/dummy_typeB.R
```

## 作業時の注意

### Issue・PR

- Issue 作成前に必ず既存 Issue を確認する（`gh issue list --state all`）
- GitHub 上の操作（issue 作成・クローズ、PR 作成、push
  等）は取り消しが困難。実行前にユーザーへ確認する

### Git ブランチ操作

- **ブランチの作成・切り替えは必ずユーザーに確認を求めてから実行する**

## コミット規約

**Conventional Commits v1.0.0**
に準拠する。コミットメッセージは英語。`Co-Authored-By:`
フッターは付けない。

| scope | 対象 |
|----|----|
| `read` | [`read_jartic_traffic()`](https://uribo.github.io/jarticr/reference/read_jartic_traffic.md)（読み込み） |
| `location` | 観測地点テーブル（`R/location.R`） |
| `data` | 同梱データ・`data-raw/` の生成スクリプト |
| `deps` | `DESCRIPTION` の依存 |
| `ci` | `.github/workflows/` |
| `docs` | README・roxygen・pkgdown |
| `test` | `tests/` |

例:

    feat(read): support type A traffic files
    fix(location): keep unsplit location names when the arrow is absent
    test(read): pin the CP932 decoding contract
    chore(deps): move tibble to Suggests

## セキュリティ・データ取り扱い

- 認証情報（API key、サービスアカウント JSON、`.env`）をコミットしない
- Claude Code / Codex の通常セッションでは `R_ENVIRON_USER=/dev/null`
  とし、R
  に資格情報ファイルを自動ロードさせない（`.claude/settings.json` /
  `.codex/config.toml`）。同ファイルで `LC_COLLATE=C`
  を設定し、[`sort()`](https://rdrr.io/r/base/sort.html) /
  [`factor()`](https://rdrr.io/r/base/factor.html)
  の水準順がマシン依存にならないようにしている。**この 2
  つのキーを消さない**
- コミット前に `git status`
  で意図しないファイル（生データ・生成物）が含まれていないか確認する

## 既知の課題

コードの挙動を変える変更なので、着手前にユーザーへ確認する。

- [`jartic_type_b_loc_tiny()`](https://uribo.github.io/jarticr/reference/jartic_type_b_loc_tiny.md)
  は superseded な
  [`tidyr::separate()`](https://tidyr.tidyverse.org/reference/separate.html)
  を使っている。`separate_wider_delim()` へ移すと戻り値が `data.table`
  から `tbl_df` に変わる（破壊的変更）
- `location_name` に `→`
  が無い行の挙動が未定義（[`tidyr::separate()`](https://tidyr.tidyverse.org/reference/separate.html)
  の警告任せ）
- type
  A（旅行時間情報）には未対応。[`read_jartic_traffic()`](https://uribo.github.io/jarticr/reference/read_jartic_traffic.md)
  は type B 専用
- arrow スキーマ対応は一度入れて revert された（`dfdd6e9` →
  `8e7f3a6`）。再導入するなら `arrow` は `Suggests`
  に置き、無い環境でスキップできる形にする

## Skills（Claude Code 向け）

- `/r-modern-tidyverse`: R コード記述時
- `/r-rlang-programming`: tidyverse 関数をラップする関数を書く際
- `/commit-msg`: Conventional Commits 形式のコミットメッセージ起案

### エージェント

- `auto-committer`: 作業単位の完了時に自律的にコミット（Conventional
  Commits 準拠）
