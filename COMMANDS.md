# Repository Command Protocol

Paste the repository URL and a command into any new chat. The agent must follow AGENTS.md and read CURRENT_STATE.md first.

## CHECK STATUS
Repository: https://github.com/chandravadiyaDeep/QR-scanner  
Command: CHECK STATUS  
Inspect branch, commits, open PRs, CI, repository tree, completed work, unfinished tasks, blockers and next recommended action. Read-only. Do not modify files.

## EXECUTE TASK
Repository: https://github.com/chandravadiyaDeep/QR-scanner  
Command: EXECUTE TASK  
Task: [describe the outcome]  
Inspect first, plan, implement, verify, update CURRENT_STATE.md, commit to a task branch and open/update a PR. Do not merge.

## PLAN TASK
Repository: https://github.com/chandravadiyaDeep/QR-scanner  
Command: PLAN TASK  
Task: [describe the outcome]  
Inspect repo and return file-level plan, dependencies, risks, acceptance criteria and verification strategy. Read-only.

## REVIEW
Repository: https://github.com/chandravadiyaDeep/QR-scanner  
Command: REVIEW  
Review current branch/PR for correctness, security, tenant isolation, concurrency, accessibility, performance, test coverage and scope alignment. Read-only unless asked.

## CONTINUE
Repository: https://github.com/chandravadiyaDeep/QR-scanner  
Command: CONTINUE  
Read CURRENT_STATE.md, verify GitHub state, select the single highest-priority unblocked next action, explain why, then execute it. Ask only for irreversible or materially ambiguous decisions. Do not merge.

## RELEASE CHECK
Repository: https://github.com/chandravadiyaDeep/QR-scanner  
Command: RELEASE CHECK  
Audit tests, security, migrations, rollback, monitoring, support runbook and pilot acceptance. Report PASS/FAIL/BLOCKED with evidence. Do not deploy.

## Interpretation and permissions
CHECK STATUS, PLAN TASK, REVIEW and RELEASE CHECK are read-only. EXECUTE TASK authorises only the described task. CONTINUE authorises the next documented priority only. No command authorises PR merge, production deployment, spending money, provider-account changes or destructive data operations.

## Required report
State task/outcome, branch/commit, files changed, verification and results, PR link/status, blockers and one next action.
