#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env
  set +a
fi
: "${DEMAND_REPO:=KingCrimsonD/ainol-octo-cli-exam-issues}"
: "${ALLOW_WRITE_REPO:=KingCrimsonD/ainol-octo-cli-exam-issues}"
: "${READONLY_REPO:=Mininglamp-OSS/octo-cli}"
export DEMAND_REPO ALLOW_WRITE_REPO READONLY_REPO
python3 scripts/scan_github_issues.py
