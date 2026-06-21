#!/usr/bin/env python3
import shutil
from pathlib import Path

TMUX_CONF = Path.home() / ".tmux.conf"
NVIM_CONFIG = Path.home() / ".config/nvim"

here = Path(__file__).parent

try:
    shutil.copy2(TMUX_CONF, here / ".tmux.conf")
    print(f"Copied {TMUX_CONF}")
except shutil.SameFileError:
    print(f"Skipped {TMUX_CONF} (already the same file)")

dest = here / ".config/nvim"
if dest.exists():
    shutil.rmtree(dest)
shutil.copytree(NVIM_CONFIG, dest)
print(f"Copied {NVIM_CONFIG}")
