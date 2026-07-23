$ErrorActionPreference = 'SilentlyContinue'
$pm2 = (Get-Command pm2 -ErrorAction SilentlyContinue).Source
if (-not $pm2) { $pm2 = 'pm2' }

# Stop n8n and kill the pm2 daemon entirely (nothing left running)
& $pm2 delete n8n | Out-Null
& $pm2 kill | Out-Null
