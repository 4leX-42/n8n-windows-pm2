# n8n on Windows via pm2 (no Docker)

Self-hosted [n8n](https://n8n.io) running as a native Node.js process managed by [pm2](https://pm2.keymetrics.io) on Windows. No WSL2, no Hyper-V, no Docker — useful when virtualization is disabled or conflicts with VMware/VirtualBox.

- UI: `http://localhost:5678` (bound to `127.0.0.1`)
- Manual lifecycle: nothing runs at boot; start/stop via shortcuts
- Portable config: paths resolved at runtime, no hardcoded user paths

## Requirements

- Windows 10/11
- Node.js 18+ (`node --version`)

## Install

```powershell
npm install -g n8n pm2
git clone https://github.com/4leX-42/n8n-windows-pm2.git
cd n8n-windows-pm2
.\install.ps1          # creates Desktop + Start Menu shortcuts
```

First run:

```powershell
pm2 start .\ecosystem.config.js
```

## Usage

| Action | Shortcut | Command |
|---|---|---|
| Start + open UI | **n8n** | `pm2 start ecosystem.config.js` |
| Stop everything | **Stop n8n** | `pm2 delete n8n; pm2 kill` |
| Status | — | `pm2 list` |
| Live logs | — | `pm2 logs n8n` |

The **n8n** shortcut runs `start-n8n.ps1` (via a hidden `.vbs`): starts pm2 + n8n, waits for `/healthz`, then opens the UI in an app-style browser window (Edge → Chrome → default). **Stop n8n** runs `pm2 kill`, terminating the daemon and every child process.

> Killing `node.exe` from Task Manager won't work — pm2 respawns it. Use **Stop n8n**.

## Configuration

Environment set in `ecosystem.config.js`:

| Var | Value | Purpose |
|---|---|---|
| `N8N_USER_FOLDER` | `./data` | workflows, sqlite DB, credentials |
| `N8N_PORT` | `5678` | UI port |
| `N8N_LISTEN_ADDRESS` | `127.0.0.1` | localhost only (set `0.0.0.0` for LAN) |
| `GENERIC_TIMEZONE` / `TZ` | `Europe/Madrid` | cron/schedule timezone |
| `N8N_SECURE_COOKIE` | `false` | allow login over plain http |
| `N8N_DIAGNOSTICS_ENABLED` | `false` | disable telemetry |

`n8nBin` and the pm2 path are resolved dynamically (`npm root -g`, `Get-Command pm2`), so the repo drops in on any user account.

## Data & backup

Everything lives in `data/.n8n/` (git-ignored):

- `database.sqlite` — all workflows, credentials, executions, users
- `config` — **encryption key**; without it, backed-up credentials are unrecoverable

Backup (stop first to avoid a half-written DB):

```powershell
pm2 stop n8n
Copy-Item .\data\.n8n\database.sqlite, .\data\.n8n\config <dest>
```

Portable JSON export:

```powershell
n8n export:workflow --all --output=workflows.json
```

## Auto-start at logon (optional)

```powershell
npm install -g pm2-windows-startup
pm2-startup install
pm2 start .\ecosystem.config.js
pm2 save
```

Disable: `pm2-startup uninstall`.

## Notes

- Python code nodes require a Python venv (not set up here); the JS task runner works out of the box.
- Running n8n outside a container is deprecated upstream; migrate to the official Docker image once virtualization is available.
