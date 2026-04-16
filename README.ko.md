[English](README.md) | 한국어

# 바르다 깃선생

> **Git을 배우고 싶지 않았던 사람들을 위한 Git/GitHub 플러그인.**

명령어를 외울 필요 없어요. "커밋 해시"가 뭔지 몰라도 됩니다. Google Drive를 써본 적 있다면, Git의 80%는 이미 아는 거예요. 아직 그걸 모를 뿐이죠.

[빠른 시작](#빠른-시작) • [왜 바르다 깃선생인가?](#왜-바르다-깃선생인가) • [어떻게 작동하나요?](#어떻게-작동하나요) • [기능](#기능) • [요구사항](#요구사항)

---

## 빠른 시작

### 1. 마켓플레이스 등록 (처음 한 번만)

```
/plugin marketplace add https://github.com/fivetaku/gptaku_plugins.git
```

### 2. 플러그인 설치

```
/plugin install git-teacher
```

### 3. Claude Code 재시작

플러그인이 로드되려면 재시작이 필요합니다.

### 4. 설치 시작

```
/git-teacher 시작
```

또는 그냥 이렇게 말하면 됩니다: `"깃 시작해줘"` — 자연어를 이해해요.

### 5. 5단계 흐름 따라가기

```
단계 1 + 2: 준비하기     → 도구 설치, 프로젝트 폴더 만들기 (처음 한 번만)
단계 3: 저장하기         → "저장해줘"   (변경 내용을 내 컴퓨터에 저장)
단계 4: 올리기           → "올려줘"    (GitHub에 업로드)
단계 5: 검토 요청하기    → "검토 요청해줘"  (Pull Request 만들기)
```

---

## 왜 바르다 깃선생인가?

- **명령어 외울 필요 없음** — 하고 싶은 걸 한국어로 말하면 플러그인이 알아서 처리
- **비유 중심 설명** — 모든 개념을 Google Drive, Dropbox, iCloud에 빗대어 설명. 개발자 용어 없음
- **이미 한 건 스킵** — 설치 시 현재 상태를 확인하고, 아직 안 한 단계만 실행
- **Git 출력 번역** — `fatal: not a git repository` 대신 "이 폴더는 Git 프로젝트 폴더가 아니에요"
- **어려운 부분 처리** — 충돌, detached HEAD, stash — 쉬운 말로 설명하고 선택지 제시

---

## 어떻게 작동하나요?

Google Drive와 Git의 핵심 차이는 하나입니다: **자동으로 동기화되지 않아요**. 저장도 올리기도 전부 수동입니다. 이것만 알면 나머지는 따라옵니다.

```
파일 수정
    │
    ▼
저장하기 (Commit)          ← "저장해줘"
변경 내용을 포장해서 기록
아직 내 컴퓨터에만 있음
    │
    ▼
올리기 (Push)              ← "올려줘"
GitHub 클라우드로 전송
이제 다른 사람도 볼 수 있음
    │
    ▼
검토 요청하기 (PR)         ← "검토 요청해줘"
"팀원아, 이거 확인해줘"
Google Docs 수정 제안 모드와 비슷
```

### Google Drive와 비교

| Google Drive | Git | 차이 |
|---|---|---|
| 드라이브 앱 설치 | Git + GitHub CLI 설치 | 같음 — 앱이 있어야 시작 가능 |
| 구글 계정으로 로그인 | GitHub 계정 연결 | 같음 — 클라우드 쓰려면 계정 필요 |
| 공유 폴더 만들기 | Repository(프로젝트 폴더) 만들기 | 같음 — 파일을 담을 폴더 |
| 파일 수정하면 **자동 동기화** | **자동 동기화 없음** | **핵심 차이** |
| "수정 제안" 모드 | Pull Request | 비슷 — "이렇게 바꿨는데 확인해줘" |

> 가장 중요한 것: Google Drive는 자동으로 올라갑니다. Git은 그렇지 않아요. 직접 저장(commit)하고 올려야(push) 해요. 안 하면 작업이 내 컴퓨터에만 남아요.

---

## 기능

### 명령어

| 명령어 | 하는 일 |
|---|---|
| `/git-teacher` | 뭘 할지 선택하는 메뉴 열기 |
| `/git-teacher 시작` | 설치 + 프로젝트 폴더 만들기 |
| `/git-teacher 상태` | 마지막 저장 이후 뭐가 바뀌었는지 확인 |
| `/git-teacher 저장` | 변경 내용을 내 컴퓨터에 저장 (Commit) |
| `/git-teacher 올리기` | 저장한 내용을 GitHub에 올리기 (Push) |
| `/git-teacher 검토` | 검토 요청 만들기 (Pull Request) |
| `/git-teacher 도움말` | 비유로 Git 용어 설명 |

### 자연어 트리거

슬래시 명령어 없이 이렇게 말해도 됩니다:

| 하고 싶은 것 | 이렇게 말하세요 |
|---|---|
| 처음 설정 | "깃 시작해줘", "깃 설정", "처음이에요" |
| 현재 상태 확인 | "지금 어떤 상태?", "뭐가 바뀌었어?" |
| 저장하기 (Commit) | "저장해줘", "커밋", "세이브" |
| GitHub에 올리기 (Push) | "올려줘", "푸시", "업로드" |
| 검토 요청 (Pull Request) | "PR 만들어줘", "검토 요청해줘" |
| 용어 질문 | "commit이 뭐야?", "push랑 commit 차이" |

### 스킬

| 스킬 | 단계 | 역할 |
|---|---|---|
| `git-teacher-setup` | 1–2 | Git 설치, GitHub 연결, 프로젝트 폴더 만들기 |
| `git-teacher-status` | — | `git status`를 한국어 자연어로 번역 |
| `git-teacher-save` | 3 | 변경 내용 저장 (Commit) |
| `git-teacher-upload` | 4 | GitHub에 올리기 (Push) |
| `git-teacher-review` | 5 | 검토 요청 만들기 (Pull Request) |
| `git-teacher-help` | — | 용어집 + FAQ (클라우드 비유) |

### 도움말 시스템

`git-teacher-help` 스킬이 이런 질문에 답합니다:

- "commit이 뭐야?" → 한 줄 요약 + Google Drive 비유
- "push랑 commit 차이?" → 비교표
- "Git 작업 흐름이 어떻게 돼?" → 쉬운 말로 전체 흐름 설명
- "fatal: not a git repository 이게 뭐야?" → 번역 + 다음에 할 일 안내

---

## 요구사항

- [Claude Code](https://docs.anthropic.com/claude-code) CLI
- Claude Max/Pro 구독 또는 지원되는 Claude API 키

추가 의존성 없음. npm install 없음. 빌드 단계 없음.

---

## 라이선스

MIT — [fivetaku](https://github.com/fivetaku)

---

<div align="center">

**Git이 어려운 게 아니에요. 선생님이 없었을 뿐이에요.**

</div>
