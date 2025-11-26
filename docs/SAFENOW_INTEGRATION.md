# SafeNow Integration

This repository includes integration with SafeNow API for consent management and automated PR workflows.

## Overview

The SafeNow integration provides:
1. Testing of SafeNow consent API endpoints
2. Automated GitHub Pull Request creation
3. Automated Pull Request merging

## Usage

### GitHub Actions Workflow

The SafeNow integration is available as a GitHub Actions workflow that can be triggered manually.

#### Triggering the Workflow

1. Go to the **Actions** tab in the GitHub repository
2. Select **SafeNow Integration** from the workflow list
3. Click **Run workflow**
4. Configure the following optional parameters:
   - `user_id`: User ID for SafeNow consent request (default: `12345`)
   - `doc_id`: Document ID for SafeNow consent request (default: `doc_9876`)
   - `feature_branch`: Feature branch to merge (default: `feature/safenow-integration`)
   - `base_branch`: Base branch to merge into (default: `main`)
   - `pr_title`: Pull Request title (default: `Merge SafeNow Integration`)
   - `pr_body`: Pull Request body (default: `Automated PR via API for SafeNow integration.`)

#### Required Secrets

The workflow requires the following secrets to be configured in the repository:

- `SAFENOW_API_KEY`: API key for SafeNow service authentication

The workflow uses the built-in `GITHUB_TOKEN` secret for GitHub API operations.

### Local Script

You can also run the SafeNow integration script locally:

```bash
# Set required environment variables
export SAFENOW_API_KEY="your-safenow-api-key"
export GITHUB_TOKEN="your-github-token"

# Run the script
./scripts/safenow-integration.sh
```

#### Optional Environment Variables

You can customize the script behavior with these environment variables:

```bash
export FEATURE_BRANCH="feature/my-feature"  # Default: feature/safenow-integration
export BASE_BRANCH="develop"                # Default: main
export REPO="owner/repository"              # Default: FutureWealthBot/SafeNow
export USER_ID="user123"                    # Default: 12345
export DOC_ID="doc_abc"                     # Default: doc_9876
export PR_TITLE="My Custom PR Title"        # Default: Merge SafeNow Integration
export PR_BODY="Custom PR description"      # Default: Automated PR via API for SafeNow integration.
```

## Workflow Steps

The SafeNow integration performs the following steps:

### 1. Test SafeNow Consent API

Makes a POST request to the SafeNow API endpoint:
```
POST https://api.safenow.futurewealthbot.com/consent/request
```

Request payload:
```json
{
  "user_id": "string",
  "purpose": "financial_analysis",
  "document_ids": ["string"]
}
```

### 2. Create GitHub Pull Request

Creates a new Pull Request or identifies an existing one:
- Checks if a PR already exists for the feature branch
- Creates a new PR if one doesn't exist
- Uses the specified title and body for the PR

### 3. Merge Pull Request

Automatically merges the Pull Request:
- Uses the "merge" method (creates a merge commit)
- Uses the PR title as the commit message

## Error Handling

The script includes error handling for:
- Missing required environment variables
- Failed API requests to SafeNow
- Failed PR creation
- Failed PR merge operations

All errors will cause the script to exit with a non-zero status code.

## Security Considerations

- Never commit API keys or tokens to the repository
- Use GitHub Secrets for storing sensitive credentials
- The `GITHUB_TOKEN` used in workflows has limited permissions scoped to the repository
- Ensure the SafeNow API key has minimal required permissions

## Troubleshooting

### SafeNow API Errors

If the SafeNow API request fails:
1. Verify your `SAFENOW_API_KEY` is valid
2. Check that the API endpoint is accessible
3. Ensure the request payload matches the API requirements

### PR Creation Errors

If PR creation fails:
1. Verify the feature branch exists
2. Check that the base branch exists
3. Ensure your `GITHUB_TOKEN` has `repo` permissions
4. Verify there are actual changes between the branches

### PR Merge Errors

If PR merge fails:
1. Check if the PR has merge conflicts
2. Verify branch protection rules don't prevent merging
3. Ensure required status checks have passed (if configured)
