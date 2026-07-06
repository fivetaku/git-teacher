[English](README.md) | [한국어](README.ko.md) | 中文 | [日本語](README.ja.md) | [Español](README.es.md)

# git-teacher

<p align="center">
  <img src="assets/git-teacher-hero-01.png" alt="git-teacher" width="320">
</p>

> **为从来不想学 Git 的人准备的 Git 和 GitHub。**

不需要背命令，也不用知道“提交哈希”是什么。只要你用过 Google Drive，Git 的 80% 你其实已经会了——只是自己还不知道。

[快速开始](#快速开始) • [为什么选 git-teacher？](#为什么选-git-teacher) • [工作原理](#工作原理) • [功能](#功能) • [环境要求](#环境要求)

---

## 快速开始

### 1. 添加市场（只需一次）

```
/plugin marketplace add https://github.com/fivetaku/gptaku_plugins.git
```

### 2. 安装插件

```
/plugin install git-teacher
```

### 3. 重启 Claude Code

插件需要重启后才能加载。

### 4. 开始设置

```
/git-teacher 시작
```

或者直接说：`"깃 시작해줘"`（帮我开始用 Git）——插件能理解自然语言。

### 5. 跟着 5 步流程走

```
步骤 1 + 2: 准备       → 安装工具，创建项目文件夹（只需一次）
步骤 3: 保存           → "저장해줘"   （提交你的更改）
步骤 4: 上传           → "올려줘"    （推送到 GitHub）
步骤 5: 请求审查       → "검토 요청해줘"  （创建 Pull Request）
```

---

## 为什么选 git-teacher？

- **不用背命令** —— 用平常的话（韩语）说出你想做什么，剩下的交给插件
- **比喻先行的讲解** —— 每个概念都用 Google Drive、Dropbox、iCloud 来类比，没有开发者黑话
- **做过的自动跳过** —— 设置时会检测当前状态，只执行真正需要的步骤
- **翻译 Git 输出** —— 不再是 `fatal: not a git repository`，而是“이 폴더는 Git 프로젝트 폴더가 아니에요（这个文件夹不是 Git 项目文件夹）”
- **难点也能搞定** —— 合并冲突、detached HEAD、stash——用大白话讲清楚，并给出明确的选项

---

## 工作原理

Git 和 Google Drive 只有一个核心区别：**没有任何东西会自动同步**。每一次保存、每一次上传都是手动操作。明白了这一点，其余的就顺理成章。

```
你编辑了一个文件
       │
       ▼
  保存（Commit）           ← "저장해줘"
  把你的更改打包记录
  此时还只在你自己的电脑上
       │
       ▼
  上传（Push）             ← "올려줘"
  发送到 GitHub 云端
  现在别人也能看到了
       │
       ▼
  请求审查（PR）           ← "검토 요청해줘"
  “各位，来看看这个改动”
  类似 Google Docs 的建议模式
```

### 与 Google Drive 对比

| Google Drive | Git | 关键区别 |
|---|---|---|
| 安装应用 | 安装 Git + GitHub CLI | 相同 —— 都得先装个应用 |
| 用 Google 账号登录 | 连接 GitHub 账号 | 相同 —— 用云端就需要账号 |
| 创建共享文件夹 | 创建仓库（repository） | 相同 —— 一个存放文件的文件夹 |
| 文件自动同步 | **文件不会自动同步** | **这是最大的区别** |
| “建议编辑”模式 | Pull Request | 类似 —— “我改了这些，请过目” |

> 最重要的一点：Google Drive 会自动同步，Git 不会。你必须手动保存（commit）再上传（push）。忘了的话，你的工作就只留在自己的电脑上。

---

## 功能

### 命令

| 命令 | 作用 |
|---|---|
| `/git-teacher` | 打开菜单，选择要做的事 |
| `/git-teacher 시작` | 设置：安装工具 + 创建项目文件夹 |
| `/git-teacher 상태` | 状态：上次保存后改了什么？ |
| `/git-teacher 저장` | 保存：把更改提交到本地 |
| `/git-teacher 올리기` | 上传：把提交推送到 GitHub |
| `/git-teacher 검토` | 审查：创建 Pull Request |
| `/git-teacher 도움말` | 帮助：用类比解释任何 Git 术语 |

### 自然语言触发

不用斜杠命令也行，这些说法同样有效：

| 你想做的事 | 这样说 |
|---|---|
| 首次设置 | "깃 시작해줘"、"깃 설정"、"처음이에요" |
| 查看当前状态 | "지금 어떤 상태?"、"뭐가 바뀌었어?" |
| 保存更改（Commit） | "저장해줘"、"커밋"、"세이브" |
| 上传到 GitHub（Push） | "올려줘"、"푸시"、"업로드" |
| 请求审查（PR） | "PR 만들어줘"、"검토 요청해줘" |
| 询问术语 | "commit이 뭐야?"、"push랑 commit 차이" |

### 技能

| 技能 | 阶段 | 说明 |
|---|---|---|
| `git-teacher-setup` | 1–2 | 安装 Git、连接 GitHub、创建项目文件夹 |
| `git-teacher-status` | — | 把 `git status` 翻译成大白话 |
| `git-teacher-save` | 3 | 用自然语言摘要提交更改 |
| `git-teacher-upload` | 4 | 把提交推送到 GitHub |
| `git-teacher-review` | 5 | 创建 Pull Request |
| `git-teacher-help` | — | 术语表 + FAQ，全部用云盘类比 |

### 帮助系统

`git-teacher-help` 技能可以回答这样的问题：

- "commit이 뭐야?"（commit 是什么？） → 一句话总结 + Google Drive 类比
- "push랑 commit 차이?"（push 和 commit 的区别？） → 对比表格
- "Git 작업 흐름이 어떻게 돼?"（Git 的工作流程是怎样的？） → 用大白话讲完整流程
- "fatal: not a git repository 이게 뭐야?"（这是什么意思？） → 翻译 + 下一步该做什么

---

## 环境要求

- [Claude Code](https://docs.anthropic.com/claude-code) CLI
- Claude Max/Pro 订阅，或受支持的 Claude API 密钥

没有额外依赖，不用 npm install，没有构建步骤。

---

## 许可证

MIT — [fivetaku](https://github.com/fivetaku)

---

<div align="center">

**Git 并不难，它只是需要一位更好的老师。**

</div>
