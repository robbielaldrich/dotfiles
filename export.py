#!/usr/bin/env python3
import shutil
from pathlib import Path

TMUX_CONF = Path.home() / ".tmux.conf"
NVIM_CONFIG = Path.home() / ".config/nvim"

here = Path(__file__).parent

try:
    shutil.copy2(here / ".tmux.conf", TMUX_CONF)
    print(f"Copied to {TMUX_CONF}")
except shutil.SameFileError:
    print(f"Skipped {TMUX_CONF} (already the same file)")

if NVIM_CONFIG.exists():
    answer = input(f"Remove existing {NVIM_CONFIG}? [y/N] ").strip().lower()
    if answer != "y":
        print("Aborted.")
        exit(1)
    shutil.rmtree(NVIM_CONFIG)
shutil.copytree(here / ".config/nvim", NVIM_CONFIG)
print(f"Copied to {NVIM_CONFIG}")
