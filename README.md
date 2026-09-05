# AINOL octo-cli PM Agent Exam Issues

This repository is the **formal exam demand pool and PM workflow workspace** for the AINOL Agent practical exam.

Target product:

https://github.com/Mininglamp-OSS/octo-cli

Demand pool repository:

https://github.com/KingCrimsonD/ainol-octo-cli-exam-issues

Sandbox / rehearsal repository:

https://github.com/KingCrimsonD/octo-cli-pm-agent-lab

## Formal Exam Boundaries

- `Mininglamp-OSS/octo-cli` is **read-only**. Agents must not push commits, create branches, open PRs, create/comment/close issues, or modify labels/releases/workflows there.
- This repository is the **only allowed writable GitHub repository** for formal exam demand-pool work.
- Rehearsal data from `octo-cli-pm-agent-lab` is not part of the formal exam flow and must not be scanned or reported in exam mode.
- Product answers must cite verifiable source paths and line numbers: `来源: <相对路径>#L<起>-L<止>`.
- Secrets must never be written to issues, PRDs, logs, git history, or chat messages.
- Cron runs automatically and records logs.
- Group reports are sent only when there is actual output.

## Required Runtime Configuration

```env
MODE=exam
DEMAND_REPO=KingCrimsonD/ainol-octo-cli-exam-issues
ALLOW_WRITE_REPO=KingCrimsonD/ainol-octo-cli-exam-issues
TARGET_REPO=Mininglamp-OSS/octo-cli
READONLY_REPO=Mininglamp-OSS/octo-cli
```

## Agent Split

- **Agent A / 卡兹**: group entry, product Q&A, feedback triage, issue/label/comment updates, cron scanning and group reporting.
- **Agent B / 瓦姆乌**: PRD drafting/review, What-only PRD gate, Evidence Gate, review result and label-flow recommendations.

## Exam Readiness Checks

Before the formal exam, verify:

1. This repository is public.
2. `DEMAND_REPO` and `ALLOW_WRITE_REPO` point to this repository.
3. Cron scans this repository, not the sandbox repository.
4. Target repository remains read-only.
5. `.env` is not tracked by git.
6. Citation and dry-run checks pass.
7. No rehearsal issues are present in this formal repository.
