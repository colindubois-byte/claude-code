---
description: Run the daily refresh across every deal and surface one ranked action plan
argument-hint: Optional - specific account name(s) to refresh instead of all
---

# Deal Refresh (coordinator)

You are acting as the coordinator for the daily deal-context refresh. Your job is to fan work out to the `account-analyst` agent, one call per account, and then aggregate every result into a single ranked action plan. Don't do the per-account research yourself — that's the subagent's job; your job is orchestration and synthesis.

Arguments (optional): $ARGUMENTS — if specific account name(s) are given, refresh only those. Otherwise refresh every known account.

## Step 1: Discover accounts

- List every folder under `deals/` that contains a `profile.md` — that's the set of known accounts.
- If Monday.com is available, also pull the list of items on the relevant board(s) and diff it against known accounts. Any board item with no matching `deals/` folder is a **new account**: don't silently create a workspace for it — call it out at the end and suggest `/deal-init "<name>"`.
- If $ARGUMENTS names specific accounts, narrow the list to those (matching by name or slug).
- If there are zero known accounts, tell the user to run `/deal-init` first and stop.

## Step 2: Fan out

For each account in scope, launch the `account-analyst` agent (via the Task tool) with the account name and its workspace path (`deals/<slug>/`). Launch these in parallel batches — a reasonable batch size is 6-8 concurrent agents — rather than one giant batch or fully serial, so this stays fast without overwhelming the session.

## Step 3: Collect

Each `account-analyst` call returns a compact structured summary (account, stage, momentum, top risk, next step, why, urgency). Collect all of them. If an agent call fails or an account errors out, note it and continue with the rest — one bad account shouldn't block the whole plan.

## Step 4: Rank and synthesize

Sort all accounts into the daily action plan using this priority order:
1. `urgency: today` first, then `this week`, then `monitor`.
2. Within the same urgency, deals with `momentum: down` or a stated top risk outrank stable ones.
3. Break remaining ties by deal value if known (`profile.md`), largest first.

## Step 5: Write and present

Write the plan to `deals/_daily-plan/<YYYY-MM-DD>.md` and overwrite `deals/_daily-plan/latest.md` with the same content, using this format per account:

```
## <rank>. <Account> — <urgency>
Next step: <the single action>
Why: <one line>
Momentum: <up|down|flat>   Stage: <stage>
```

Then present the same ranked list directly in the chat — this is the deliverable the user actually wants to see, the file is just the persistent record. Keep each entry to the essentials above; don't repeat full per-account context here (that lives in each account's `context.md`).

End with a short line noting any new/unmatched accounts found in step 1, and any accounts that failed to refresh.
