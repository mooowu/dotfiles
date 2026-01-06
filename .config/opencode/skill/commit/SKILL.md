---
name: commit
description: Analyze staged changes and create a commit with a message following the project's existing commit message conventions
license: MIT
compatibility: opencode
metadata:
  workflow: git
  category: git
---

# Commit Skill

This skill helps you create well-structured commits by analyzing staged changes and following the project's commit message conventions.

## Prerequisites

- Git repository initialized
- Changes staged with `git add`

## Workflow

### Step 1: Check Staged Changes

1. Run `git status` to verify there are staged changes
2. If no staged changes exist, inform the user and stop
3. Run `git diff --cached` to see the actual staged changes
4. Run `git diff --cached --stat` to get a summary of changed files

### Step 2: Analyze Existing Commit Style

1. Run `git log --oneline -20` to see recent commit messages
2. Identify the commit message format used in the project:
   - Conventional Commits (e.g., `feat:`, `fix:`, `chore:`)
   - Gitmoji style (e.g., with emojis)
   - Simple descriptive messages
   - Issue/ticket prefixes (e.g., `[JIRA-123]`)
3. Note common patterns:
   - Case style (lowercase, sentence case, etc.)
   - Message length
   - Use of scope (e.g., `feat(api):`)

### Step 3: Draft Commit Message

Based on the analysis, create a commit message following these rules:

1. **Prefix**: Keep prefixes in English (e.g., `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `test:`, `style:`, `perf:`, `ci:`, `build:`)
2. **Subject and Body**: Write in Korean
3. **Format**: Follow the project's existing commit message format

Common prefix meanings:
| Prefix | Description |
|--------|-------------|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `chore:` | Maintenance tasks, dependencies |
| `refactor:` | Code refactoring without behavior change |
| `docs:` | Documentation changes |
| `test:` | Adding or updating tests |
| `style:` | Code style changes (formatting, etc.) |
| `perf:` | Performance improvements |
| `ci:` | CI/CD changes |
| `build:` | Build system changes |

### Step 4: Create Commit

1. Present the drafted commit message to the user for confirmation
2. If approved, run:
   ```bash
   git commit -m "<subject>" -m "<body>"
   ```
   Or for simple commits:
   ```bash
   git commit -m "<message>"
   ```
3. Report the commit hash to the user

## Important Notes

- Only commit staged changes (do not use `git add` unless explicitly requested)
- **Write commit message subject and body in Korean, except for the prefix**
- Follow the project's existing commit message style
- Keep the subject line concise (50-72 characters recommended)
- Use the body for additional context if needed
- If the staged changes are unrelated, suggest splitting into multiple commits

## Commit Message Examples

```
feat: 사용자 인증 기능 추가

OAuth2.0 기반의 소셜 로그인 기능을 구현했습니다.
- Google, GitHub 로그인 지원
- 토큰 갱신 로직 포함
```

```
fix: 장바구니 수량 계산 오류 수정
```

```
chore: 의존성 패키지 업데이트
```

```
refactor(api): 에러 핸들링 로직 개선

중복되던 에러 처리 코드를 미들웨어로 통합했습니다.
```

## When to Use This Skill

Use this skill when:
- You have staged changes ready to commit
- You want to create a commit following project conventions
- You need help writing a descriptive commit message in Korean

## Example Usage

User: "Commit my staged changes"

The agent will:
1. Check and analyze staged changes
2. Review existing commit message style in the project
3. Draft a commit message (prefix in English, description in Korean)
4. Create the commit after user confirmation
5. Report the commit hash
