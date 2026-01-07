---
name: split-commit
description: Analyze staged changes containing multiple purposes and split them into separate atomic commits by logical change unit
compatibility: opencode
metadata:
  category: git
  workflow: commit
---

## Purpose

Split a single set of staged changes into multiple atomic commits, each with a single purpose/responsibility.

## When to Use

- Staged changes contain multiple unrelated modifications
- A single `git add .` captured changes that should be separate commits
- Code review feedback requires splitting a large commit
- User explicitly requests commit splitting

## Workflow

### Step 1: Analyze Current State

```bash
git status
git diff --cached --stat
git diff --cached
```

Identify:
- Which files are staged
- What types of changes exist (feature, fix, refactor, docs, test, chore)
- Logical groupings by purpose

### Step 2: Classify Changes

Group changes into logical units:

| Category | Examples |
|----------|----------|
| Feature | New functionality, new files for a feature |
| Fix | Bug fixes, error handling corrections |
| Refactor | Code restructuring without behavior change |
| Docs | README, comments, documentation |
| Test | Test files, test utilities |
| Chore | Config, dependencies, build scripts |
| Style | Formatting, whitespace, naming |

### Step 3: Present Analysis to User

Format:
```
## Proposed Commit Split

### Commit 1: [type] [brief description]
Files:
- path/to/file1.ts (lines X-Y: reason)
- path/to/file2.ts

### Commit 2: [type] [brief description]
Files:
- path/to/file3.ts
- path/to/file4.ts

---
Proceed with this split? (y/n/modify)
```

### Step 4: Execute Split (after user approval)

For each commit group:

```bash
# Unstage everything first
git reset HEAD

# Stage files for commit 1
git add <file1> <file2>
# Or for partial file staging:
git add -p <file>

# Commit
git commit -m "<type>: <description>"

# Repeat for remaining groups
```

### Step 5: Verify

```bash
git log --oneline -n <number_of_commits>
git status
```

## Rules

1. **NEVER auto-execute** - Always present analysis and wait for user approval
2. **Preserve all changes** - No modifications lost during split
3. **Atomic commits** - Each commit should be independently meaningful
4. **Conventional commits** - Follow project's commit message convention if exists
5. **Order matters** - Commits should be ordered logically (dependencies first)

## Partial File Splitting

When a single file contains multiple change purposes:

1. Use `git diff --cached <file>` to show hunks
2. Identify which hunks belong to which purpose
3. Use `git add -p <file>` or `git add --patch` for interactive staging
4. Stage only relevant hunks per commit

## Error Recovery

If something goes wrong mid-split:

```bash
# Check reflog
git reflog

# Reset to before split started
git reset --soft <commit-before-split>

# Re-stage everything
git add .
```

## Example Session

User has staged: auth feature + unrelated typo fix + config update

```
## Proposed Commit Split

### Commit 1: fix: correct typo in error message
Files:
- src/utils/errors.ts (line 42: "recieved" -> "received")

### Commit 2: chore: update eslint config
Files:
- .eslintrc.json

### Commit 3: feat: add JWT authentication
Files:
- src/auth/jwt.ts (new file)
- src/auth/middleware.ts (new file)
- src/routes/auth.ts (modified)
- src/types/auth.ts (new file)

---
Proceed with this split? (y/n/modify)
```
