---
name: git-teacher-setup
description: Git/GitHub 초기 설정부터 프로젝트 폴더 생성까지 안내하는 스킬. "깃 시작", "깃 설정", "처음이에요", "git 설치", "GitHub 연결", "프로젝트 만들기", "깃 세팅", "시작하기" 같은 요청에 사용됩니다.
---

# 시작하기 — Phase 1 + 2 (바르다 깃선생)

Git/GitHub 초기 설정(Phase 1)과 프로젝트 폴더 만들기(Phase 2)를 한번에 처리한다.
이미 완료된 단계는 자동으로 스킵한다.

## Phase 1: 준비하기

"Google Drive 앱을 설치하고 구글 계정으로 로그인하는 것과 같아요."

### Step 1: 병렬 상태 수집

다음 명령을 **병렬로** 실행한다:

```bash
git --version 2>/dev/null              # git 설치 확인
gh --version 2>/dev/null               # gh 설치 확인
git config --global user.name          # 이름 설정 확인
git config --global user.email         # 이메일 설정 확인
gh auth status 2>&1                    # GitHub 로그인 확인
```

### Step 2: 완료된 단계 스킵 + 미완료 단계 진행

수집 결과를 분석하여 이미 완료된 항목은 체크 표시로 보여주고, 미완료 항목만 진행한다.

#### 2a. Git 설치 (미설치 시)

```
Git이 설치되어 있지 않아요. 설치할게요.
드라이브를 쓰려면 드라이브 앱이 필요한 것처럼, Git도 앱이 필요해요.
```

macOS:
```bash
xcode-select --install
```

Windows: https://git-scm.com/download/win 에서 설치 파일을 다운로드한다.

Linux:
```bash
sudo apt-get install git
```

설치 후 확인: `git --version`

#### 2b. GitHub CLI (gh) 설치 (미설치 시)

```
GitHub CLI를 설치할게요. GitHub에 파일을 올리는 데 필요한 도구예요.
```

macOS (Homebrew 있을 때):
```bash
brew install gh
```

Homebrew 없을 때: Homebrew 설치를 먼저 안내한다.

Windows:
```bash
winget install --id GitHub.cli
```

Linux:
```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
&& sudo mkdir -p -m 755 /etc/apt/keyrings \
&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
```

또는 배포판 저장소에서 바로 설치 가능한 경우: `sudo apt install gh`

설치 후 확인: `gh --version`

#### 2c. Git 사용자 정보 설정 (미설정 시)

> Git에 이름과 이메일을 등록해야 해요.
> 구글 계정을 만들 때 이름을 입력하는 것과 같아요.
> 파일을 저장할 때 "누가 수정했는지" 기록하는 데 쓰여요.

**EXECUTE:** 아래 JSON으로 AskUserQuestion 도구를 즉시 호출한다:

```json
{
  "questions": [{
    "question": "Git에 등록할 이름과 이메일을 알려주세요. (예: 홍길동 / hong@email.com)",
    "header": "사용자 정보",
    "options": [
      {"label": "직접 입력", "description": "이름과 이메일을 Other에 입력해주세요 (예: 홍길동 / hong@email.com)"},
      {"label": "GitHub 계정과 동일", "description": "GitHub 로그인 후 자동으로 가져올게요"}
    ],
    "multiSelect": false
  }]
}
```

```bash
git config --global user.name "사용자 이름"
git config --global user.email "사용자 이메일"
```

#### 2d. GitHub 로그인 (미로그인 시)

```
GitHub에 로그인할게요. 구글 계정으로 드라이브에 로그인하는 것과 같아요.
브라우저 창이 열리면 로그인하고 승인해주세요.
```

```bash
gh auth login --web --git-protocol https
```

### Step 3: Phase 1 완료 확인

```
준비 완료!
  - Git 설치됨 (v2.xx)
  - GitHub 로그인됨 (계정: username)

이제 프로젝트 폴더를 만들 수 있어요.
```

## Phase 2: 폴더 만들기

"Google Drive에 새 공유 폴더를 만드는 것과 같아요."

### Step 4: 프로젝트 선택

**EXECUTE:** 아래 JSON으로 AskUserQuestion 도구를 즉시 호출한다:

```json
{
  "questions": [{
    "question": "프로젝트 폴더를 어떻게 만들까요?",
    "header": "프로젝트",
    "options": [
      {"label": "새 프로젝트 시작하기", "description": "빈 폴더를 만들어요"},
      {"label": "기존 프로젝트 가져오기", "description": "GitHub에 있는 폴더를 복사해요"},
      {"label": "현재 폴더를 프로젝트로 만들기", "description": "지금 이 폴더를 Git으로 관리해요"}
    ],
    "multiSelect": false
  }]
}
```

#### 선택 1: 새 프로젝트 시작하기

AskUserQuestion으로 프로젝트 이름을 받는다.

```bash
mkdir {project-name} && cd {project-name}
git init
gh repo create {project-name} --public --source=. --remote=origin --push
```

#### 선택 2: 기존 프로젝트 가져오기

AskUserQuestion으로 GitHub URL 또는 저장소 이름을 받는다.

사용자 입력을 분석하여 적절한 명령을 실행한다:
- `owner/repo` 형태: `gh repo clone {owner/repo}`
- `https://github.com/...` 형태: `git clone {URL}`
- `git@github.com:...` 형태: `git clone {URL}`

#### 선택 3: 현재 폴더를 프로젝트로 만들기

```bash
git init
gh repo create {folder-name} --public --source=. --remote=origin --push
```

### Step 5: Phase 2 완료 확인

```
폴더 준비 완료!
  - 내 컴퓨터: /Users/me/my-project
  - 클라우드: https://github.com/username/my-project

이 두 곳이 연결되어 있어요. 드라이브의 "동기화 폴더"와 비슷하죠.
단, 자동 동기화는 안 돼요 — 직접 "저장"하고 "올려야" 해요.

파일을 수정한 뒤 "저장해줘"라고 하면 됩니다.
```

## 이미 모든 게 설정된 경우

모든 검사가 통과되면:

```
이미 다 준비되어 있어요!

  - Git 설치됨 (v2.xx)
  - GitHub 로그인됨 (계정: username)
  - 프로젝트 연결됨: https://github.com/username/my-project

바로 작업을 시작할 수 있어요.
"상태 확인"으로 현재 상태를 볼 수 있고,
파일을 수정한 뒤 "저장해줘"로 저장할 수 있어요.
```
