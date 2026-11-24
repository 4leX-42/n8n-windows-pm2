<div align="center">

# n8n on Windows · pm2

Self-hosted [n8n](https://n8n.io) as a native Node.js process under [pm2](https://pm2.keymetrics.io). No Docker, WSL2 or Hyper-V.

![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-1f1f1f?style=flat-square) ![Node.js](https://img.shields.io/badge/Node.js-18+-1f1f1f?style=flat-square&logo=nodedotjs&logoColor=white) ![pm2](https://img.shields.io/badge/pm2-1f1f1f?style=flat-square&logo=pm2&logoColor=white) ![n8n](https://img.shields.io/badge/n8n-localhost:5678-ea4b71?style=flat-square&logo=n8n&logoColor=white)

</div>

## <img src="https://api.iconify.design/lucide/download.svg?color=%238b949e" width="18" align="top"> Install

```powershell
npm install -g n8n pm2
git clone https://github.com/4leX-42/n8n-windows-pm2.git
cd n8n-windows-pm2
.\install.ps1                       # Desktop + Start Menu shortcuts
pm2 start .\ecosystem.config.js     # first run
```

## <img src="https://api.iconify.design/lucide/play.svg?color=%238b949e" width="18" align="top"> Use

| | Shortcut | Command |
|---|---|---|
| <img src="https://api.iconify.design/lucide/play.svg?color=%238b949e" width="18" align="top"> Start + open UI | **n8n** | `pm2 start ecosystem.config.js` |
| <img src="https://api.iconify.design/lucide/power.svg?color=%238b949e" width="18" align="top"> Stop everything | **Stop n8n** | `pm2 delete n8n; pm2 kill` |
| <img src="https://api.iconify.design/lucide/list.svg?color=%238b949e" width="18" align="top"> Status | — | `pm2 list` |
| <img src="https://api.iconify.design/lucide/terminal.svg?color=%238b949e" width="18" align="top"> Live logs | — | `pm2 logs n8n` |

UI on `127.0.0.1:5678`. Nothing runs at boot. Killing `node.exe` won't stop it (pm2 respawns): use **Stop n8n**.

<details>
<summary><img src="https://api.iconify.design/lucide/settings-2.svg?color=%238b949e" width="18" align="top"> <b>Configuration</b></summary>

Set in `ecosystem.config.js`:

| Var | Value | Purpose |
|---|---|---|
| `N8N_USER_FOLDER` | `./data` | workflows, sqlite DB, credentials |
| `N8N_PORT` | `5678` | UI port |
| `N8N_LISTEN_ADDRESS` | `127.0.0.1` | localhost only (`0.0.0.0` for LAN) |
| `GENERIC_TIMEZONE` / `TZ` | `Europe/Madrid` | cron/schedule timezone |
| `N8N_SECURE_COOKIE` | `false` | login over plain http |
| `N8N_DIAGNOSTICS_ENABLED` | `false` | no telemetry |

`n8nBin` and the pm2 path are resolved at runtime (`npm root -g`, `Get-Command pm2`): works on any user account. The **n8n** shortcut runs `start-n8n.ps1` through a hidden `.vbs`, waits for `/healthz` and opens the UI in an app window (Edge, Chrome or default).
</details>

<details>
<summary><img src="https://api.iconify.design/lucide/database.svg?color=%238b949e" width="18" align="top"> <b>Data and backup</b></summary>

Everything lives in `data/.n8n/` (git-ignored): `database.sqlite` (workflows, credentials, executions, users) and `config` (**encryption key**: without it, backed-up credentials are unrecoverable).

```powershell
pm2 stop n8n
Copy-Item .\data\.n8n\database.sqlite, .\data\.n8n\config <dest>
n8n export:workflow --all --output=workflows.json   # portable JSON
```
</details>

<details>
<summary><img src="https://api.iconify.design/lucide/log-in.svg?color=%238b949e" width="18" align="top"> <b>Auto-start at logon</b></summary>

```powershell
npm install -g pm2-windows-startup
pm2-startup install
pm2 start .\ecosystem.config.js
pm2 save
```

Disable: `pm2-startup uninstall`.
</details>

<sub>Python code nodes need a Python venv (not set up here). Running n8n outside a container is deprecated upstream: move to the official Docker image once virtualization is available.</sub>
