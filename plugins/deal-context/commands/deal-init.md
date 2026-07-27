---
description: Set up a persistent workspace for a new account/deal
argument-hint: Account name, plus optional Monday.com board/item link or CRM ID
---

# Deal Init

Set up a new persistent deal workspace for: $ARGUMENTS

## Steps

1. **Determine the account name and slug.** Parse the account/company name from the arguments (and any Monday.com link or CRM ID also supplied). Derive a filesystem-safe slug (lowercase, hyphenated). Target folder: `deals/<slug>/`.

2. **Check for an existing workspace.** If `deals/<slug>/` already exists, tell the user and stop — point them at `/deal-status <account>` or `/deal-refresh` instead of overwriting.

3. **Look up the account, if a source is available.** If Monday.com (or another connected CRM-style source) is available, search for a matching board item by name. If found, pull: current stage/status, deal value, close date, owner, key contacts, and the item/board link. If nothing is found, proceed with what the user gave you — don't block on this.

4. **Create the workspace** at `deals/<slug>/` with these files:

   - `profile.md` — company name, slug, stage, deal value, close date, owner, key contacts, and links to the Monday.com item / CRM record if known. Mark unknown fields as `TBD` rather than guessing.
   - `context.md` — a single dated entry (today) noting the workspace was initialized and summarizing whatever was found during lookup.
   - `signals.md` — a header row/table for custom signals, populated with whatever Monday.com custom columns exist for this item, or left as an empty table with a note if none were found.
   - `sources.md` — any links discovered during lookup (Monday item, CRM record).
   - `action-log.md` — empty, with a one-line header explaining its purpose (dated log of recommended next steps).

5. **Confirm to the user**: the folder created, what was pre-filled vs. left `TBD`, and that `/deal-refresh` will keep it current going forward.

Do not run a full research pass here — that's `/deal-refresh`'s job (via the `account-analyst` agent). This command only scaffolds the workspace and does a light lookup so the first refresh has something to build on.
