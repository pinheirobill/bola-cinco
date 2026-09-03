# IA Workflow

This repository uses Graphify as the first source of structural context for codebase work.

## Read First

- `graphify-out/graph.json`
- `graphify-out/GRAPH_REPORT.md`
- `graphify-out/graph.html`

## Default Workflow

1. Use `graphify query "<question>"` for architecture and codebase questions.
2. Use `graphify path "<A>" "<B>"` to trace relationships.
3. Use `graphify explain "<node>"` for focused concepts.
4. Read source files directly only when the graph does not answer the question cleanly.

## After Code Changes

- Run `graphify update .` after any code change.
- Run `graphify cluster-only .` when the change affects structure and you want refreshed community labels and report output.

## Notes

- Dirty `graphify-out/` files are expected after rebuilds.
- The graph is the default navigation layer for repository questions.
- If `graphify-out/wiki/index.md` exists, use it for broad navigation.
