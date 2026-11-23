---
name: git-teacher-save
description: Saves (commits) work for non-developers who want the step explained in plain language — scans for secrets and large files first, then commits and explains what was saved. Use when the user asks for help or explanation while saving (e.g. "저장해줘", "지금까지 한 거 저장해줘", "변경 내용 저장하는 법 알려줘", "커밋이 뭔지 모르겠는데 저장해줘", "save my work and explain"). Do NOT use for a plain developer instruction like "commit this" / "커밋해" inside a coding-agent session — just commit normally there.
---

<!-- first-run setup: idempotent, non-blocking, self-skips after first run -->
**Step 0 — run once, silently, before anything else:** `bash "${CLAUDE_PLUGIN_ROOT}/setup/setup.sh" >/dev/null 2>&1 || true` — do not narrate or comment on it, then continue.

## 실행 환경 (Claude Code / Codex)

- **Claude Code**: 선택지는 `AskUserQuestion`으로 묻는다.
- **Codex**: 시작 전에 `../git-teacher-help/references/codex.md`를 읽는다. async 호출 형식: `{"questions":[{"title":"헤더 — 질문","options":["추천안 (추천) — 설명","대안 — 설명"]}]}` — 문항에는 `title`·`options`(문자열 배열)만, `question`·`header`·`id`는 넣지 않는다.
- Codex에서는 `${CLAUDE_PLUGIN_ROOT}`를 이 플러그인 루트(이 SKILL.md에서 두 단계 위 폴더)로 바꿔 읽는다.

# 저장하기 — Phase 3 (바르다 깃선생)

변경된 파일을 Commit (저장)한다. 비밀값·큰 파일 검사 → `git commit` 순서로 실행하고, 사후에 무엇을 했는지 설명한다.

## 실행 순서

### Step 1: 병렬 상태 수집

다음 명령을 **병렬로** 실행한다:

```bash
git rev-parse --is-inside-work-tree    # .git 존재 확인
git symbolic-ref --short HEAD          # 현재 branch
git status --porcelain                 # 변경 파일 목록
git diff --stat                        # 변경 통계
ls .gitignore 2>/dev/null              # .gitignore 존재 여부
```

### Step 2: 안전 검사

1. **`.git` 없음**: "여기는 Git 프로젝트 폴더가 아니에요. '깃 시작해줘'로 먼저 설정하세요." → 중단
2. **Detached HEAD**: "안전한 위치에서 벗어나 있어요. 지금 위치에 저장된 작업이 사라지지 않게 먼저 구조용 이름표를 붙인 뒤 돌아갈게요."
   ```bash
   git switch -c "rescue/$(date +%Y%m%d-%H%M%S)"   # 지금 위치 보존 (커밋이 고아가 되지 않게)
   git switch main 2>/dev/null || git switch master
   ```
   구조용 브랜치 이름을 알려주고 "필요 없으면 나중에 지워도 돼요"라고 안내한다. 보존 없이 바로 main으로 이동하지 않는다.
3. **Merge Conflict** (`UU`, `AA` 등): 충돌 파일 목록을 보여주고, **덩어리 단위로 합친다** — `${CLAUDE_PLUGIN_ROOT}/skills/git-teacher-help/references/conflict-resolution.md` 절차를 Read로 읽고 그대로 따른다.
   - 충돌 구간마다 양쪽이 무엇을 바꿨는지 쉬운 말로 설명한다.
   - 함께 살 수 있는 수정은 에이전트가 합치고 결과를 보여준다.
   - 의도가 정말 부딪히는 덩어리만 AskUserQuestion으로 고르게 한다(내 쪽 / 상대 쪽 / 둘 다 살려 합치기).
   - 파일을 통째로 한쪽으로 덮는 선택은 기본으로 하지 않는다 — 같은 파일의 충돌 아닌 수정까지 사라진다.
   충돌 해결 후 자동으로 저장(commit) 단계로 진행한다.
