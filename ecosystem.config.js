// pm2 process definition for a self-hosted n8n instance on Windows (no Docker).
// pm2 evaluates this file with Node, so paths are resolved dynamically per machine.

const { execSync } = require('child_process');
const path = require('path');

// Entry point of the globally installed n8n (`npm install -g n8n`).
const npmRoot = execSync('npm root -g', { encoding: 'utf8' }).trim();
const n8nBin = path.join(npmRoot, 'n8n', 'bin', 'n8n');

// User data (workflows, sqlite DB, credentials). Kept next to this file, git-ignored.
const userFolder = path.join(__dirname, 'data');

module.exports = {
  apps: [
    {
      name: 'n8n',
      script: n8nBin,
      args: 'start',
      interpreter: 'node',
      autorestart: true,
      max_restarts: 10,
      env: {
        N8N_USER_FOLDER: userFolder,
        N8N_PORT: '5678',
        N8N_HOST: 'localhost',
        N8N_PROTOCOL: 'http',
        N8N_LISTEN_ADDRESS: '127.0.0.1',   // localhost only; set 0.0.0.0 for LAN access
        GENERIC_TIMEZONE: 'Europe/Madrid',
        TZ: 'Europe/Madrid',
        N8N_SECURE_COOKIE: 'false',
        N8N_DIAGNOSTICS_ENABLED: 'false',
        N8N_PERSONALIZATION_ENABLED: 'false'
      }
    }
  ]
};
