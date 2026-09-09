#!/usr/bin/env python3
"""
Script to replace local system configuration files with those from this repository.
"""
import shutil
import subprocess
from pathlib import Path

def replace(dest, src):
    if dest.exists():
        answer = input(f"Remove existing {dest}? [y/N] ").strip().lower()
        if answer != "y":
            print("Aborted.")
            exit(1)
        if dest.is_dir():
            shutil.rmtree(dest)
        else:
            dest.unlink()
    if src.is_dir():
        shutil.copytree(src, dest)
    else:
        shutil.copy(src, dest)
    print(f"Copied {src} to {dest}")


if __name__ == "__main__":
    here = Path(__file__).parent

    replace(Path.home() / ".tmux.conf", here / ".tmux.conf")
    replace(Path.home() / ".config/nvim", here / ".config/nvim")
    replace(Path.home() / ".gitconfig", here / ".gitconfig")

    ZSHRC = Path.home() / ".zshrc"
    ZSHRC_SRC = here / ".zshrc"
    ZSHRC_MARKER = "# >>> personal dotfiles repo >>>"
    ZSHRC_END = "# <<< personal dotfiles repo <<<"

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
