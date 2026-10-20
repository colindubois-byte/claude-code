---
description: Keep the "not now" pile warm without pestering — scan Gmail and Monday.com for prospects nobody has re-engaged in 3+ months, and draft a genuinely useful, non-pitchy outreach message for each
argument-hint: Optional — leave blank to auto-scan Gmail + Monday. Or name specific brands/people to limit the run to them.
---

# Nurturer

Prospects who went quiet or said "not now" are still worth something — but only if the next touch feels like it's from a friend, not a drip campaign. This command finds the people who've slipped through the cracks (no contact in either direction for 3+ months), checks what's actually going on with them now, and drafts one specific, useful message per person — and tells you honestly which ones were a polite no and should be dropped.

The bar for any message is not "on-brand" or "relevant" — it's "would this person be glad a friend sent them this, with zero commercial angle attached." A "just checking in" email teaches a prospect that going quiet doesn't work on you, and erodes the exact trust this is meant to build.

This overrides the outreach conventions in CLAUDE.md/context.md for this command specifically: no case studies, no product updates, no OPTYO pitch material, no proof points (Peak Wellness, Stick Grips, Heroboard, etc.). Those are for cold outreach. These are people who already know who Colin is — the message has to stand alone with no ask attached.

**Never send anything to a prospect.** This command only finds, researches, and drafts — the drafts go to Colin's internal "Nurture" Google Chat space, and Colin reviews and sends.

## Step 1: Build the pile automatically

Colin does not need to supply names, contacts, or follow-up dates. Build the list yourself from the sources below. If $ARGUMENTS names specific brands or people, limit the run to those (still pulling their history from the sources); otherwise scan everything.

**The re-engagement threshold is 90 days:** someone qualifies when the most recent message in *either direction* between them and Colin (or anyone @optyo.net) is more than 90 days old. Compute dates against today's date.

### 1a. Monday.com

Check whether Monday.com tools are available (search your tools for "monday"). If they are, use these boards in the **CRM** workspace (id 4773465). Colin's Monday user id is **77380175**. If an ID below stops working, find the board by name with `workspace_info` and re-check columns with `get_board_info`.

