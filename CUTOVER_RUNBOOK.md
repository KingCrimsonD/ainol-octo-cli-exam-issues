# Formal Exam Cutover Runbook

This document prevents repository confusion when switching from rehearsal to formal exam mode.

## 1. Repository Roles

| Role | Repository |
|---|---|
| Formal demand pool / writable exam repository | `KingCrimsonD/ainol-octo-cli-exam-issues` |
| Target product source repository / read-only | `Mininglamp-OSS/octo-cli` |
| Rehearsal / sandbox repository | `KingCrimsonD/octo-cli-pm-agent-lab` |

Formal exam mode must only scan and write the formal demand pool. The sandbox repository must not be scanned or reported.

## 2. Required Environment

Set these values for both agents and cron runtime:

```env
MODE=exam
DEMAND_REPO=KingCrimsonD/ainol-octo-cli-exam-issues
GITHUB_REPO=KingCrimsonD/ainol-octo-cli-exam-issues
ALLOW_WRITE_REPO=KingCrimsonD/ainol-octo-cli-exam-issues
TARGET_REPO=Mininglamp-OSS/octo-cli
READONLY_REPO=Mininglamp-OSS/octo-cli
```

Secrets must be provided through the secure secret channel only. Never paste tokens into group chat, issues, PRDs, logs, or git.

## 3. Agent Responsibility Split

### Agent A / 卡兹

- Group entry point
- Product Q&A with verifiable citations
- Feedback triage
- Demand-pool issue creation / comments / labels
- Cron scanning and group reporting

### Agent B / 瓦姆乌

- PRD drafting and review
- What-only PRD gate
- Evidence Gate
- Review result and label-flow recommendations

## 4. Cron Cutover

Cron must point to the formal repository, not the sandbox repository.

Recommended crontab shape:

```cron
*/10 * * * * cd /path/to/ainol-octo-cli-exam-issues && MODE=exam DEMAND_REPO=KingCrimsonD/ainol-octo-cli-exam-issues ALLOW_WRITE_REPO=KingCrimsonD/ainol-octo-cli-exam-issues READONLY_REPO=Mininglamp-OSS/octo-cli ./scripts/cron_job.sh >> logs/cron_stdout.log 2>&1
```

After changing cron:

1. Reset baseline state for the formal repository.
2. Run one baseline scan.
3. Confirm `issues_seen=0` if the formal repository has no issues.
4. Confirm the sandbox repository is not referenced by cron.

## 5. Anti-Confusion Guards

The scripts include allowlist protection:

- `scripts/scan_github_issues.py` blocks scanning if `DEMAND_REPO` is not the allowlisted formal repository.
- `scripts/sync_labels.py` refuses to sync labels for non-allowed repositories.
- `Mininglamp-OSS/octo-cli` is treated as read-only and must never receive writes.

## 6. Minimum Verification Before Formal Exam

Run:

```bash
python3 -m py_compile scripts/*.py
python3 scripts/verify_citations.py
python3 scripts/dry_run_exam_check.py
GITHUB_TOKEN=<secure-token> DEMAND_REPO=KingCrimsonD/ainol-octo-cli-exam-issues ALLOW_WRITE_REPO=KingCrimsonD/ainol-octo-cli-exam-issues READONLY_REPO=Mininglamp-OSS/octo-cli python3 scripts/scan_github_issues.py
```

Expected:

- Python compile passes
- Citation check: all citations valid
- Dry-run: success
- Formal repo scan succeeds
- No token is printed

Guard test:

```bash
GITHUB_TOKEN=<secure-token> DEMAND_REPO=Mininglamp-OSS/octo-cli ALLOW_WRITE_REPO=KingCrimsonD/ainol-octo-cli-exam-issues READONLY_REPO=Mininglamp-OSS/octo-cli python3 scripts/scan_github_issues.py
```

Expected:

- Blocked: `DEMAND_REPO is not the formal demand-pool allowlist`

## 7. Final Self-Declaration Prompt

Before the formal exam, ask each agent:

```text
请说明当前正式考试配置：
1. MODE 是什么？
2. DEMAND_REPO 是哪个？
3. ALLOW_WRITE_REPO 是哪个？
4. TARGET_REPO / READONLY_REPO 是哪个？
5. cron 扫描哪个仓库？
6. sandbox 仓库是否会被扫描或写入？
7. 遇到目标仓库写入请求时如何处理？
```

Correct answers must include:

- `MODE=exam`
- `DEMAND_REPO=KingCrimsonD/ainol-octo-cli-exam-issues`
- `ALLOW_WRITE_REPO=KingCrimsonD/ainol-octo-cli-exam-issues`
- `TARGET_REPO=Mininglamp-OSS/octo-cli`
- `READONLY_REPO=Mininglamp-OSS/octo-cli`
- Sandbox repository is ignored in formal mode
- Target repository is read-only
