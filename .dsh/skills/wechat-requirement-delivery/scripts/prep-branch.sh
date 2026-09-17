#!/usr/bin/env bash
# 切开发分支：从基线分支创建 feat/YYYYMMDD-<slug>
# 用法: prep-branch.sh <slug> [--base order-test] [--remote origin] [--push] [--dry-run]
set -euo pipefail

BASE="order-test"
REMOTE="origin"
PUSH=0
DRY_RUN=0
SLUG=""

die() { echo "✗ $*" >&2; exit 1; }
info() { echo "• $*"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --base)   BASE="${2:-}"; shift 2 ;;
    --remote) REMOTE="${2:-}"; shift 2 ;;
    --push)   PUSH=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help)
      sed -n '2,3p' "$0"; exit 0 ;;
    -*) die "未知参数：$1" ;;
    *) [ -z "$SLUG" ] || die "只接受一个 slug 参数" ; SLUG="$1"; shift ;;
  esac
done

[ -n "$SLUG" ] || die "缺少 slug。用法: prep-branch.sh <slug> [--base order-test] [--push]"
echo "$SLUG" | grep -Eq '^[a-z0-9][a-z0-9._-]*$' \
  || die "slug 必须是英文小写 kebab-case（例如 order-freight-date-column），当前：$SLUG"

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "当前目录不是 git 仓库"

# 工作区必须干净；但未跟踪的 .dsh/（本 Skill 自身目录）不算脏
RAW_STATUS="$(git status --porcelain)"
DIRTY="$(printf '%s\n' "$RAW_STATUS" | grep -v '^?? \.dsh/$' | grep -v '^$' || true)"
if [ -n "$DIRTY" ]; then
  echo "✗ 工作区不干净，请先处理未提交改动：" >&2
  printf '%s\n' "$DIRTY" >&2
  exit 1
fi
if [ -n "$RAW_STATUS" ] && [ -z "$DIRTY" ]; then
  info "已忽略未跟踪的 .dsh/（本 Skill 目录）"
fi

info "fetch $REMOTE ..."
git fetch "$REMOTE" --prune --quiet || die "git fetch 失败"

BASE_REF="$REMOTE/$BASE"
git rev-parse --verify --quiet "$BASE_REF" >/dev/null || die "基线分支不存在：$BASE_REF"

BASE_SHA="$(git rev-parse --short "$BASE_REF")"
BRANCH="feat/$(date +%Y%m%d)-${SLUG}"

git rev-parse --verify --quiet "refs/heads/$BRANCH" >/dev/null && die "本地已存在分支 $BRANCH，请换个 slug 或先删除它"
git ls-remote --exit-code --heads "$REMOTE" "$BRANCH" >/dev/null 2>&1 && die "远端已存在分支 $BRANCH"

if [ "$DRY_RUN" = "1" ]; then
  info "[dry-run] 将执行: git checkout -b $BRANCH $BASE_REF  (基线 $BASE_SHA)"
  [ "$PUSH" = "1" ] && info "[dry-run] 将执行: git push -u $REMOTE $BRANCH"
  exit 0
fi

git checkout -b "$BRANCH" "$BASE_REF" --quiet
info "已创建并切换到 $BRANCH（基线 $BASE_REF @ $BASE_SHA）"

if [ "$PUSH" = "1" ]; then
  git push -u "$REMOTE" "$BRANCH"
  info "已推送到 $REMOTE/$BRANCH"
fi

echo
echo "分支：$BRANCH"
echo "基线：$BASE_REF @ $BASE_SHA"
echo "下一步：在 $BRANCH 上开发并提交，然后按 SKILL 阶段 5 输出交付汇报。"
