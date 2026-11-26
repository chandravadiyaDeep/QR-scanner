# Agent Operating Instructions

These rules apply to every AI agent, coding agent, contributor and future chat.

## Mandatory startup
1. Read CURRENT_STATE.md.
2. Read this file and COMMANDS.md.
3. Inspect live branch, recent commits, open PRs, changed files and CI.
4. Inspect the repository tree and relevant source files.
5. Identify task scope, dependencies, risks and acceptance criteria.

Never assume prior chat status is current; verify GitHub.

## Product boundary
Exactly two target verticals: restaurants and cinemas. No third vertical or unrelated marketplace. Build domain-specific products on shared infrastructure. Keep models, state machines, vocabulary and permissions distinct where semantics differ.

The outcome is lower avoidable operating cost and better guest throughput/service, not merely digitised paper workflows.

## Execution protocol
When given a repository URL and command:
1. Parse the requested outcome.
2. Inspect repo and current state.
3. Prepare a concise plan with files and risks.
4. Execute through GitHub where possible.
5. Run/inspect relevant checks and distinguish verified from unrun.
6. Update docs, especially CURRENT_STATE.md.
7. Commit to a task-specific branch unless an existing branch is explicitly required.
8. Open/update a PR when appropriate. Never merge without explicit permission.
9. Report branch, commit, files, verification, PR and next action.

For clear, reversible tasks, do not ask unnecessary questions. Ask only for irreversible actions, material scope ambiguity, unavailable credentials or decisions with materially different outcomes.

## Quality and safety
- Never fabricate tests, CI, screenshots, deployments, APKs, savings or user validation.
- Never overwrite user work or force-push without explicit authorisation.
- Do not merge PRs or deploy to production unless explicitly instructed.
- Never commit secrets, keys, tokens, passwords or production data.
- Review security, dependency and compatibility implications.
- Use migrations, not ad hoc production DB edits.
- Include loading, empty, error, retry, offline and success states.
- Use idempotency and concurrency controls for transactional flows.
- Persist authoritative state; realtime events are notifications.

## Architecture rules
Keep restaurant, cinema, identity and platform boundaries explicit. Do not reuse restaurant order/table models for cinema booking/seat inventory. Enforce tenant isolation and roles server-side. Payment providers handle card data; never store raw card details. Core guest journeys should not require app installation. Do not author schema migrations before domain model, invariants, RLS and rollback plan are approved.

## Definition of done
Requested behaviour implemented; acceptance criteria met; relevant tests pass or gaps disclosed; security, permissions, failure paths and accessibility considered; docs and CURRENT_STATE.md updated; exact branch/commit/PR and verification reported.

## Chat portability
A new chat must continue from repository documents alone. Track decisions, status, risks, next task and evidence in Markdown. Never rely on private chat history as the sole source of truth.
