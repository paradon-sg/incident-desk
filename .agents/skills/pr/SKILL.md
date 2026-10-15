---
name: pr
description: "Write a pull request title and body for this repo, and open or update the PR. Use when the user asks to write, open, or update a PR."
---

The rules for a good PR live in `docs/pull-requests.md`, and the body's shape lives in `.github/pull_request_template.md`. This skill is the procedure. When it and those files disagree, follow the files.

1. **Read the rules.** Read `docs/pull-requests.md`, `.github/pull_request_template.md` and `docs/definition-of-done.md`.
2. **Gather the change.** Run `git log main..HEAD`, `git diff --stat main...HEAD`, then read the diff. Fetch the originating issue and its acceptance criteria (see `docs/agents/issue-tracker.md`). You're done when every changed file is accounted for in What Changed, or named as generated or bundled.
3. **Collect evidence.** Run `bin/ci` and note each step's result. For any failure, check whether `main` fails the same way. `bin/ci` can rewrite `Gemfile.lock` platforms and create `bun.lock`: afterwards, compare `git status` with how it looked before and restore anything the run created.
4. **Write the title and body.** Fill every template section by following the guidelines. You're done when:
   - every acceptance criterion maps to a test or is marked not covered;
   - every applicable definition-of-done item is checked, or unchecked with a reason;
   - Risks / Notes lists each risk, or says `None.`
5. **Hand it over.** Save the body to a file in the scratchpad. Give the user the title, the file path, and every unchecked item.
6. **Open or update the PR** when the user has asked for it:
   - **New PR:** run `git push -u origin HEAD`, then `gh pr create --base main --title "<title>" --body-file <file>`.
   - **Existing PR:** run `gh pr edit --title "<title>" --body-file <file>`.

   Open a draft (`--draft`) while `bin/ci` has an unexplained failure.
