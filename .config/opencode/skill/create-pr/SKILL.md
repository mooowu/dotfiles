---
name: create-pr
description: Analyze current branch changes, run quality checks (test, typecheck, build), and create a draft PR following the project's PR template
license: MIT
compatibility: opencode
metadata:
  workflow: github
  category: git
---

# Create Pull Request Skill

This skill helps you create a well-structured draft PR by analyzing your work and following project conventions.

## Prerequisites

- Git repository with a remote configured
- GitHub CLI (`gh`) installed and authenticated
- Current branch with commits ready for PR

## Workflow

### Step 1: Analyze Current Branch

1. Identify the base branch (usually `main` or `master`)
2. Run `git log <base>..HEAD --oneline` to list all commits
3. Run `git diff <base>..HEAD --stat` to see changed files summary
4. Run `git diff <base>..HEAD` to understand the actual changes
5. Summarize:
   - What features/fixes were implemented
   - Which files were modified/added/deleted
   - The overall purpose of the changes

### Step 2: Run Quality Checks

Before creating the PR, run the following checks to ensure code quality. Check `package.json` or project config files to determine available commands:

1. **Type Check** (if applicable):
   - `npm run typecheck` or `pnpm typecheck` or `yarn typecheck`
   - Or `npx tsc --noEmit` for TypeScript projects

2. **Lint** (if applicable):
   - `npm run lint` or equivalent

3. **Test**:
   - `npm test` or `pnpm test` or `yarn test`
   - Run relevant test suites for changed files

4. **Build**:
   - `npm run build` or equivalent
   - Ensure the project compiles successfully

If any check fails, report the issues and ask the user how to proceed before continuing.

### Step 3: Find PR Template

Search for PR template in these locations (in order):
1. `.github/pull_request_template.md`
2. `.github/PULL_REQUEST_TEMPLATE.md`
3. `docs/pull_request_template.md`
4. `pull_request_template.md`
5. `.github/PULL_REQUEST_TEMPLATE/` directory (multiple templates)

If a template is found, use it as the structure for the PR body.

### Step 4: Default PR Template

If no template is found, use this default structure:

```markdown
## Summary

<!-- Briefly describe what this PR does -->

## Changes

<!-- List the main changes -->
-

## Type of Change

<!-- Mark relevant items with [x] -->
- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to change)
- [ ] Refactoring (no functional changes)
- [ ] Documentation update
- [ ] Test update

## Testing

<!-- Describe how you tested these changes -->
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing performed

## Checklist

- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation accordingly
- [ ] My changes generate no new warnings
- [ ] Any dependent changes have been merged and published
```

### Step 5: Create Draft PR

1. Generate a concise, descriptive PR title based on the changes
2. Fill in the PR template with relevant information from your analysis
3. Push the current branch if not already pushed:
   ```bash
   git push -u origin <branch-name>
   ```
4. Create the draft PR using GitHub CLI:
   ```bash
   gh pr create --draft --title "<title>" --body "<body>"
   ```
5. Report the PR URL to the user

## Important Notes

- Always create PRs as **draft** to allow for review before marking ready
- If quality checks fail, inform the user and wait for instructions
- Use the exact PR template format from the project if available
- Keep the PR title concise (50-72 characters recommended)
- Reference any related issues using `#<issue-number>` or `Closes #<issue-number>`
- **Write PR title and body in Korean** (PR 제목과 본문은 한글로 작성)

## When to Use This Skill

Use this skill when:
- You have completed work on a feature branch
- You want to create a PR following project conventions
- You need to ensure code quality before submitting

## Example Usage

User: "Create a PR for my current changes"

The agent will:
1. Analyze commits and changes on the current branch
2. Run typecheck, lint, test, and build
3. Find or use default PR template
4. Create a draft PR with appropriate title and description
5. Return the PR URL
