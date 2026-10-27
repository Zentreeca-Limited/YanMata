"""Seed only the local demo, without printing or committing its password."""
from pathlib import Path
import os
import secrets
import subprocess
root = Path(__file__).resolve().parent.parent
credentials = root / '.env.demo.local'
password = credentials.read_text().strip().split('=', 1)[1] if credentials.exists() else secrets.token_urlsafe(24)
result = subprocess.run(['php', 'artisan', 'db:seed', '--class=DemoSeeder', '--no-interaction'], cwd=root/'apps/api', env=dict(os.environ, YANMATA_DEMO_PASSWORD=password))
if result.returncode:
    raise SystemExit(result.returncode)
credentials.write_text('YANMATA_DEMO_PASSWORD=' + password + '\n')
credentials.chmod(0o600)
print('Local demo seeded. Credentials are in ignored .env.demo.local. Accounts: author/reviewer/publisher/member@demo.yanmata.test')
