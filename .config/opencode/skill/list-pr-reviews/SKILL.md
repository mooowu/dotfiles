---
name: list-pr-reviews
description: Fetch and display all review comments from a specified GitHub PR in a structured list format
license: MIT
compatibility: opencode
metadata:
  workflow: github
  category: git
---

# List PR Reviews Skill

This skill fetches all reviews and review comments from a specified GitHub PR and displays them in a clear, organized list format.

## Prerequisites

- Git repository with a GitHub remote configured
- GitHub CLI (`gh`) installed and authenticated
- PR number or URL to analyze

## Workflow

### Step 1: Identify Target PR

1. Parse the user's input to extract:
   - PR number (e.g., `123`, `#123`)
   - PR URL (e.g., `https://github.com/owner/repo/pull/123`)
   - Or use current branch's PR if no input provided
2. Validate the PR exists:
   ```bash
   gh pr view <pr-number> --json number,title,state
   ```

### Step 2: Fetch Review Data

Fetch comprehensive review information using GitHub CLI:

```bash
# Fetch reviews (approval status, reviewer comments)
gh pr view <pr-number> --json reviews,latestReviews,comments,reviewDecision

# For detailed review comments on specific lines
gh api repos/{owner}/{repo}/pulls/<pr-number>/comments
```

### Step 3: Categorize Reviews

Organize reviews by type:

| Category | Description |
|----------|-------------|
| **APPROVED** | Reviewer approved the changes |
| **CHANGES_REQUESTED** | Reviewer requested changes |
| **COMMENTED** | Reviewer left comments without approval/rejection |
| **PENDING** | Review in progress |
| **DISMISSED** | Review was dismissed |

### Step 4: Format and Display

Present reviews in this structured format:

```markdown
## PR #<number>: <title>

**Status**: <state> | **Review Decision**: <reviewDecision>

---

### Reviews Summary

| Reviewer | State | Submitted At |
|----------|-------|--------------|
| @user1 | APPROVED | 2024-01-15 10:30 |
| @user2 | CHANGES_REQUESTED | 2024-01-15 11:45 |

---

### Review Details

#### 1. @user1 - APPROVED (2024-01-15 10:30)
> Review comment body here...

#### 2. @user2 - CHANGES_REQUESTED (2024-01-15 11:45)
> Review comment body here...

---

### Inline Comments (Code Review)

#### File: `src/components/Button.tsx`

**Line 42** - @user2 (2024-01-15 11:50)
> Consider using a more descriptive variable name here.

**Line 87** - @user2 (2024-01-15 11:52)
> This function could be simplified using optional chaining.

---

### General Comments

1. **@user3** (2024-01-15 12:00)
   > Great work overall! Just a few minor suggestions.

2. **@user1** (2024-01-15 12:30)
   > All issues have been addressed. LGTM!
```

### Step 5: Additional Options

Support filtering and sorting options:

```bash
# Filter by reviewer
gh api repos/{owner}/{repo}/pulls/<pr-number>/reviews | jq '.[] | select(.user.login == "<username>")'

# Filter by state
gh api repos/{owner}/{repo}/pulls/<pr-number>/reviews | jq '.[] | select(.state == "CHANGES_REQUESTED")'

# Sort by date (newest first)
gh api repos/{owner}/{repo}/pulls/<pr-number>/reviews | jq 'sort_by(.submitted_at) | reverse'
```

## Command Reference

### Core Commands

```bash
# Get PR basic info
gh pr view <pr-number> --json number,title,state,url

# Get all reviews
gh pr view <pr-number> --json reviews

# Get latest review per reviewer
gh pr view <pr-number> --json latestReviews

# Get review decision (overall status)
gh pr view <pr-number> --json reviewDecision

# Get general comments (not code-specific)
gh pr view <pr-number> --json comments

# Get inline/code review comments via API
gh api repos/{owner}/{repo}/pulls/<pr-number>/comments

# Get reviews with full details via API
gh api repos/{owner}/{repo}/pulls/<pr-number>/reviews
```

### JSON Field Descriptions

| Field | Description |
|-------|-------------|
| `reviews` | All review submissions with state and body |
| `latestReviews` | Most recent review from each reviewer |
| `reviewDecision` | Overall decision: APPROVED, CHANGES_REQUESTED, REVIEW_REQUIRED |
| `comments` | General PR comments (not inline code comments) |

## Important Notes

- Display all information in Korean for descriptions, keep technical terms in English
- Always show the PR title and status for context
- Group inline comments by file for better readability
- Show timestamps in a human-readable format
- Indicate resolved vs unresolved comments when available
- For large PRs with many comments, consider pagination or summarization

## When to Use This Skill

Use this skill when:
- You need to see all feedback on a specific PR
- You want to understand what changes reviewers requested
- You're preparing to address review comments
- You want a quick overview of PR review status
- You need to track reviewer participation

## Example Usage

User: "Show me the reviews on PR #123"

The agent will:
1. Fetch PR #123 information
2. Retrieve all reviews and comments
3. Categorize by reviewer and status
4. Display in structured list format

User: "What changes were requested on this PR?"

The agent will:
1. Identify the current branch's PR (or ask for PR number)
2. Filter for CHANGES_REQUESTED reviews
3. List all requested changes with context

User: "List all review comments from @username on PR #456"

The agent will:
1. Fetch reviews for PR #456
2. Filter by the specified reviewer
3. Display only that reviewer's comments

## Output Examples

### Compact Summary

```
## PR #123: Add user authentication feature

Status: OPEN | Decision: CHANGES_REQUESTED

Reviewers:
- @alice: APPROVED (2024-01-15)
- @bob: CHANGES_REQUESTED (2024-01-15)
  - "Please add error handling for invalid tokens"
  - "Consider using environment variables for secrets"
- @charlie: COMMENTED (2024-01-14)
  - "Looks good, but needs tests"

Inline Comments: 5 (3 resolved, 2 pending)
```

### Detailed View

```
## PR #123: Add user authentication feature

### Review: @bob - CHANGES_REQUESTED

**Overall Comment:**
> The implementation looks solid, but there are a few security concerns that need to be addressed before we can merge.

**Inline Comments:**

1. `src/auth/token.ts:42`
   > Please add try-catch block here to handle JWT decode failures gracefully.

2. `src/auth/config.ts:15`
   > Hardcoded secrets should be moved to environment variables.

3. `src/auth/middleware.ts:28` [RESOLVED]
   > Consider adding rate limiting to prevent brute force attacks.

   **Resolution by @author:**
   > Added rate limiting in commit abc123
```
