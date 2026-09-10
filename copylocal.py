#!/usr/bin/env python3
"""
Script to copy local configuration into this repo for committing changes.
"""

import shutil
from pathlib import Path


def copy_local(src, dest):
    if dest.exists():
        if dest.is_dir():
            shutil.rmtree(dest)
        else:
            dest.unlink()
    if src.is_dir():
        shutil.copytree(src, dest)
    else:
        shutil.copy2(src, dest)
    print(f"Copied {src} to {dest}")


if __name__ == "__main__":
    here = Path(__file__).parent

    copy_local(Path.home() / ".tmux.conf", here / ".tmux.conf")
    copy_local(Path.home() / ".config/nvim", here / ".config/nvim")
