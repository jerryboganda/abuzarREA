# Gemini CLI context: Abuzar research project

This file is loaded automatically by Gemini CLI when it starts in this folder.
Follow the imported project rules.

@./CLAUDE.md
@./AGENTS.md

- **Never push this repository and never change its git index**: it is public and
  its index holds vendor binaries (`Application/`, `FiscalizationApp/`).
- The code rebuild is the separate repository in `rebuild/`, with its own
  `GEMINI.md`. Start Gemini CLI inside `rebuild\` to work on the rebuild.
- Do not send credentials, customer data, backups, vendor binaries or
  unredacted research files to a model or external service. `.geminiignore`
  and `.gitignore` are not security boundaries for shell commands or every tool.
