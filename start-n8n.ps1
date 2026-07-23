$ErrorActionPreference = 'SilentlyContinue'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$pm2  = (Get-Command pm2 -ErrorAction SilentlyContinue).Source
if (-not $pm2) { $pm2 = 'pm2' }

# Start pm2 (self-spawns if dead) + n8n
& $pm2 start (Join-Path $here 'ecosystem.config.js') | Out-Null

# Wait until n8n answers healthy (~120s max)
$url = 'http://localhost:5678'
for ($i = 0; $i -lt 60; $i++) {
  try {
    Invoke-WebRequest "$url/healthz" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop | Out-Null
    break
  } catch { Start-Sleep -Seconds 2 }
}

# Open the UI in an app-style window (Edge > Chrome > default browser)
$edge   = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
$edge2  = "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
$chrome = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
if     (Test-Path $edge)   { Start-Process $edge   -ArgumentList "--app=$url" }
elseif (Test-Path $edge2)  { Start-Process $edge2  -ArgumentList "--app=$url" }
elseif (Test-Path $chrome) { Start-Process $chrome -ArgumentList "--app=$url" }
else                       { Start-Process $url }
