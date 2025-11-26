#!/bin/bash
set -e

# SafeNow Integration Script
# This script tests the SafeNow API, creates a GitHub PR, and merges it.
# 
# Required environment variables:
# - SAFENOW_API_KEY: API key for SafeNow service
# - GITHUB_TOKEN: GitHub personal access token with repo permissions
#
# Optional environment variables:
# - FEATURE_BRANCH: Feature branch to merge (default: feature/safenow-integration)
# - BASE_BRANCH: Base branch to merge into (default: main)
# - REPO: GitHub repository (default: FutureWealthBot/SafeNow)
# - USER_ID: User ID for SafeNow consent request (default: 12345)
# - DOC_ID: Document ID for SafeNow consent request (default: doc_9876)
# - PR_TITLE: Pull Request title (default: Merge SafeNow Integration)
# - PR_BODY: Pull Request body (default: Automated PR via API for SafeNow integration.)

# -----------------------------
# Configuration
# -----------------------------
FEATURE_BRANCH="${FEATURE_BRANCH:-feature/safenow-integration}"
BASE_BRANCH="${BASE_BRANCH:-main}"
REPO="${REPO:-FutureWealthBot/SafeNow}"
PR_TITLE="${PR_TITLE:-Merge SafeNow Integration}"
PR_BODY="${PR_BODY:-Automated PR via API for SafeNow integration.}"
USER_ID="${USER_ID:-12345}"
DOC_ID="${DOC_ID:-doc_9876}"

# Validate required environment variables
if [ -z "$SAFENOW_API_KEY" ]; then
  echo "Error: SAFENOW_API_KEY environment variable is required"
  exit 1
fi

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN environment variable is required"
  exit 1
fi

# Check for required dependencies
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed. Please install jq to use this script."
  echo "Installation: apt-get install jq (Debian/Ubuntu) or brew install jq (macOS)"
  exit 1
fi

if ! command -v curl &> /dev/null; then
  echo "Error: curl is required but not installed."
  exit 1
fi

# -----------------------------
# 1. Test SafeNow Consent API
# -----------------------------
echo "Testing SafeNow API..."

# Make the API call and capture both response and HTTP status
HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST https://api.safenow.futurewealthbot.com/consent/request \
  -H "Authorization: Bearer $SAFENOW_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
        \"user_id\": \"$USER_ID\",
        \"purpose\": \"financial_analysis\",
        \"document_ids\": [\"$DOC_ID\"]
      }")

# Extract HTTP status code (last line) and response body (all but last line)
HTTP_STATUS=$(echo "$HTTP_RESPONSE" | tail -n1)
SAFE_NOW_RESPONSE=$(echo "$HTTP_RESPONSE" | sed '$d')

echo "SafeNow API Response (Status: $HTTP_STATUS):"
echo "$SAFE_NOW_RESPONSE"
echo "---------------------------------"

# Check if API call was successful (2xx status codes)
if [ "$HTTP_STATUS" -lt 200 ] || [ "$HTTP_STATUS" -ge 300 ]; then
  echo "Error: SafeNow API request failed with status $HTTP_STATUS"
  exit 1
fi

# -----------------------------
# 2. Create GitHub Pull Request
# -----------------------------
echo "Creating GitHub Pull Request..."
PR_RESPONSE=$(curl -s -X POST "https://api.github.com/repos/$REPO/pulls" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d "{
        \"title\": \"$PR_TITLE\",
        \"head\": \"$FEATURE_BRANCH\",
        \"base\": \"$BASE_BRANCH\",
        \"body\": \"$PR_BODY\"
      }")

PR_NUMBER=$(echo "$PR_RESPONSE" | jq -r '.number')

if [ "$PR_NUMBER" = "null" ] || [ -z "$PR_NUMBER" ]; then
  echo "Failed to create PR. Response:"
  echo "$PR_RESPONSE"
  exit 1
fi

echo "Pull Request #$PR_NUMBER created successfully!"
echo "---------------------------------"

# -----------------------------
# 3. Merge Pull Request
# -----------------------------
echo "Merging Pull Request #$PR_NUMBER..."
MERGE_RESPONSE=$(curl -s -X PUT "https://api.github.com/repos/$REPO/pulls/$PR_NUMBER/merge" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d "{
        \"commit_title\": \"$PR_TITLE\",
        \"merge_method\": \"merge\"
      }")

MERGE_STATUS=$(echo "$MERGE_RESPONSE" | jq -r '.merged')

if [ "$MERGE_STATUS" = "true" ]; then
  echo "Pull Request #$PR_NUMBER merged successfully!"
else
  echo "Merge failed. Response:"
  echo "$MERGE_RESPONSE"
  exit 1
fi

echo "✅ SafeNow test + PR merge workflow completed successfully!"
