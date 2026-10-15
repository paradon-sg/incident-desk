# Pull request guidelines

A PR description is written for the reviewer. It answers, quickly and in this order: what does this do, why, how do I know it works, and what could go wrong?

GitHub fills new PRs with [`.github/pull_request_template.md`](../.github/pull_request_template.md). This page explains how to fill it in.

## Keep the PR focused

- **One ticket per PR.** Put `Closes #<issue>` at the top of the body so the issue closes on merge.
- **Split unrelated work** (tooling, refactors, dependency bumps, docs) into its own PR. If you must bundle it, say so in one line under What Changed so reviewers know what to skim.
- **Keep it reviewable in one sitting.** If the app-code diff runs past roughly 400 lines, split it, or explain why it can't be split and say where to start reading.
- **Name generated files** (`db/schema.rb`, lockfiles, vendored skills) so reviewers can skip them.

## Title

- Start with an imperative verb and describe the outcome: `Add email sign-in and log out`, not `Sign-in stuff` or `Fix #7`.
- Keep it under about 70 characters. The issue number goes in the body.
- Use the project's domain words (`docs/requirements.md`, `GLOSSARY.md`): ticket, customer, agent, severity, status.

## Description

Fill every section of the template. Write for a reviewer who hasn't read the ticket.

### Summary

One to three sentences on what changes for the user or the system. Someone who reads only this section should know what the merge does.

### What Changed

- Use bullets grouped by area (sign-in, models, migrations, styles). Describe behaviour first and files second.
- Name the one or two files to start reading from.
- When flow or structure changes, a small call tree, file tree or diff sketch beats a paragraph:

  ```text
  POST /session
    User.authenticate_by(email_address, password)
      ok   → start session → redirect to dashboard
      fail → 422, "Invalid email or password"
  ```

- Leave out anything the diff already shows line by line.

### Why

- Describe the problem or ticket this solves, with links to the issue, the requirement section, or the ADR.
- Record non-obvious decisions and the alternative you rejected, in a sentence each.

### Test Plan

Give reviewers evidence, and a way to check it themselves.

- **Commands and results.** Paste each command with its result line, such as `bin/ci` and any focused test runs. Leave out the full log.
- **Acceptance criteria.** Map each criterion from the issue to the test that covers it. Mark any criterion without a test as not covered.
- **Manual steps.** Number them, start from a known state (`bin/rails db:seed`), and give the expected result for each.
- **Screenshots** of before and after, for any UI change.
- **Definition of done.** List every applicable item from [definition-of-done.md](definition-of-done.md) in the collapsed block. Mark each one checked, or unchecked with the reason. Group N/A items in one line per category.

Keep a failing check in the description and give the reason, for example a failure that also happens on `main`.

### Risks / Notes

Cover whatever applies:

- Breaking changes, and who or what they break.
- Migrations: whether they are reversible, and what a rollback loses.
- New dependencies, environment variables, or config.
- Security-relevant changes: authentication, authorization, params, cookies, secrets.
- Performance: new queries, N+1 risks, or jobs.
- Known limitations, with linked follow-up issues.

If none apply, write `None.` A reviewer should never have to guess whether you considered the risks.

## Writing style

- Use short sentences, bullets, and plain words. Put the conclusion first.
- State facts. Leave out how you got there, the dead ends, and the commit history.
- Use placeholders for credentials, tokens, and customer data. Paste no real secrets, no personal data, and no full logs.
- After review changes the PR, update the description so it matches the code being merged.

## Making review easy

- Open the PR as a draft until `bin/ci` passes or you've explained each failure.
- Review your own diff on GitHub first, and comment on the lines that need context.
- Answer every review comment, either with the commit that fixes it or with a reason.
