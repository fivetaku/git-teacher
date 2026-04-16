---
name: git-teacher-save
description: Commits changed files to Git, explained in plain language for non-developers. Runs `git add -A` + `git commit` and describes what was saved. Korean triggers: "저장해줘", "커밋", "커밋해줘", "변경 내용 저장", "지금까지 한 거 저장", "세이브". English triggers: "save", "commit", "save my work".
---

# 저장하기 — Phase 3 (바르다 깃선생)

변경된 파일을 Commit (저장)한다. `git add -A` + `git commit`을 실행하고, 사후에 무엇을 했는지 설명한다.

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
2. **Detached HEAD**: "안전한 위치에서 벗어났어요." → `git checkout main` 실행 후 재시도
3. **Merge Conflict** (`UU`, `AA` 등): 충돌 파일 목록을 보여주고, **EXECUTE:** 아래 JSON으로 AskUserQuestion 도구를 즉시 호출한다:
   ```json
   {
     "questions": [{
       "question": "충돌이 있어서 바로 저장할 수 없어요. 두 사람이 같은 부분을 동시에 고쳤거든요.\n충돌 파일: {파일 목록}\n\n어떻게 할까요?",
       "header": "충돌 해결",
       "options": [
         {"label": "내가 수정한 걸로 유지", "description": "내 변경 내용을 사용해요"},
         {"label": "상대방이 수정한 걸로 유지", "description": "상대방의 변경 내용을 사용해요"}
       ],
       "multiSelect": false
     }]
   }
   ```
   선택에 따라:
   - "내가 수정한 걸로 유지": `git checkout --ours {파일}` → `git add {파일}`
   - "상대방이 수정한 걸로 유지": `git checkout --theirs {파일}` → `git add {파일}`
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

### Step 5: 저장 실행

```bash
git add -A
git commit -m "사용자가 입력한 메시지"
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
