# monday.com setup (OPTYO CRM workspace)

Read-only for this agent, apart from posting notifications. Never change board structure, columns or item values.

## Activity Metrics board (id 6023894595)

Every activity logged through Emails & Activities. This is where new meetings show up.

| Column | Id | Use |
|---|---|---|
| Activity (name) | name | Usually "[Brand] - Upcoming Meeting" |
| Owner | activity_owner | Who logged it (the booker) |
| Lead | activity_item | Links to the Pipeline item (board 6023894583), sometimes to Leads |
| Start time | activity_start_time | Call date and time |
| Activity Type | activity_type | Only "Upcoming Meeting" starts a sequence. "Meeting" (Done) means a call already happened |
| Status | activity_status | Open or Done |
| Creation log | created_at on the item | Booking date, for counting business days |

## Pipeline board (id 6023894583)

| Column | Id | Use |
|---|---|---|
| Owner | deal_owner | Usually the call leader. Use to double-check routing |
| Lead link | connect_boards__1 | Links to the Leads item (board 6023894580) |
| Team member | multiple_person_mm82jhzr | Usually the booker |

## Leads board (id 6023894580)

| Column | Id | Use |
|---|---|---|
| Company | lead_company | Brand name |
| Email | lead_email | Often a general inbox. Prefer the calendar invite attendee |
| Primary Contact | text_mkxmnamw | Contact name when filled in (often blank) |
| Industry/Category | touches | Free text, messy. A hint only |
| Website | link0 | Read it when the category is blank or unclear |
| Instagram | link | For the booker's DM |
| Outreach Attempts | dropdown | How they were contacted (Instagram DM, Email 1, website submission) |

The LinkedIn field also exists on Leads ("LinkedIn?"). Look it up by title if needed.