4. **변경 사항 없음**: "저장할 변경 사항이 없어요. 파일을 수정한 뒤 다시 시도하세요." → 중단

### Step 3: .gitignore 자동 생성

`.gitignore`가 없으면 프로젝트 타입을 감지하여 기본 `.gitignore`를 생성한다:

- Node.js (`package.json` 존재) → `node_modules/`, `.env`, `dist/` 등
- Python (`requirements.txt` 또는 `pyproject.toml` 존재) → `__pycache__/`, `.env`, `venv/` 등
- 일반 → `.env`, `.DS_Store`, `*.log`, `thumbs.db` 등

생성 후 안내: "보안을 위해 .gitignore 파일을 만들었어요. 비밀번호나 임시 파일은 자동으로 제외됩니다."

### Step 4: 변경 파일 안내 + 커밋 메시지 요청

변경된 파일 목록을 보여준 뒤 커밋 메시지를 물어본다.

**EXECUTE:** 아래 JSON으로 AskUserQuestion 도구를 즉시 호출한다 (변경 파일 목록을 question에 포함):

```json
{
  "questions": [{
    "question": "변경된 파일 N개:\n  - file1 (수정됨)\n  - file2 (새 파일)\n\n뭘 바꿨는지 한 줄로 적어주세요.",
    "header": "커밋 메시지",
    "options": [
      {"label": "직접 입력", "description": "Other에 커밋 메시지를 입력해주세요 (예: '로고 변경', '메인 페이지 수정')"},
      {"label": "자동 생성", "description": "변경 내용을 분석해서 메시지를 자동으로 만들어요"}
    ],
    "multiSelect": false
  }]
}
```

> question 안의 파일 목록은 `git status --porcelain` 결과를 기반으로 동적 생성한다.

**사용자가 빈 값이나 애매한 답을 주면**: 변경 내용을 분석하여 자연어 메시지를 자동 생성한다.

### Step 4.5: 비밀값·큰 파일 검사 (항상)

`.gitignore`가 있어도 **매번** 실행한다. `.gitignore`는 이미 추적 중인 파일이나 이름이 다른 비밀 파일을 막지 못한다.

```bash
git add -A
bash "${CLAUDE_PLUGIN_ROOT}/scripts/safety_scan.sh" --staged
```

- `CLEAN`이면 Step 5로 진행.
- `SECRET_NAME` / `SECRET_CONTENT`: 해당 파일을 `git restore --staged {파일}`로 빼고, "비밀번호나 열쇠 같은 값이 들어 있을 수 있어서 저장에서 뺐어요"라고 설명한다. `.gitignore`에 추가할지 AskUserQuestion으로 묻는다. 값 자체는 절대 화면에 보여주지 않는다.
- `LARGE`(50MB 초과): 해당 파일을 빼고 "GitHub는 100MB부터 거절하고, 50MB만 넘어도 느려져요"라고 설명한 뒤 `.gitignore` 추가 여부를 묻는다.
- 사용자가 "그래도 넣어줘"라고 명시하면 그 파일만 다시 `git add` 한다.

### Step 5: 저장 실행

```bash
git commit -m "사용자가 입력한 메시지"   # Step 4.5에서 검사를 통과한 파일만 스테이징된 상태
```

커밋 메시지 규칙:
- 사용자가 입력한 자연어 그대로 사용 (conventional commits 강제하지 않음)
- 한국어/영어 모두 허용
- 예: "로고 변경", "메인 페이지 수정", "오타 고침"

### Step 6: 영수증 출력

실행 후 결과를 알려준다:

```
저장 완료! 파일 3개를 포장해서 '로고 변경'이라고 기록했어요.

아직 내 컴퓨터에만 있어요.
GitHub 클라우드에도 올리려면 "올려줘"라고 하세요.
```

## 핵심 강조사항

- 저장 후 **매번** "아직 내 컴퓨터에만 있어요" 리마인드
- Commit과 Push의 차이를 체감하게 함
- 다음 행동(Push)을 안내
