"""Opt-in integration test against a running local API; uses synthetic data only."""
from pathlib import Path
import os
import subprocess
root = Path(__file__).resolve().parent.parent
password = (root/'.env.demo.local').read_text().strip().split('=', 1)[1]
raise SystemExit(subprocess.run(['flutter', 'test', 'test/live_api_test.dart'], cwd=root/'apps/mobile', env=dict(os.environ, YANMATA_DEMO_PASSWORD=password)).returncode)
