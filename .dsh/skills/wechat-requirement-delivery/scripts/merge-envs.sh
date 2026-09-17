#!/usr/bin/env bash
# 把开发分支合并进环境分支（默认 order-stage / order-pre / order-test）。绝不 push。
#
# 特性：
#   - 全量 pre-flight：所有目标分支先校验完，再动任何一个分支（避免合并一半失败）
#   - 合并前用 git merge-tree 预测冲突，有冲突直接整体中止
#   - 三环境 tip 相同时自动 lockstep：只合并一次，其余分支快进到同一 commit
#
# 用法: merge-envs.sh <feature-branch> [--branches order-stage,order-pre,order-test] \
#                     [--remote origin] [--mode auto|lockstep|separate] [--dry-run]
set -euo pipefail

FEATURE=""
BRANCHES="order-stage,order-pre,order-test"
REMOTE="origin"
MODE="auto"
DRY_RUN=0
MERGED_TARGETS=""

die() { echo "✗ $*" >&2; exit 1; }
info() { echo "• $*"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --branches) BRANCHES="${2:-}"; shift 2 ;;
    --remote)   REMOTE="${2:-}"; shift 2 ;;
    --mode)     MODE="${2:-}"; shift 2 ;;
    --dry-run)  DRY_RUN=1; shift ;;
    -h|--help)  sed -n '2,12p' "$0"; exit 0 ;;
    -*) die "未知参数：$1" ;;
    *) [ -z "$FEATURE" ] || die "只接受一个 feature-branch 参数"; FEATURE="$1"; shift ;;
  esac
done

[ -n "$FEATURE" ] || die "缺少开发分支名。用法: merge-envs.sh feat/YYYYMMDD-xxx"
case "$MODE" in auto|lockstep|separate) ;; *) die "--mode 只能是 auto / lockstep / separate" ;; esac

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

ORIGINAL_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
restore() { git checkout --quiet "$ORIGINAL_BRANCH" 2>/dev/null || true; }
trap restore EXIT

info "fetch $REMOTE ..."
git fetch "$REMOTE" --prune --quiet || die "git fetch 失败"

if git rev-parse --verify --quiet "refs/heads/$FEATURE" >/dev/null; then
  FEATURE_REF="refs/heads/$FEATURE"
elif git rev-parse --verify --quiet "$REMOTE/$FEATURE" >/dev/null; then
  FEATURE_REF="$REMOTE/$FEATURE"
else
  die "找不到开发分支 $FEATURE（本地和 $REMOTE 都没有）"
fi

IFS=',' read -r -a TARGETS <<< "$BRANCHES"
[ "${#TARGETS[@]}" -gt 0 ] || die "目标分支列表为空"

# ---------------------------------------------------------------- pre-flight
MT_OK=0
mt_probe="$(git merge-tree --write-tree HEAD HEAD 2>/dev/null || true)"
case "$(printf '%s' "$mt_probe" | head -n 1)" in
  *[!0-9a-f]*|"") MT_OK=0 ;;
  *) [ "${#mt_probe}" -ge 40 ] && MT_OK=1 || MT_OK=0 ;;
esac

declare -a TIPS=()
PREFLIGHT_CONFLICTS=""

for t in "${TARGETS[@]}"; do
  git rev-parse --verify --quiet "$REMOTE/$t" >/dev/null || die "$REMOTE/$t 不存在"
  TIPS+=("$(git rev-parse "$REMOTE/$t")")

  if git rev-parse --verify --quiet "refs/heads/$t" >/dev/null; then
    ahead="$(git rev-list --count "$REMOTE/$t..refs/heads/$t")"
    [ "$ahead" = "0" ] || die "本地分支 $t 有 $ahead 个未推送提交，拒绝自动同步。先人工确认 $t 的本地提交去留。（本次未改动任何分支）"
  fi

  if [ "$MT_OK" = "1" ]; then
    if ! mt_out="$(git merge-tree --write-tree "$REMOTE/$t" "$FEATURE_REF" 2>&1)"; then
      files="$(printf '%s\n' "$mt_out" | awk -F'\t' 'NF>=2 && $1 ~ /^[0-7][0-7][0-7][0-7][0-7][0-7] / {print $2}' | sort -u | tr '\n' ' ')"
      [ -n "$files" ] || files="$(printf '%s\n' "$mt_out" | grep -i '^CONFLICT' | head -3 | tr '\n' ' ')"
      PREFLIGHT_CONFLICTS="$PREFLIGHT_CONFLICTS\n  - $t: ${files:-<未能解析冲突文件>}"
    fi
  fi
done

if [ -n "$PREFLIGHT_CONFLICTS" ]; then
  echo "✗ 预检发现合并冲突，已整体中止，未改动任何分支：" >&2
  printf "%b\n" "$PREFLIGHT_CONFLICTS" >&2
  echo "请人工解决冲突（或先把开发分支 rebase 到目标分支）后重试。" >&2
  exit 1
