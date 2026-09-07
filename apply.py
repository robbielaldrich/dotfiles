#!/usr/bin/env python3
"""
Script to replace local system configuration files with those from this repository.
"""
import shutil
import subprocess
from pathlib import Path

TMUX_CONF = Path.home() / ".tmux.conf"
NVIM_CONFIG = Path.home() / ".config/nvim"
ZSHRC = Path.home() / ".zshrc"

here = Path(__file__).parent
ZSHRC_SRC = here / ".zshrc"

ZSHRC_MARKER = "# >>> personal dotfiles repo >>>"
ZSHRC_END = "# <<< personal dotfiles repo <<<"

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

if ZSHRC_SRC.exists():
    block = ZSHRC_SRC.read_text().strip()
    existing = ZSHRC.read_text() if ZSHRC.exists() else ""
    if ZSHRC_MARKER in existing:
        print(f"Skipped {ZSHRC} (dotfiles block already present)")
    else:
        with ZSHRC.open("a") as f:
            if existing and not existing.endswith("\n"):
                f.write("\n")
            f.write(
                f"\n{ZSHRC_MARKER}\n"
                "# Managed by ~/personal/dotfiles/export.py. Edit there, not here.\n"
                f"{block}\n"
                f"{ZSHRC_END}\n"
            )
        print(f"Appended dotfiles block to {ZSHRC}")

