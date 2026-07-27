---
description: Show the current action plan for one account or all accounts, without running a refresh
argument-hint: Optional - account name; omit for all accounts
---

# Deal Status

Fast, read-only view into the deal-context workspace. This does **not** call the `account-analyst` agent or touch any external source — it just reads what's already on disk. Use `/deal-refresh` when the data needs to be brought current.

Arguments (optional): $ARGUMENTS — an account name to scope to, otherwise show everything.

## If a specific account is given

- Read `deals/<slug>/profile.md`, the most recent entry in `context.md`, the current `signals.md`, and the most recent entry in `action-log.md`.
- Present: current stage, the last recommended next step and whether it appears to have been acted on (compare against newer `context.md` entries if any), current signals with their last-known direction, and any open risk.
- If the account has no workspace, say so and suggest `/deal-init "<name>"`.

## If no account is given

- Read `deals/_daily-plan/latest.md` if it exists and present it as-is (it's already the ranked summary).
- If it doesn't exist, list every account under `deals/` with just its stage and the urgency from its last `action-log.md` entry, and tell the user to run `/deal-refresh` to generate a proper ranked plan.
- Always note the date of the data being shown (from the plan file or the latest `context.md`/`action-log.md` entries) so it's clear how stale it is.
