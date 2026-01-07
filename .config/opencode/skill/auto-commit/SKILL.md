---
name: auto-commit
description: Automatically analyze all uncommitted changes and create multiple atomic commits grouped by logical purpose
compatibility: opencode
metadata:
  category: git
  workflow: commit
---

## Purpose

Analyze all uncommitted changes (staged + unstaged) and automatically create multiple atomic commits, each representing a single logical unit of change.

## When to Use

- After a long coding session with many scattered changes
- Before pushing when working directory has accumulated changes
- User wants hands-off commit organization
- Changes span multiple features/fixes/refactors

## Workflow

### Step 1: Capture All Changes

```bash
git status
git diff --stat
git diff
git diff --cached --stat
git diff --cached
```

### Step 2: Analyze and Group

Classify every change into logical groups:

| Type | Prefix | Priority | Examples |
|------|--------|----------|----------|
| Breaking | `feat!:` / `fix!:` | 1 | API changes, schema migrations |
| Feature | `feat:` | 2 | New functionality |
| Fix | `fix:` | 3 | Bug fixes |
| Refactor | `refactor:` | 4 | Code restructuring |
| Perf | `perf:` | 5 | Performance improvements |
| Test | `test:` | 6 | Test additions/modifications |
| Docs | `docs:` | 7 | Documentation |
| Style | `style:` | 8 | Formatting, whitespace |
| Chore | `chore:` | 9 | Config, dependencies, build |

### Step 3: Determine Commit Order

Order commits by:
1. **Dependencies** - Base changes before dependent changes
2. **Priority** - Lower priority number first (breaking → chore)
3. **Scope** - Core/shared code before feature-specific

### Step 4: Present Plan

```
## Auto-Commit Plan

Total: N commits from M changed files

### 1. fix: resolve null pointer in user service
Files: src/services/user.ts (+5 -3)
Reason: Bug fix should be isolated

### 2. feat: add email verification flow
Files:
- src/auth/verify.ts (new)
- src/routes/auth.ts (+45 -2)
- src/types/auth.ts (+12)
Reason: Related feature files grouped

### 3. refactor: extract validation utils
Files:
- src/utils/validation.ts (new)
- src/services/user.ts (+2 -15)
- src/services/order.ts (+2 -18)
Reason: Refactor is independent of features

### 4. test: add verification flow tests
Files: src/__tests__/verify.test.ts (new)
Reason: Tests follow implementation

### 5. chore: update dependencies
Files: package.json, package-lock.json
Reason: Dependency updates isolated

---
Execute all commits? (y/n/modify)
```

### Step 5: Execute (after approval)

```bash
# Stash any untracked files if needed
git stash -u

# For each commit group:
git add <files>
git commit -m "<type>: <description>"

# Restore stash if used
git stash pop
```

### Step 6: Verify

```bash
git log --oneline -n <number_of_commits>
git status
```

## Rules

1. **Always present plan first** - Never auto-execute without showing the plan
2. **Atomic commits** - Each commit compiles/runs independently
3. **No partial file splits by default** - Keep files whole unless explicitly complex
4. **Preserve working state** - Ensure no changes are lost
5. **Follow project conventions** - Check existing commit history for style

## Handling Complex Files

When a single file has multiple unrelated changes:

1. Flag it in the plan:
   ```
   ### Commit 2: feat: add caching
   Files:
   - src/api/client.ts (PARTIAL - lines 50-80: caching logic)
   ⚠️ This file also contains changes for Commit 4
   ```

2. Use `git add -p` for surgical staging

## Handling Dependencies

If changes have dependencies:

```
### Commit 1: refactor: extract base class
Files: src/base/entity.ts (new)
↓ REQUIRED BY Commit 2, 3

### Commit 2: feat: user entity extends base
Files: src/entities/user.ts
↑ DEPENDS ON Commit 1
```

## Error Recovery

```bash
# If interrupted mid-execution
git reflog
git reset --soft HEAD~<N>  # N = commits made so far
git status  # Verify all changes restored
```

## Difference from split-commit

| split-commit | auto-commit |
|--------------|-------------|
| Works on already staged changes | Works on ALL uncommitted changes |
| User pre-selected what to commit | Agent analyzes everything |
| Focuses on splitting | Focuses on organizing + committing |
| More surgical | More automated |

## Example Session

Working directory has: bug fix + new feature + updated tests + config change

```
## Auto-Commit Plan

Total: 4 commits from 8 changed files

### 1. fix: handle edge case in payment calculation
Files: src/services/payment.ts (+8 -2)

### 2. feat: add subscription billing support
Files:
- src/billing/subscription.ts (new, +145)
- src/types/billing.ts (+23)
- src/routes/billing.ts (+67 -5)

### 3. test: add subscription billing tests
Files:
- src/__tests__/subscription.test.ts (new, +89)
- src/__tests__/payment.test.ts (+12 -3)

### 4. chore: add stripe sdk dependency
Files: package.json (+1), package-lock.json

---
Execute all commits? (y/n/modify)
