---
name: sync-issue
description: Compare PR changes with linked documents (GitHub Issues, Notion) and sync missing or changed content from code to documents
license: MIT
compatibility: opencode
metadata:
  workflow: github
  category: documentation
---

# Sync Issue Skill

This skill compares PR work with linked documents (GitHub Issues, Notion, etc.) and reflects missing or changed content to the documents.

**Code is the source of truth** - documents reflect the code changes.

## Prerequisites

- Git repository with a GitHub remote configured
- GitHub CLI (`gh`) installed and authenticated
- Notion MCP connected (for Notion document sync)
- Current branch with a PR created

## Workflow

### Step 1: Discover PR Information and Linked Documents

1. Get current branch's PR information:
   ```bash
   # Get PR basic info and body
   gh pr view --json number,title,body,url,state

   # Get GitHub-parsed linked issues
   gh pr view --json closingIssuesReferences --jq '.closingIssuesReferences[].number'
   ```

2. Extract additional links from PR body:

   **GitHub Issue Patterns:**
   - `Fixes #123`, `Closes #456`, `Resolves #789`
   - `#123` (simple reference)
   - `owner/repo#123` (cross-repository reference)
   - `https://github.com/owner/repo/issues/123`

   **Notion Document Patterns:**
   - `https://www.notion.so/...`
   - `https://notion.so/...`
   - `https://www.notion.so/workspace/Page-Title-{32-char-id}`

   **Notion ID Regex:**
   ```regex
   [0-9a-f]{8}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{12}
   ```

3. Organize discovered documents:
   ```
   Linked Documents:
   - GitHub Issue #123: [Issue Title]
   - Notion: [Page Title] (URL)
   ```

### Step 2: Read Document Contents

#### Reading GitHub Issues

```bash
# Get issue details
gh issue view <issue-number> --json title,body,labels,state,comments

# Extract issue body only
gh issue view <issue-number> --json body --jq '.body'
```

#### Reading Notion Documents

Read document contents via Notion MCP:

```
# Verify Notion MCP connection
# MCP URL: https://mcp.notion.com/mcp

# Query page content (using MCP tools)
notion_get_page(page_id="<page-id>")
notion_search(query="<page-title>")
```

**Notes:**
- Notion MCP connection is required
- Only pages within user's permission scope are accessible
- Page ID is extracted from URL (32-char hex or UUID with hyphens)

### Step 3: Analyze PR Changes

1. Analyze all commits in the PR:
   ```bash
   # Get base branch
   BASE_BRANCH=$(gh pr view --json baseRefName --jq '.baseRefName')

   # List commits
   git log $BASE_BRANCH..HEAD --oneline

   # Changed files summary
   git diff $BASE_BRANCH..HEAD --stat

   # Detailed changes
   git diff $BASE_BRANCH..HEAD
   ```

2. Classify changes:
   | Category | Description |
   |----------|-------------|
   | **Feature Addition** | New features, APIs, components |
   | **Bug Fix** | Fixes to existing behavior |
   | **Refactoring** | Code improvements without behavior change |
   | **Configuration** | Environment settings, dependency changes |
   | **Documentation** | README, comments, etc. |

3. Summarize key changes:
   - What problem was solved?
   - How was it implemented?
   - What is the impact on users?
   - Any caveats or limitations?

### Step 4: Compare and Sync Documents with Code

#### 4.1 Comparison Analysis

Compare documents with code to identify:

| Status | Description | Action |
|--------|-------------|--------|
| **Missing** | Exists in code but not in document | Auto-add |
| **Match** | Code and document content are identical | No change |
| **Mismatch** | Code and document content differ | **User confirmation required** |
| **Document Only** | Exists in document but not in code | **User confirmation required** |

#### 4.2 Auto-add Missing Content

Content implemented in code but missing from documents is added automatically:

**GitHub Issue Update:**
```bash
# Add comment to issue
gh issue comment <issue-number> --body "$(cat <<'EOF'
## Implementation Complete

The following was implemented in PR #<pr-number>:

### Added Features
- [Feature 1 description]
- [Feature 2 description]

### Implementation Details
- [Detail 1]
- [Detail 2]

### Notes
- [Notes]
EOF
)"
```

**Notion Document Update:**
```
# Update page via Notion MCP
notion_append_block(page_id="<page-id>", content="<new-content>")
notion_update_block(block_id="<block-id>", content="<updated-content>")
```

#### 4.3 User Confirmation for Mismatches

When code and document content differ, user confirmation is **required**:

