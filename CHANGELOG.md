# Changelog

## 1.5.3 — 2026-06-21

- The GitHub-star prompt is now shown in the user's current language instead of hardcoded Korean.
- GitHub star is now **opt-in** — on first run the command asks once via AskUserQuestion (`네, ⭐ 눌러주기` / `아니요`) instead of auto-starring. The star logic moved into `setup.sh` and records the choice (`~/.gptaku-setup/<plugin>.star.json`) so it never re-asks. `setup.sh` no longer stars anything automatically.
- Fixed: rebase conflict resolution had `ours`/`theirs` mapped backwards. In a rebase `--ours` is the upstream side and `--theirs` is your replayed commit, so '내 거 유지' now correctly uses `--theirs`.

## [1.4.1] - 2026-05-04

### Changed
- `git-teacher-help/references/gotchas.md` — "흔한 실수 예시"임을 명시, 도메인별 추가 가능 (user override)
- `git-teacher-help/SKILL.md` 응답 규칙 — 질문 유형은 흔한 패턴 예시, 다중 분류 허용, 카탈로그에 없는 새 유형은 generic 응답

### Preserved (vibe-sunsang 패턴 — 결정+멘토링 둘 다 정당)
- Git 명령 시퀀스 (결정 contract)
- 클라우드 비유 멘토링 톤 (도메인 본질)
- glossary.md / aliases.md (참조 데이터)

## [1.4.0] - 2026-03-18

### Added
- Gotchas 레퍼런스 추가: 비개발자가 자주 겪는 Git 함정 7가지 (Push 거절, .gitignore 추적, 빈 폴더, 100MB 제한, Merge Conflict 용어, Stash 설명)
  - `skills/git-teacher-help/references/gotchas.md` 신규 생성
  - SKILL.md References 섹션에 gotchas.md 참조 추가

## [1.2.0] - 2026-02-25

### Changed
- CCPS v2.0 호환: 스킬 확장

## [1.1.0] - 2026-02-23

### Added
- `/git-teacher` 슬래시 커맨드 추가

### Fixed
- 설치 안내 명확화 (마켓플레이스 + 설치 분리)

## [1.0.0] - 2026-02-22

### Added
- 최초 릴리스
- Git 학습용 인터랙티브 교육 스킬
