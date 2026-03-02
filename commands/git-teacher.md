---
name: git-teacher
description: "바르다 깃선생 — Git/GitHub를 쉽게 도와주는 명령어"
argument-hint: "[시작|상태|저장|올리기|검토|도움말]"
allowed-tools:
  - Bash
  - Read
---

# /git-teacher Command

비개발자를 위한 Git/GitHub 도우미. 인자에 따라 적절한 스킬로 분기한다.

## Parse Arguments

| 인자 | 동작 | 해당 스킬 |
|------|------|----------|
| `시작`, `setup`, `설정` | Git 설치 + GitHub 연결 + 폴더 만들기 | git-teacher-setup |
| `상태`, `status` | 현재 상태 한국어로 보기 | git-teacher-status |
| `저장`, `save`, `커밋`, `commit` | 변경 내용 저장 | git-teacher-save |
| `올리기`, `upload`, `푸시`, `push` | GitHub에 올리기 | git-teacher-upload |
| `검토`, `review`, `PR`, `pr` | 검토 요청(Pull Request) 만들기 | git-teacher-review |
| `도움말`, `help`, `?` | 용어 설명 + FAQ | git-teacher-help |
| (인자 없음) | 안내 메시지 출력 후 선택 | 아래 참조 |

## 인자 없이 실행한 경우

**EXECUTE:** 아래 JSON으로 AskUserQuestion 도구를 즉시 호출한다:

```json
{
  "questions": [{
    "question": "바르다 깃선생이에요. 뭘 도와드릴까요?",
    "header": "깃선생",
    "options": [
      {"label": "시작", "description": "Git 설치 + 프로젝트 폴더 만들기 (처음 한 번만 하면 돼요)"},
      {"label": "상태", "description": "지금 어떤 파일이 바뀌었는지 확인"},
      {"label": "저장", "description": "변경 내용을 내 컴퓨터에 저장"},
      {"label": "올리기", "description": "저장한 내용을 GitHub 클라우드에 올리기"}
    ],
    "multiSelect": false
  }]
}
```

> "검토"와 "도움말"은 Other를 통해 입력할 수 있다.

## Execute

인자를 파악한 뒤, 해당 스킬의 실행 순서를 그대로 따른다.
스킬 내용은 `${CLAUDE_PLUGIN_ROOT}/skills/` 하위의 각 SKILL.md를 참조한다.
