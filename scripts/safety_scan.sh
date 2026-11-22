#!/usr/bin/env bash
# git-teacher safety scan — 커밋/푸시 직전에 비밀값·큰 파일을 찾는다.
#   --staged            : 스테이징된 파일(커밋 직전) 검사
#   --range <A..B>      : 아직 안 올린 커밋 범위(푸시 직전) 검사, 예: @{u}..HEAD
#   --worktree          : 작업 폴더의 변경 파일(커밋 전 미리보기) 검사
# 출력: 걸린 항목을 "SECRET_NAME|SECRET_CONTENT|LARGE <파일> <이유>" 줄로. 없으면 "CLEAN".
# 종료코드: 0 깨끗함, 1 걸림, 2 사용법 오류. 값 자체는 절대 출력하지 않는다.
set -u
MODE="${1:-}"
LIMIT_MB="${GIT_TEACHER_LARGE_MB:-50}"
LIMIT=$((LIMIT_MB * 1024 * 1024))

case "$MODE" in
  --staged)   files=$(git diff --cached --name-only --diff-filter=ACMR) ; diffcmd=(git diff --cached -U0 --diff-filter=ACMR) ;;
  --range)    [ -n "${2:-}" ] || { echo "usage: $0 --range <A..B>" >&2; exit 2; }
              files=$(git diff --name-only --diff-filter=ACMR "$2") ; diffcmd=(git diff -U0 --diff-filter=ACMR "$2") ;;
  --worktree) files=$( { git diff --name-only --diff-filter=ACMR; git ls-files --others --exclude-standard; } | sort -u)
              diffcmd=(git diff -U0 --diff-filter=ACMR) ;;
  *) echo "usage: $0 --staged | --range <A..B> | --worktree" >&2; exit 2 ;;
esac

hits=0
name_re='(^|/)(\.env(\..*)?|.*\.pem|.*\.key|.*\.p12|.*\.pfx|id_(rsa|dsa|ecdsa|ed25519)|credentials(\..*)?\.json|service[-_]account.*\.json|.*secret.*|\.npmrc|\.pypirc|\.netrc)$'
allow_re='(^|/)\.env\.(example|sample|template)$'

while IFS= read -r f; do
  [ -z "$f" ] && continue
  if printf '%s\n' "$f" | grep -Eiq "$name_re" && ! printf '%s\n' "$f" | grep -Eiq "$allow_re"; then
    echo "SECRET_NAME $f 비밀값이 들어 있을 수 있는 파일 이름"; hits=$((hits + 1))
  fi
  if [ "$MODE" = "--range" ]; then
    size=$(git cat-file -s "$(echo "$2" | sed 's/.*\.\.//'):$f" 2>/dev/null || echo 0)
  else
    size=$(wc -c < "$f" 2>/dev/null | tr -d ' ' || echo 0)
  fi
  if [ "${size:-0}" -gt "$LIMIT" ] 2>/dev/null; then
    echo "LARGE $f $((size / 1024 / 1024))MB (기준 ${LIMIT_MB}MB, GitHub는 100MB부터 거절)"; hits=$((hits + 1))
  fi
done <<< "$files"

content_re='(AKIA[0-9A-Z]{16}|sk-(ant-|proj-)?[A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|xox[abprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{35}|-----BEGIN [A-Z ]*PRIVATE KEY-----|(password|passwd|api[_-]?key|secret|token)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"'[:space:]]{8,})'
current=""
while IFS= read -r line; do
  case "$line" in
    "+++ b/"*) current="${line#+++ b/}" ;;
    +*) if printf '%s\n' "${line#+}" | grep -Eiq "$content_re"; then
          echo "SECRET_CONTENT $current 비밀값처럼 보이는 줄"; hits=$((hits + 1))
        fi ;;
  esac
done < <("${diffcmd[@]}" 2>/dev/null)

if [ "$MODE" = "--worktree" ]; then
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    git ls-files --error-unmatch "$f" >/dev/null 2>&1 && continue
    if grep -EIq "$content_re" "$f" 2>/dev/null; then
      echo "SECRET_CONTENT $f 비밀값처럼 보이는 줄(새 파일)"; hits=$((hits + 1))
    fi
  done <<< "$files"
fi

if [ "$hits" -eq 0 ]; then echo "CLEAN"; exit 0; fi
exit 1
