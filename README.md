한국어 | [English](README.md)

> Switch to Korean: [README.ko.md](README.ko.md)

# git-teacher

> **Git and GitHub for people who never wanted to learn Git.**

You don't need to memorize commands. You don't need to know what a "commit hash" is. If you've ever used Google Drive, you already understand 80% of Git — you just don't know it yet.

[Quick Start](#quick-start) • [Why git-teacher?](#why-git-teacher) • [How it works](#how-it-works) • [Features](#features) • [Requirements](#requirements)

---

## Quick Start

### 1. Add the marketplace (once)

```
/plugin marketplace add https://github.com/fivetaku/gptaku_plugins.git
```

### 2. Install the plugin

```
/plugin install git-teacher
```

### 3. Restart Claude Code

Restart is required for the plugin to load.

### 4. Start the setup

```
/git-teacher 시작
```

Or just say: `"깃 시작해줘"` — the plugin understands natural language.

### 5. Follow the 5-step flow

```
Step 1 + 2: Setup       → install tools, create your project folder (once)
Step 3: Save            → "저장해줘"   (commit your changes)
Step 4: Upload          → "올려줘"    (push to GitHub)
Step 5: Request review  → "검토 요청해줘"  (open a pull request)
```

---

## Why git-teacher?

- **No command memorization** — say what you want to do in plain Korean, the plugin figures out the rest
- **Analogy-first explanations** — every concept is explained using Google Drive, Dropbox, or iCloud, not developer jargon
- **Skips what you already did** — setup detects your current state and only runs the steps you actually need
- **Translates Git output** — instead of `fatal: not a git repository`, you get "이 폴더는 Git 프로젝트 폴더가 아니에요"
- **Handles the hard parts** — merge conflicts, detached HEAD, stash — explained in plain language with clear choices

---

## How it works

Git has one core difference from Google Drive: **nothing syncs automatically**. Every save and every upload is a manual step. Once you know that, the rest follows.

```
You edit a file
       │
       ▼
  Save (Commit)          ← "저장해줘"
  Packages your changes
  Still only on your machine
       │
       ▼
  Upload (Push)          ← "올려줘"
  Sends to GitHub cloud
  Now others can see it
       │
       ▼
  Request Review (PR)    ← "검토 요청해줘"
  "Hey team, check this out"
  Like Google Docs suggestion mode
```

### The Google Drive comparison

| Google Drive | Git | Key difference |
|---|---|---|
| Install the app | Install Git + GitHub CLI | Same — you need an app to start |
| Log in with Google account | Connect GitHub account | Same — you need an account for the cloud |
| Create a shared folder | Create a repository | Same — a folder to hold your files |
| Files sync automatically | **Files do NOT sync automatically** | **This is the big one** |
| "Suggest edits" mode | Pull Request | Similar — "here's what I changed, please review" |

> The most important thing to remember: Google Drive auto-syncs. Git does not. You have to save (commit) and upload (push) manually. If you forget, your work stays on your machine only.

---

## Features

### Commands

| Command | What it does |
|---|---|
| `/git-teacher` | Opens a menu to pick what you want to do |
| `/git-teacher 시작` | Setup: install tools + create project folder |
| `/git-teacher 상태` | Status: what changed since your last save? |
| `/git-teacher 저장` | Save: commit your changes locally |
| `/git-teacher 올리기` | Upload: push commits to GitHub |
| `/git-teacher 검토` | Review: open a pull request |
| `/git-teacher 도움말` | Help: explain any Git term with analogies |

### Natural language triggers

You don't have to use slash commands. These phrases work too:

| What you want | Say this |
|---|---|
| First-time setup | "깃 시작해줘", "깃 설정", "처음이에요" |
| Check current state | "지금 어떤 상태?", "뭐가 바뀌었어?" |
| Save changes (Commit) | "저장해줘", "커밋", "세이브" |
| Upload to GitHub (Push) | "올려줘", "푸시", "업로드" |
| Request review (PR) | "PR 만들어줘", "검토 요청해줘" |
| Ask about a term | "commit이 뭐야?", "push랑 commit 차이" |

### Skills

| Skill | Phase | Description |
|---|---|---|
| `git-teacher-setup` | 1–2 | Install Git, connect GitHub, create project folder |
| `git-teacher-status` | — | Translate `git status` into plain Korean |
| `git-teacher-save` | 3 | Commit changes with a natural-language summary |
| `git-teacher-upload` | 4 | Push commits to GitHub |
| `git-teacher-review` | 5 | Create a pull request |
| `git-teacher-help` | — | Term glossary + FAQ using cloud analogies |

### Help system

The `git-teacher-help` skill answers questions like:

- "commit이 뭐야?" → one-line summary + Google Drive analogy
- "push랑 commit 차이?" → comparison table
- "Git 작업 흐름이 어떻게 돼?" → full flow diagram in plain language
- "fatal: not a git repository 이게 뭐야?" → translation + what to do next

---

## Requirements

- [Claude Code](https://docs.anthropic.com/claude-code) CLI
- Claude Max/Pro subscription or a supported Claude API key

No additional dependencies. No npm install. No build step.

---

## License

MIT — [fivetaku](https://github.com/fivetaku)

---

<div align="center">

**Git is not hard. It just needs a better teacher.**

</div>
