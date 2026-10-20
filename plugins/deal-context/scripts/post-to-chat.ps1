# Posts a list of messages to a Google Chat space via its incoming webhook.
# Usage: powershell -File .claude/scripts/post-to-chat.ps1 -MessagesFile <path.json> -ThreadKey <key>
#   MessagesFile: UTF-8 JSON array of strings, each one Chat message (Chat formatting: *bold*, _italic_).
#   ThreadKey:    groups all messages from one run into a single thread, e.g. nurture-2026-10-19.
# The webhook URL is read from .claude/nurture-webhook.local (gitignored — it contains a key).
param(
    [Parameter(Mandatory = $true)][string]$MessagesFile,
    [Parameter(Mandatory = $true)][string]$ThreadKey
)
$ErrorActionPreference = 'Stop'

$urlFile = Join-Path $PSScriptRoot '..\nurture-webhook.local'
if (-not (Test-Path $urlFile)) { throw "No webhook configured: $urlFile is missing." }
$webhook = (Get-Content $urlFile -Raw).Trim()

$messages = Get-Content $MessagesFile -Raw -Encoding UTF8 | ConvertFrom-Json
$url = "$webhook&threadKey=$([uri]::EscapeDataString($ThreadKey))&messageReplyOption=REPLY_MESSAGE_FALLBACK_TO_NEW_THREAD"

$i = 0
foreach ($text in $messages) {
    $i++
    $body = @{ text = [string]$text } | ConvertTo-Json -Compress
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    Invoke-RestMethod -Method Post -Uri $url -ContentType 'application/json; charset=UTF-8' -Body $bytes | Out-Null
    Write-Output "posted $i/$($messages.Count)"
    Start-Sleep -Milliseconds 1100   # webhooks are limited to ~1 message/sec per space
}
