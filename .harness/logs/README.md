# Agent Logs

Use **one log file per task** instead of appending everything into a single file.

## File naming

- `.harness/logs/YYYY-MM-DD/<TASK_SLUG>.md`
- Example: `.harness/logs/2026-05-03/home-redesign-slice2.md`

## Why

- Keeps startup context small
- Makes retrieval targeted
- Avoids scanning large append-only history files

## Rules

- Create a new file when a task starts.
- Append updates only to that task file.
- Do not edit prior task files except to fix factual mistakes, and note correction reason.
- Keep each log under ~150 lines; if exceeded, start `-part2.md`.

## Legacy

- Historical aggregate log remains at `.harness/logs/archive/agent.log.md` for reference.
- New tasks must not write to the legacy aggregate file.
