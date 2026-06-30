---
name: ff-deploy
description: Deploy by fast-forwarding prod to main.
---
Run these git steps in order:
1. `git checkout main`
2. `git pull`
3. `git checkout prod`
4. `git pull`
5. `git merge --ff-only main`
6. `git push`
