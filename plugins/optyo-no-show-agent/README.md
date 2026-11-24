# optyo-no-show-agent

OPTYO's No-Show agent, packaged as a Claude Code plugin skill.

Finds new first discovery calls in monday.com and Google Calendar, picks the right pre-call email sequence based on how far out the call is, matches the prospect to OPTYO case studies, and writes every email as an **unsent** Gmail draft in the call leader's inbox, then alerts the right people to review and send.

## Requirements

monday.com, Gmail and Google Calendar connectors, connected as the person the emails come from.

## Contents

- `skills/optyo-no-show-agent/SKILL.md` — the agent's instructions
- `skills/optyo-no-show-agent/references/monday-setup.md` — board and column ids
- `skills/optyo-no-show-agent/references/email-templates.md` — approved email templates
- `skills/optyo-no-show-agent/references/case-studies.md` — case study library and matching rules
