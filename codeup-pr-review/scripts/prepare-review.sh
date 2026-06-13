#!/usr/bin/env bash
#
# prepare-review.sh —— 为评审一个 Codeup MR 做准备
#
# 作用：把待评审的源分支签出到独立的 git worktree（不打断当前工作区），
#       并生成它相对基线分支的 diff，供 AI 评审。
#
# 用法：
#   ./prepare-review.sh <源分支名> [基线分支]
#
# 示例：
#   ./prepare-review.sh feature/lottery-trend-chart
#   ./prepare-review.sh hotfix/x5-webview-crash main
#
# 不传基线分支时按团队规范自动推断：hotfix/* → main，其余 → develop。
#
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "用法: $0 <源分支名> [基线分支]" >&2
  exit 1
fi

BRANCH="$1"
BASE="${2:-}"

# 按团队规范推断基线分支
if [ -z "$BASE" ]; then
  case "$BRANCH" in
    hotfix/*) BASE="main" ;;
    *)        BASE="develop" ;;
  esac
fi

# 拉取最新的源分支与基线分支
git fetch origin "$BRANCH" "$BASE"

# 用独立 worktree 签出，避免污染/打断当前工作区
SAFE_NAME="${BRANCH//\//-}"
WORKTREE_DIR="$(git rev-parse --show-toplevel)/../review-${SAFE_NAME}"
git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
git worktree add --force --detach "$WORKTREE_DIR" "origin/${BRANCH}"

# 生成三点 diff（基于稳定的 merge-base，等价于 Codeup 上看到的 MR 变更）
DIFF_FILE="${WORKTREE_DIR}/review.diff"
git -C "$WORKTREE_DIR" diff "origin/${BASE}...origin/${BRANCH}" > "$DIFF_FILE"

# 变更文件清单
FILES_FILE="${WORKTREE_DIR}/changed-files.txt"
git -C "$WORKTREE_DIR" diff --name-status "origin/${BASE}...origin/${BRANCH}" > "$FILES_FILE"

echo "==== 评审准备完成 ===="
echo "BRANCH=$BRANCH"
echo "BASE=$BASE"
echo "WORKTREE=$WORKTREE_DIR        # 已签出完整代码，可在此读上下文"
echo "DIFF_FILE=$DIFF_FILE          # 本次 MR 的变更 diff"
echo "FILES_FILE=$FILES_FILE        # 变更文件清单"
echo ""
echo "评审结束后清理： git worktree remove --force \"$WORKTREE_DIR\""
