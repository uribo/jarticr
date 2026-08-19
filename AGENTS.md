# Codex project instructions

Read and follow `CLAUDE.md` as the primary source of project knowledge and conventions. The rules below add Codex-specific security constraints.

## Credential handling

- Never read, edit, print, search, summarize, or otherwise expose the project credential file, `.env`, credential JSON files, private keys, or files whose purpose is to store secrets.
- Do not bypass `.codex/config.toml` environment filtering or override `R_ENVIRON_USER` unless the user explicitly approves access for a specific task.
- If a task needs authenticated API access, explain which credential or environment variable is required and obtain approval before enabling it. Never include credential values in prompts, logs, command output, or commits.

## Generated files

- `NAMESPACE` and `man/*.Rd` are roxygen2 output. Edit the roxygen comments in `R/` and regenerate; never hand-edit the generated files.
- `inst/dummy/type_b.csv` holds CP932 bytes. Regenerate it with `data-raw/dummy_typeB.R`; never rewrite it as UTF-8.
