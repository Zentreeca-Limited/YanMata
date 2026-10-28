"""Opt-in integration test against a configured API; uses synthetic data only."""
from pathlib import Path
import os
import subprocess
root = Path(__file__).resolve().parent.parent
password = (root/'.env.demo.local').read_text().strip().split('=', 1)[1]
base_url = os.environ.get('YANMATA_API_BASE_URL', 'http://127.0.0.1:8091/api/v1')
command = [
    'flutter',
    'test',
    'test/live_api_test.dart',
    f'--dart-define=API_BASE_URL={base_url}',
]
raise SystemExit(
    subprocess.run(
        command,
        cwd=root/'apps/mobile',
        env=dict(os.environ, YANMATA_DEMO_PASSWORD=password),
    ).returncode
)
