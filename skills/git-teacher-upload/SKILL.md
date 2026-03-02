---
name: git-teacher-upload
description: 저장한 내용을 GitHub에 올리는(Push) 스킬. "올려줘", "푸시", "push", "업로드", "GitHub에 올려줘", "클라우드에 보내줘", "올리기" 같은 요청에 사용됩니다.
---

# 올리기 — Phase 4 (바르다 깃선생)

저장(Commit)한 내용을 GitHub 클라우드에 올린다(Push). 성공 시 GitHub URL을 제공한다.

## 실행 순서

### Step 1: 병렬 상태 수집

다음 명령을 **병렬로** 실행한다:

```bash
git rev-parse --is-inside-work-tree    # .git 존재 확인
git symbolic-ref --short HEAD          # 현재 branch
git status --porcelain                 # 미저장 변경 확인
git rev-list --count @{u}..HEAD 2>/dev/null || echo "no-upstream"  # 올리지 않은 commit 수
git remote get-url origin 2>/dev/null  # 원격 저장소 URL
```

### Step 2: 안전 검사

1. **`.git` 없음**: "여기는 Git 프로젝트 폴더가 아니에요." → 중단
2. **Detached HEAD**: 자동 복구 후 재시도
3. **원격 저장소 없음**: "GitHub에 연결되어 있지 않아요. '깃 시작해줘'로 먼저 설정하세요." → 중단
4. **저장하지 않은 변경 있음**: "아직 저장(Commit)하지 않은 변경 사항이 있어요. 먼저 '저장해줘'로 저장하세요." → 중단
5. **올릴 게 없음** (HEAD와 upstream이 동일): "이미 모든 내용이 GitHub에 올라가 있어요." → 중단

### Step 3: Push 실행

```bash
git push origin HEAD
```

### Step 4: 영수증 출력

#### 성공 시

GitHub URL을 구성하여 안내한다:

```
업로드 완료!

GitHub에서 확인: https://github.com/username/my-project
저장한 내용 2개가 클라우드에 올라갔어요.

이제 다른 사람도 이 내용을 볼 수 있어요.
```

GitHub URL은 `git remote get-url origin` 결과에서 추출한다. SSH URL인 경우 HTTPS URL로 변환한다:
- `git@github.com:user/repo.git` → `https://github.com/user/repo`

#### 실패 시

```
업로드에 실패했어요.
```

흔한 실패 원인별 안내:
- **rejected (non-fast-forward)**: "다른 사람이 먼저 올린 내용이 있어요. 최신 내용을 먼저 받아올게요." → 현재 branch 이름을 감지하여 `git pull --rebase origin {현재 branch}` 자동 실행 시도. 성공 시 다시 push.
- **permission denied**: "GitHub 접근 권한이 없어요. '깃 시작해줘'로 다시 로그인해보세요."
- **remote not found**: "GitHub 연결이 끊어졌어요. '깃 시작해줘'로 다시 설정하세요."

### Pull 후 충돌 발생 시

`git pull --rebase` 후 충돌이 발생하면 **EXECUTE:** 아래 JSON으로 AskUserQuestion 도구를 즉시 호출한다:

```json
{
  "questions": [{
    "question": "클라우드의 최신 내용을 받아오다가 충돌이 생겼어요. 두 사람이 같은 부분을 동시에 고쳤거든요.\n충돌 파일: {파일 목록}\n\n어떻게 할까요?",
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
- "내 거 유지": `git checkout --ours {파일}` → `git add {파일}` → `git rebase --continue`
- "상대방 거 유지": `git checkout --theirs {파일}` → `git add {파일}` → `git rebase --continue`

충돌 해결 후 자동으로 push를 재시도한다.

## 다음 행동 안내

- 성공 시: "팀원에게 검토를 요청하려면 '검토 요청해줘'라고 하세요."
- 실패 시: 원인별 해결 방법 제시