```markdown
## Mismatch Detected

The following items have different content between code and document:

### 1. [Item Name]

**Document Content:**
> [Content stated in document]

**Code Implementation:**
> [Actual implementation in code]

**Difference:**
- [Difference description]

---

**Options:**
1. Update document based on code (recommended)
2. Keep current document
3. Enter custom content

How would you like to proceed?
```

### Step 5: Report Changes

Report results after sync completion:

```markdown
## Document Sync Complete

### Updated Documents
- GitHub Issue #123: Added implementation complete comment
- Notion: [Page Name] - Updated feature list

### Added Content
1. [Added content 1]
2. [Added content 2]

### Modified After User Confirmation
1. [Modified content 1]

### No Changes
- [Unchanged items]
```

## Command Reference

### GitHub CLI Commands

```bash
# PR information
gh pr view --json number,title,body,url,state,baseRefName
gh pr view --json closingIssuesReferences

# Issue information
gh issue view <number> --json title,body,labels,state
gh issue comment <number> --body "<content>"

# Edit issue body (caution: overwrites existing content)
gh issue edit <number> --body "<new-body>"

# Add label to issue
gh issue edit <number> --add-label "documentation"
```

### Link Extraction Patterns

```bash
# Extract issue numbers from PR body
PR_BODY=$(gh pr view --json body --jq '.body')
LINKED_ISSUES=$(echo "$PR_BODY" | grep -oEi '(closes?|fixes?|resolves?) ?#[0-9]+' | grep -oE '[0-9]+' | sort -u)

# Extract Notion URLs
NOTION_URLS=$(echo "$PR_BODY" | grep -oE 'https?://(www\.)?notion\.so/[^ ]+')
```

### Notion URL Parsing

```javascript
// Notion Page ID extraction regex
const notionIdRegexp = /[0-9a-f]{8}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{12}/i;

// Extract Page ID from URL
function extractNotionPageId(url) {
  const match = url.match(notionIdRegexp);
  return match ? match[0].replace(/-/g, '') : null;
}
```

## Important Notes

- **Code is the source of truth**: Always update documents based on code changes
- **User confirmation for mismatches**: Must confirm with user when document and code differ
- **Notion MCP required**: Notion MCP connection is required for Notion document sync
- **Check permissions**: Verify document edit permissions before proceeding
- **Preserve history**: When possible, add update sections instead of deleting existing content
- **Write in Korean**: Document update content should be written in Korean

## Supported Document Types

| Document Type | Read | Write | Notes |
|---------------|------|-------|-------|
| GitHub Issue | ✅ | ✅ (comment) | Uses `gh` CLI |
| GitHub Issue Body | ✅ | ⚠️ | Body edit overwrites - use caution |
| Notion Page | ✅ | ✅ | Requires Notion MCP |
| Notion Database | ✅ | ✅ | Requires Notion MCP |

## When to Use This Skill

Use this skill when:
- You want to reflect results to linked issues/documents after completing PR work
- You want to verify that code changes and documents are consistent
- You want to sync multiple documents (Issue, Notion) at once
- You want to automate document updates

## Example Usage

### Example 1: Sync Issues After PR Completion

User: "Sync the issues linked to the current PR"

The agent will:
1. Discover PR body and linked issues
2. Read linked GitHub Issue contents
3. Analyze PR code changes
4. Add missing implementation content as comments to issues
5. Report results

### Example 2: Sync Including Notion Documents

User: "Sync PR #45 with the linked Notion documents"

The agent will:
1. Extract Notion URLs from PR #45 body
2. Read document content via Notion MCP
3. Compare code changes with documents
4. Add missing content, confirm with user for mismatches
5. Report change results

### Example 3: When Mismatch is Found

User: "Compare issues with code"

The agent will:
1. Compare linked issues with code
2. When mismatch is found:
   ```
   ## Mismatch Detected

   ### API Response Format

   **Issue Content:**
   > Response returns as JSON array

   **Code Implementation:**
   > Response returns as pagination object (includes items, totalCount, hasNext)

   Would you like to update the issue based on code?
   ```
3. Process according to user response

## Error Handling

| Error Situation | Handling |
|-----------------|----------|
| No PR exists | Inform "No PR is linked to the current branch" |
| No linked documents | Inform "No linked documents found in PR body" |
| Notion access failed | Inform "Please check Notion MCP connection" |
| Insufficient permissions | Inform "You don't have permission to edit this document" |
| Issue not found | Inform "Issue #N not found" |
