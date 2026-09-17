#!/usr/bin/env bash
# 用户确认后，把环境分支 fast-forward 推送到远端。永不 force。
# 用法: push-envs.sh [--branches order-stage,order-pre,order-test] [--remote origin] [--dry-run]
set -euo pipefail

BRANCHES="order-stage,order-pre,order-test"
REMOTE="origin"
DRY_RUN=0

die() { echo "✗ $*" >&2; exit 1; }
info() { echo "• $*"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --branches) BRANCHES="${2:-}"; shift 2 ;;
    --remote)   REMOTE="${2:-}"; shift 2 ;;
    --dry-run)  DRY_RUN=1; shift ;;
    -h|--help)  sed -n '2,3p' "$0"; exit 0 ;;
    *) die "未知参数：$1" ;;
  esac
done

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "当前目录不是 git 仓库"
git fetch "$REMOTE" --prune --quiet || die "git fetch 失败"

IFS=',' read -r -a TARGETS <<< "$BRANCHES"

# 先全量校验，避免推一半失败
for t in "${TARGETS[@]}"; do
  git rev-parse --verify --quiet "refs/heads/$t" >/dev/null || die "本地不存在分支 $t"
  git rev-parse --verify --quiet "$REMOTE/$t" >/dev/null || die "远端不存在分支 $REMOTE/$t"
  git merge-base --is-ancestor "$REMOTE/$t" "refs/heads/$t" \
    || die "$t 不是 fast-forward（远端有本地没有的提交）。拒绝 force push，请人工处理。"
  if [ "$(git rev-parse "$REMOTE/$t")" = "$(git rev-parse "refs/heads/$t")" ]; then
    info "$t 已是最新（$(git rev-parse --short "refs/heads/$t")），跳过"
    continue
  fi
  info "$t 待推送："
  git log --oneline "$REMOTE/$t..refs/heads/$t" | sed 's/^/    /'
done

if [ "$DRY_RUN" = "1" ]; then
  echo "• [dry-run] 校验通过，未执行 push"
  exit 0
fi

for t in "${TARGETS[@]}"; do
  before="$(git rev-parse --short "$REMOTE/$t")"
  if [ "$(git rev-parse "$REMOTE/$t")" = "$(git rev-parse "refs/heads/$t")" ]; then
    continue
  fi
  git push "$REMOTE" "refs/heads/$t:refs/heads/$t" || die "推送 $t 失败"
  after="$(git rev-parse --short "refs/heads/$t")"
  echo "✓ $t: $before → $after"
done

echo
echo "== 推送完成 =="
for t in "${TARGETS[@]}"; do
  echo "  $t → $(git rev-parse --short "refs/heads/$t")"
done
