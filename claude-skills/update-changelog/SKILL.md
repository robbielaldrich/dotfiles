---
name: update-changelog
description: Update changelog and commit.
---

You are finishing up a new feature and need to update the changelog of the app.
Look for whether the GitHub pull request number is supposed to be included; if so, find the relevant pull request and add it.
Changelog file is typically at CHANGELOG.md.
Increment the version with proper semantic verisoning, though typically breaking changes we have change only the minor version, not the major version. We basically never change the major version.
If there are no other changes in the current diff besides your changelog change, make the commit message just the new version number.
Group all changes within the same package into one line of the changelog.
Git push after commiting, if you're not on `main` branch.
