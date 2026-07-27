# Deal Context Plugin

Keeps one persistent, aggregated workspace per account — CRM data, internal and customer conversations, web research, and Monday.com custom signals — and turns it into a single daily action plan: the one next step most likely to move each deal forward.

## Overview

Deal context is usually scattered: notes in the CRM, threads in email, signals in a Monday.com board, one-off web research nobody wrote down. This plugin gives every account a folder that accumulates that context over time, a subagent (`account-analyst`) whose whole job is keeping one account's folder current, and a coordinator flow (`/deal-refresh`) that runs every account's refresh and rolls the results up into one ranked list.

## How it fits together

- **`deals/<account-slug>/`** — the persistent workspace for one account. Created by `/deal-init`, kept current by `/deal-refresh`. Nothing here is deleted on refresh — `context.md` and `action-log.md` are append-only logs, so the account's history stays intact.
- **`account-analyst` (agent)** — the per-account subagent. Given one account, it reads the existing workspace, pulls whatever primary sources are actually connected (Monday.com, email, calendar, docs, enrichment tools, web search), reconciles what changed, updates the workspace files, and returns one recommended next step.
- **`/deal-refresh` (command, the coordinator)** — discovers every known account, launches `account-analyst` once per account in parallel batches, collects each one's recommendation, ranks them by urgency/momentum/value, writes the ranked plan to `deals/_daily-plan/`, and prints it.
- **`/deal-init`** — scaffolds a new account's workspace (with a light Monday.com lookup if available) so the first refresh has something to build on.
- **`/deal-status`** — a fast, read-only look at the latest plan or a single account's state, with no external calls.

## Workspace layout

```
deals/
  acme-corp/
    profile.md       # stage, value, close date, owner, contacts, record links
    context.md        # append-only dated log of what changed each refresh
    signals.md         # current Monday.com custom signals + direction of change
    sources.md          # links: Monday item, CRM record, key docs, threads
    action-log.md        # append-only dated log of recommended next steps
  other-account/
    ...
  _daily-plan/
    2026-07-27.md      # that day's ranked action plan
    latest.md          # always the most recent plan
```

## Usage

**Set up a new account:**
```bash
/deal-init "Acme Corp" https://your-org.monday.com/boards/123/pulses/456
```

**Run the daily refresh (all accounts):**
```bash
/deal-refresh
```

**Refresh just one or two accounts:**
```bash
/deal-refresh "Acme Corp"
```

**Check the current plan without refreshing anything:**
```bash
/deal-status
/deal-status "Acme Corp"
```

## Primary sources

`account-analyst` uses whatever is actually connected in your session and skips the rest — it doesn't hard-fail on a missing connector:

- **Monday.com** — board item stage/status, custom signal columns, updates, timeline. The primary source for structured deal data and custom signals.
- **Email** (e.g. Gmail) — customer and internal conversation threads.
- **Calendar** — recent and upcoming meetings.
- **Call notes/recordings** (e.g. Pocket) — transcripts, summaries, and action items from calls with the account.
- **Docs/Drive** — proposals, contracts, notes tied to the account.
- **Enrichment/research tools** (e.g. Clay) — company/contact data points.
- **Web search** — public signals: news, funding, leadership changes.

## Automating the daily refresh

This plugin doesn't schedule itself — `/deal-refresh` runs when invoked. If you're running Claude Code somewhere that supports scheduled sessions (for example, a Routine on Claude Code on the web), point it at this session with a prompt of `/deal-refresh` on whatever cadence you want the plan regenerated (typically once each morning).

## Design notes

- **One next step per deal, not a list.** The point of `/deal-refresh` is to cut through noise — each account gets exactly one recommended action, ranked against every other account's.
- **Append-only history.** `context.md` and `action-log.md` never get rewritten, only appended to, so you can see how a deal's story and the advice given about it evolved.
- **The coordinator doesn't research.** `/deal-refresh` only discovers accounts, fans out, and ranks — all primary-source review happens inside `account-analyst`, once per account, so it can run in parallel and stay focused.

## Requirements

- Claude Code installed.
- At least one account initialized via `/deal-init` before `/deal-refresh` has anything to do.
- Optional but recommended: a Monday.com connection for custom signals and structured deal data, plus whatever email/calendar/docs connectors you want folded into `context.md`.

## Author

Colin Dubois (colin.dubois@optyo.net)

## Version

1.0.0
