---
name: create-issue
description: Analyze user request and project context, then create a GitHub issue following the project's issue template
license: MIT
compatibility: opencode
metadata:
  workflow: github
  category: git
---

# Create Issue Skill

This skill helps you create well-structured GitHub issues by analyzing user requests, understanding the project context, and following the project's issue template conventions.

## Prerequisites

- Git repository with a GitHub remote configured
- GitHub CLI (`gh`) installed and authenticated
- Understanding of the feature/bug being reported

## Workflow

### Step 1: Understand User Request

1. Analyze what the user wants to report or request:
   - Is it a bug report?
   - Is it a feature request?
   - Is it a documentation issue?
   - Is it a question or discussion?
2. Gather necessary details from the user if missing:
   - Expected behavior vs actual behavior (for bugs)
   - Use case and motivation (for features)
   - Steps to reproduce (for bugs)

### Step 2: Analyze Project Context

1. Understand the project structure and current implementation:
   - Review relevant source files related to the issue
   - Check existing related issues with `gh issue list`
   - Search for duplicate issues with `gh issue list -S "<keywords>"`
2. Identify:
   - Which components/modules are affected
   - Current implementation status
   - Potential impact of the issue

### Step 3: Find Issue Template

Search for issue templates in these locations (in order):

1. `.github/ISSUE_TEMPLATE/` directory (multiple templates)
   - `bug_report.md` or `bug_report.yml`
   - `feature_request.md` or `feature_request.yml`
   - `custom.md`
2. `.github/issue_template.md`
3. `.github/ISSUE_TEMPLATE.md`
4. `docs/issue_template.md`
5. `issue_template.md`

If templates are found, list available templates and select the appropriate one based on issue type.

### Step 4: Default Issue Templates

If no template is found, use one of these default structures:

#### Bug Report Template

```markdown
## Bug Description

<!-- A clear and concise description of what the bug is -->

## Steps to Reproduce

1.
2.
3.

## Expected Behavior

<!-- What you expected to happen -->

## Actual Behavior

<!-- What actually happened -->

## Environment

- OS:
- Version:
- Browser (if applicable):

## Additional Context

<!-- Any other context, screenshots, or logs -->
```

#### Feature Request Template

```markdown
## Feature Description

<!-- A clear and concise description of the feature -->

## Motivation

<!-- Why is this feature needed? What problem does it solve? -->

## Proposed Solution

<!-- How do you think this should be implemented? -->

## Alternatives Considered

<!-- Any alternative solutions or features you've considered -->

## Additional Context

<!-- Any other context, mockups, or examples -->
```

#### General Issue Template

```markdown
## Summary

<!-- Brief description of the issue -->

## Details

<!-- Detailed explanation -->

## Related Files/Components

<!-- List affected files or components -->

## Additional Context

<!-- Any other relevant information -->
```

### Step 5: Create Issue

1. Generate a concise, descriptive issue title
2. Fill in the template with:
   - User's request details
   - Project context analysis
   - Relevant code references
3. Add appropriate labels if known (e.g., `bug`, `enhancement`, `documentation`)
4. Create the issue using GitHub CLI:
   ```bash
   gh issue create --title "<title>" --body "<body>"
   ```
   Or with labels:
   ```bash
   gh issue create --title "<title>" --body "<body>" --label "bug"
   ```
5. Report the issue URL to the user

## Important Notes

- Check for duplicate issues before creating a new one
- **Write issue title and body in Korean**
- Use the exact issue template format from the project if available
- Keep the title concise but descriptive
- Include code references with file paths and line numbers when relevant
- Add reproduction steps for bugs
- Link related issues or PRs using `#<number>`

## When to Use This Skill

Use this skill when:
- User wants to report a bug in the project
- User wants to request a new feature
- User wants to document a task or improvement
- User needs help creating a well-structured issue

## Example Usage

User: "Create an issue for adding dark mode support"

The agent will:
1. Understand this is a feature request
2. Analyze current theming/styling implementation in the project
3. Check for existing dark mode related issues
4. Find or use default feature request template
5. Create the issue with detailed description
6. Return the issue URL

User: "The login button doesn't work on mobile, create an issue"

The agent will:
1. Understand this is a bug report
2. Analyze the login component implementation
3. Find or use default bug report template
4. Create the issue with reproduction steps
5. Return the issue URL
