"""Background token refresh loop — run with pythonw (no console window).
Refreshes every 20 minutes. If machine woke from long sleep, refreshes immediately.
"""
import time
import subprocess
import sys
import os

SCRIPT   = os.path.join(os.path.dirname(os.path.abspath(__file__)), "refresh_token.py")
INTERVAL = 20 * 60  # seconds

def refresh():
    subprocess.run([sys.executable, SCRIPT], capture_output=True)

refresh()  # immediate refresh on start
while True:
    t0 = time.time()
    time.sleep(INTERVAL)
    elapsed = time.time() - t0
    # If we slept much longer than expected (machine woke from sleep), refresh now
    if elapsed > INTERVAL * 1.5:
        refresh()
    refresh()