**Pipeline board — `6023894583`** (one item per deal). Use `get_board_items_page` with filters:
- `deal_owner` any_of `["person-77380175"]` (Colin's deals only)
- `deal_stage` any_of `[6, 3, 0, 4, 7]` = Nurture, Proposal, Contract Sent, New, No Show. Skip Won (1), Lost (2), Not Qualified (8).
- Columns to pull: `deal_stage`, `text0` (Last Touch — free text like "10/16", no year; assume the most recent past date), `text__1` (Notes), `deal_close_date`, `connect_boards__1` (linked Leads item — holds the contact).
- Also use each item's `updated_at`; prioritize anything in the **Nurture** group (`new_group52469__1`).

**Leads board — `6023894580`** (17k+ items — always filter, never page the whole board). Filters:
- `group` any_of `["group_mks146tv"]` (Colin's Leads), OR items linked from his Pipeline deals above (fetch those by `itemIds`).
- `lead_status` any_of `[3, 2, 7, 9, 1]` = Nurture, Response, Call, Priority, Meeting Set — people who actually engaged. Skip New Lead, BOUNCE, No, Gone, Unqualified, Complete.
- Columns to pull: `lead_company`, `text_mkxmnamw` (Primary Contact), `lead_email`, `lead_status`, `color_mkw9xc20` (Outreach Status — skip "Not Interested", "Signed!", "Deal Lost"), `last_touch`, `date_mm0qwn8j` (Follow up date — use as the stated timing), `notes`, `dropdown` (Outreach Attempts — tells you which channel was used), `link` (Instagram), `link0` (Website).

For each kept item, capture: brand, contact name + email, stage/status, follow-up date, Last Touch, notes, and the item URL for the output. Monday's Last Touch is often stale — Gmail (1b) is the source of truth for the actual last-touch date.

If Monday.com isn't available, say so in one line at the top of the output and continue with Gmail alone — don't stop.

### 1b. Gmail

Use the Gmail tools to find past prospect conversations that have gone quiet:
- Search sent mail older than 90 days but within the last 18 months, e.g. `in:sent older_than:90d newer_than:18m -to:optyo.net`. Page through results.
- For each Monday contact from 1a, also search `from:<email> OR to:<email>` (or the brand domain) to get the real last-touch date — Monday's "last updated" is not a substitute for the inbox.
- Then confirm the gap: run `(from:<email> OR to:<email>) newer_than:90d`. Any hit means they've been touched recently — exclude them.

Treat a Gmail correspondent as a prospect only when the thread is a sales conversation with a brand (outreach, discovery, proposal, follow-up). Exclude: @optyo.net and internal people, existing clients, vendors/tools/recruiters, newsletters and automated senders, and anyone who asked to be removed or gave a clear, final no.

Also check `deals/` — if a brand has a deal folder, read its `profile.md` and `action-log.md` for context and last-touch info, and exclude any deal that's actively progressing.

### 1c. Merge and dedupe

Merge Monday and Gmail results by email address and brand domain into one record per person: name, brand, email, source(s), last-touch date (latest across all sources), days since last touch, and a 1–2 sentence summary of where things left off (read the last thread with `get_thread` to get this right).

**Stated timing is optional.** If the thread or Monday item says when to reconnect ("after Q4", "once we relaunch", a follow-up date column), record it. If nothing says, leave it blank — don't ask and don't invent one.

Also read `deals/_nurture/log.md` if it exists. Anyone surfaced there within the last 6 weeks who still has no new touch goes in a short **STILL WAITING ON YOU** list (name + date first surfaced) rather than getting a fresh draft — don't regenerate the same suggestion every week.

## Step 2: Corroborate each person's story

Spend a minute per person checking what's checkable — their site, store, socials, recent press. Two things come out of this:

- **Does their stated reason (if any) hold up?** A brand that said "we're heads-down on a relaunch" should show evidence of it. Static and unchanged since you last spoke is a data point toward Step 5.
- **What's actually going on with them right now?** This is what keeps the message from being generic. Pre-launch with one SKU on a bare myshopify.com domain calls for something different than mid-way through a Klaviyo migration. Ground the idea in something real and current about *them*, not their industry in general.

Keep it quick — corroboration and a concrete hook, not a full dossier. If the pile is large (>15), prioritize the most recently active and best-fit (ICP) people for research and list the rest with a one-line "not researched this week" note.

## Step 3: Timing

Everyone in the pile has already cleared the 90-day gap, so they're eligible now. Adjust only when:
- **They stated a milestone that's still in the future** — suggest sending shortly after it has plausibly happened, not now.
- **Nothing real to send yet** — say "no useful send yet — re-check next week" rather than forcing a message. A message with nothing real behind it is exactly the "just checking in" this command exists to prevent.

Hard rule: never suggest a touch within 6 weeks of any previous touch.

## Step 4: Decide what to send — and write it

This is the part worth taking time over. For each person, come up with one specific, concrete thing — not a category. "Send a helpful resource" is not an answer; "a 4-minute Loom teardown of two competitors' launch-week email flows, tied to the fact their store is still on a bare myshopify.com domain" is.

Good sends tend to be one of:
- A short, specific teardown or observation about something adjacent to their business (a competitor's flow, a launch page, an ad) — not about them, so it doesn't feel like an audit
- A genuinely useful tool, template, or resource that fits their exact current stage
- A real introduction to someone who'd help them right now
- A sharp, specific answer to a problem they mentioned, even in passing

Always reject:
- Anything that mentions OPTYO's results, case studies, or services
- "Thought of you when I saw this [generic industry article]" / "just checking in" / "circling back"
- Anything that could be sent unmodified to five other people on the list

Write one line on why it's useful *to them*. If you can't say that honestly, the send isn't good enough yet — rethink it.

Then **write the suggested outreach message**, as Colin:
- Channel: email by default (reply on the existing thread when there is one, so they have context); LinkedIn/Instagram DM if that's where the conversation lived.
- Subject line (for email) — short, lowercase-friendly, specific to them. For thread replies, note "reply on existing thread".
- Body: 50–100 words. Open with a callback to something real from your last conversation or something new you noticed about them. Deliver the useful thing in the message itself (or say exactly what's attached/linked). No ask, no meeting request, no calendar link. A light, optional close is fine ("no need to reply — just thought it'd be useful").
- Sign off as Colin. Use [brackets] only for things Colin must fill in himself (e.g. [Loom link]).

## Step 5: Judge who to drop

Not every "not now" is real. Flag someone for **THE ONES TO DROP** when you see:

- A vague, unfalsifiable reason ("not the right time," "let's circle back") with no specific milestone
- A stated milestone that has already passed with no follow-through from them
- Evasiveness when timing was pressed on directly
- No reciprocal engagement at all since the "not now" — Colin sent the last 2+ messages with no reply
- A pattern of repeated deferrals that never resolve into a yes or a clean no

For each one, state the specific tell (not just "seems cold") and recommend stopping touches. Dropping isn't burning the bridge — it's stopping spend of attention until something changes (they reach out, a real trigger appears).

## Output

**Deliver to the Google Chat space "Nurture"** — not a markdown file. Posting into Colin's own internal space is the delivery step this command exists for; it is not sending anything to a prospect.

1. Write the messages as a UTF-8 JSON array of strings to a temp file (scratchpad, not the repo). Use Google Chat formatting: `*bold*`, `_italic_`, plain line breaks, no markdown tables or `#` headers. One array entry per Chat message, in this order:
   - **Summary:** `*Nurturer — YYYY-MM-DD*`, the SOURCES line, then one line per person in the pile (`• Brand — Name (N days) — send when`), the drop count, and the closing cadence reminder.
   - **One message per person in the pile:** `*Name — Brand*`, last touch and where it left off, `What I send:` and `Why it's useful to them:` lines, `Channel:` and `Subject:` lines, then the full message body (copy-pasteable as-is), and the Monday item link.
   - **One message for STILL WAITING ON YOU** (only if anyone is in it).
   - **One message for THE ONES TO DROP** (name, the specific tell, the recommendation).
2. Post them as one thread: `powershell -NoProfile -ExecutionPolicy Bypass -File .claude/scripts/post-to-chat.ps1 -MessagesFile <temp.json> -ThreadKey nurture-YYYY-MM-DD`.
3. If the webhook isn't configured (`.claude/nurture-webhook.local` missing) or the post fails, fall back to writing the same content to `deals/_nurture/YYYY-MM-DD.md` and say so plainly — never drop the drafts silently.

Then append one line per surfaced person to `deals/_nurture/log.md` (`YYYY-MM-DD | name | brand | email | status: drafted / dropped / waiting`) — create the file with that header if it doesn't exist. The log stays a local file because Step 1c reads it to avoid resurfacing the same people.

Content, in this order (shown here in report form — translate into the Chat messages above):

**SOURCES** — one line: what was scanned (Monday boards, Gmail date range), how many candidates found, how many excluded and why (recent touch, client, etc.).

**THE PILE**

| Who | Brand | Last touch (days ago) | Stated timing | Where it left off | Send when | What I send | Why it's useful to THEM |
|---|---|---|---|---|---|---|---|

One row per person staying in the pile, sorted by send-when date.

**SUGGESTED MESSAGES**

For each person in the pile, in the same order:

> ### Name — Brand
> **Channel:** email (reply on thread "…") / new email to x@brand.com / LinkedIn DM
> **Subject:** …
>
> message body
>
> Colin

**STILL WAITING ON YOU** — people surfaced in the last 6 weeks with no touch since (omit the section if empty).

**THE ONES TO DROP** — name, the specific tell, recommendation. If nobody meets the bar, say so and briefly note what kept each person on the keep-warm side.

Close with a one-line reminder: max one touch per person per six weeks, and nothing gets sent until Colin reviews it.
