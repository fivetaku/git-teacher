---
name: git-teacher-review
description: Branch 생성부터 PR 생성까지 자동으로 처리하는 검토 요청 스킬. "PR 만들어줘", "검토 요청", "리뷰 요청", "pull request", "수정 제안", "팀원한테 보여주고 싶어", "확인 요청" 같은 요청에 사용됩니다.
---

# 검토 요청하기 — Phase 5 (바르다 깃선생)

Branch 생성 → Commit → Push → PR 생성을 자동으로 처리한다. Branch 개념은 사용자에게 숨기고 "안전한 작업 공간"으로 설명한다.

## 실행 순서

### Step 1: 병렬 상태 수집

다음 명령을 **병렬로** 실행한다:

```bash
git rev-parse --is-inside-work-tree    # .git 존재 확인
git symbolic-ref --short HEAD          # 현재 branch (detached HEAD 감지)
git status --porcelain                 # 변경 파일 목록
git rev-list --count @{u}..HEAD 2>/dev/null || git rev-list --count HEAD 2>/dev/null  # 올리지 않은 commit 수 (upstream 없으면 전체 commit 수로 대체)
git remote get-url origin 2>/dev/null  # 원격 저장소 URL
gh auth status 2>&1                    # GitHub CLI 로그인 상태
```

### Step 2: 안전 검사

1. **`.git` 없음**: "여기는 Git 프로젝트 폴더가 아니에요. '깃 시작해줘'로 먼저 설정하세요." → 중단
2. **Detached HEAD**: "안전한 위치에서 벗어났어요. 자동으로 돌아갈게요." → `git checkout main` (또는 master) 실행 후 재시도
3. **원격 저장소 없음**: "GitHub에 연결되어 있지 않아요. '깃 시작해줘'로 먼저 설정하세요." → 중단
4. **gh 미로그인**: "GitHub CLI에 로그인되어 있지 않아요. '깃 시작해줘'로 설정하세요." → 중단
5. **Merge Conflict** (`UU`, `AA` 등 감지 시): 충돌 해결 안내 (아래 "충돌 해결" 섹션 참조) → 중단
6. **변경 사항 판단**: 아래 두 조건을 **모두** 확인한다:
   - `git status --porcelain` 결과 (수정된 파일 존재 여부)
   - `git rev-list --count @{u}..HEAD` 결과 (올리지 않은 commit 존재 여부; upstream 미설정 시 전체 commit 수로 대체)
   - 둘 다 비어있으면: "변경된 파일도 없고, 올리지 않은 저장도 없어요. 파일을 수정한 뒤 다시 시도하세요." → 중단
   - 수정된 파일은 없지만 미전송 commit이 있으면: 이미 저장(save)된 내용으로 PR 진행 (Step 5에서 commit 스킵)
7. **이미 main/master가 아닌 branch에 있음**: 현재 branch에서 그대로 진행 (새 branch 생성 스킵)

### Step 3: 작업 설명 요청

> 검토 요청(PR)을 만들어볼게요.
> Google Docs에서 "수정 제안" 모드 아시죠?
> 원본은 그대로 두고, "이렇게 바꾸면 어떨까요?" 하고 보내는 거예요.

**EXECUTE:** 아래 JSON으로 AskUserQuestion 도구를 즉시 호출한다:

```json
{
  "questions": [{
    "question": "어떤 작업을 했는지 한 줄로 적어주세요.",
    "header": "작업 설명",
    "options": [
      {"label": "직접 입력", "description": "Other에 작업 설명을 입력해주세요 (예: '메인 페이지 디자인 변경', '오타 수정')"},
      {"label": "자동 생성", "description": "변경 내용을 분석해서 설명을 자동으로 만들어요"}
    ],
    "multiSelect": false
  }]
}
```

### Step 4: Branch 생성 (사용자에게 숨김)

현재 branch가 main 또는 master인 경우에만 새 branch를 생성한다:

```bash
git checkout -b {slug}/{date}
```

Branch 이름 규칙:
- 사용자 입력을 slug화: "메인 페이지 디자인 변경" → `main-page-design`
- 날짜 추가: `main-page-design/0222`
- 한국어는 영어로 간단히 변환하거나 로마자화

사용자에게는: "안전한 작업 공간을 만들었어요. 여기서는 마음껏 수정해도 원본에 영향이 없어요."

**이미 저장된(commit) 내용을 새 branch로 옮기는 경우**:
main에서 이미 commit된 상태라면, branch를 만든 뒤 main의 commit을 되돌려야 한다.
미전송 commit 수는 Step 1에서 수집한 `git rev-list --count` 결과를 사용한다:
```bash
git checkout -b {slug}/{date}        # 새 branch 생성 (commit 포함)
git checkout main                     # main으로 잠시 돌아감
git reset --soft HEAD~{미전송 commit 수}  # main의 commit 되돌림 (staging area에 남음)
git checkout {slug}/{date}            # 다시 작업 branch로
```

> 주의: 이 과정에서 기존 개별 commit 메시지들은 하나로 합쳐진다 (squash 효과).
> 비개발자에게는 오히려 깔끔한 결과를 제공하므로 의도된 동작이다.

### Step 5: Commit + Push

수정된 파일이 있는 경우에만 commit한다 (이미 저장된 경우 스킵):

```bash
git add -A                             # 수정된 파일이 있을 때만
git commit -m "사용자가 입력한 작업 설명"  # 수정된 파일이 있을 때만
git push origin HEAD
```

### Step 6: PR 생성

```bash
gh pr create --title "사용자가 입력한 작업 설명" --body "$(cat <<'EOF'
## 변경 내용
{사용자가 입력한 작업 설명}

---
Created by 바르다 깃선생
EOF
)"
```

### Step 7: main으로 복귀

PR 생성 후 자동으로 main branch로 돌아간다:

```bash
git checkout main
```

### Step 8: 영수증 출력

```
검토 요청 완료!
링크: https://github.com/username/my-project/pull/1

이 링크를 팀원에게 보내면, 변경 내용을 확인하고
"좋아요, 반영해주세요" 하고 승인할 수 있어요.

지금은 원래 위치(main)로 돌아온 상태예요.
새로운 작업을 시작하려면 파일을 수정한 뒤 "저장해줘"라고 하세요.
```

## 이미 별도 branch에 있는 경우

Step 2에서 현재 branch가 main/master가 아닌 경우:
- Step 4(branch 생성)를 스킵
- 현재 branch에서 바로 commit → push → PR 생성 진행
- "이미 작업 공간에 있어서, 바로 검토 요청을 만들게요."

## 충돌 해결

Merge Conflict 감지 시 **EXECUTE:** 아래 JSON으로 AskUserQuestion 도구를 즉시 호출한다:

```json
{
  "questions": [{
    "question": "두 사람이 같은 파일의 같은 부분을 동시에 고쳐서 충돌이 생겼어요. 어떻게 할까요?",
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
- "내 거 유지": `git checkout --ours {파일}` → `git add {파일}`
- "상대방 거 유지": `git checkout --theirs {파일}` → `git add {파일}`

충돌 파일이 여러 개일 경우 파일 목록을 보여주고 일괄 처리한다.

## 오류 처리

- **PR 이미 존재**: "이 작업 공간의 검토 요청이 이미 있어요." → 기존 PR URL 안내
- **push 실패**: upload 스킬의 오류 처리와 동일하게 안내
- **gh pr create 실패**: "검토 요청 생성에 실패했어요." → `gh auth status` 재확인 안내