fi

LOCKSTEP=0
if [ "$MODE" = "lockstep" ]; then
  LOCKSTEP=1
elif [ "$MODE" = "auto" ]; then
  LOCKSTEP=1
  for sha in "${TIPS[@]}"; do
    [ "$sha" = "${TIPS[0]}" ] || LOCKSTEP=0
  done
fi

if [ "$DRY_RUN" = "1" ]; then
  info "[dry-run] 开发分支：$FEATURE_REF"
  info "[dry-run] 目标分支：${TARGETS[*]}"
  info "[dry-run] 模式：$([ "$LOCKSTEP" = "1" ] && echo 'lockstep（三环境同点：合并一次，其余快进）' || echo 'separate（逐分支独立合并）')"
  for i in "${!TARGETS[@]}"; do
    info "[dry-run] ${TARGETS[$i]} 当前 tip $(git rev-parse --short "${TIPS[$i]}")"
  done
  info "[dry-run] pre-flight 通过：工作区干净、无未推送本地提交、无预测冲突；不会 push"
  exit 0
fi

sync_target() {
  local t="$1"
  if git rev-parse --verify --quiet "refs/heads/$t" >/dev/null; then
    git checkout --quiet "$t"
    git merge --ff-only "$REMOTE/$t" --quiet
  else
    git checkout --quiet -b "$t" "$REMOTE/$t"
  fi
}

merge_into_current() {
  local t="$1"
  local msg="${MERGE_MSG_OVERRIDE:-merge: $FEATURE into $t（$(date +%Y-%m-%d)）}"
  if ! git merge --no-ff "$FEATURE_REF" -m "$msg" >/dev/null 2>&1; then
    echo "✗ 合并到 $t 时发生冲突，已中止本次合并。" >&2
    echo "  冲突文件：" >&2
    git diff --name-only --diff-filter=U 2>/dev/null | sed 's/^/    /' >&2 || true
    git merge --abort >/dev/null 2>&1 || true
    echo "  已合并：${MERGED_TARGETS:-无}" >&2
    echo "  回滚已合并但未推送的分支：git checkout <分支> && git reset --hard $REMOTE/<分支>" >&2
    exit 1
  fi
  MERGED_TARGETS="${MERGED_TARGETS}${MERGED_TARGETS:+, }$t"
}

MERGED_SHA=""
if [ "$LOCKSTEP" = "1" ]; then
  primary="${TARGETS[0]}"
  JOINED="$(printf '%s' "$BRANCHES" | tr ',' '/')"
  MERGE_MSG_OVERRIDE="merge: $FEATURE into $JOINED（$(date +%Y-%m-%d)）"
  info "lockstep：在 $primary 上合并 $FEATURE（merge commit 将被三个环境分支共用）"
  sync_target "$primary"
  merge_into_current "$primary"
  MERGED_SHA="$(git rev-parse HEAD)"
  info "$primary → $(git rev-parse --short HEAD)"

  for i in "${!TARGETS[@]}"; do
    t="${TARGETS[$i]}"
    [ "$t" = "$primary" ] && continue
    git branch -f "$t" "$MERGED_SHA" >/dev/null 2>&1 || die "无法把本地分支 $t 移到 $MERGED_SHA"
    git checkout --quiet "$t"
    git reset --hard --quiet "$MERGED_SHA"
    git merge-base --is-ancestor "$REMOTE/$t" "$MERGED_SHA" \
      || die "$MERGED_SHA 不是 $REMOTE/$t 的快进，已中止（本次已合并：$MERGED_TARGETS）"
    MERGED_TARGETS="${MERGED_TARGETS}, $t"
    info "$t → $(git rev-parse --short "$MERGED_SHA")（快进到同一 commit，保持三环境 SHA 一致）"
  done
else
  for t in "${TARGETS[@]}"; do
    info "在 $t 上合并 $FEATURE"
    sync_target "$t"
    merge_into_current "$t"
    MERGED_SHA="$(git rev-parse HEAD)"
    info "$t → $(git rev-parse --short HEAD)"
  done
fi

echo
echo "== 合并完成（尚未 push）=="
echo "已合并分支：$MERGED_TARGETS"
for t in "${TARGETS[@]}"; do
  echo "--- $t ---"
  echo "  merge commit : $(git rev-parse --short "refs/heads/$t")"
  echo "  待推送提交   :"
  git log --oneline "$REMOTE/$t..refs/heads/$t" | sed 's/^/    /'
  echo "  变更面       :"
  git diff --stat "$REMOTE/$t" "refs/heads/$t" | tail -n 1 | sed 's/^/    /'
done
echo
echo "⛔ 未推送。把上面内容汇报给用户，确认后再执行 push-envs.sh。"
