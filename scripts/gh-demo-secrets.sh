#!/bin/bash
# gh-demo-secrets.sh - Update GitHub Actions secrets from a local JSON file

set -e

SECRETS_FILE=".demo-secrets"
GITIGNORE_FILE=".gitignore"

# Check for --test parameter
if [[ "$1" == "--test" ]]; then
  echo "Running in TEST mode: using dummy secrets."
  SECRETS_FILE=".demo-secrets-test"
  cat > "$SECRETS_FILE" <<EOF
{
  "AZURE_CREDENTIALS": {
    "clientId": "dummy",
    "clientSecret": "dummy",
    "subscriptionId": "dummy",
    "tenantId": "dummy"
  }
}
EOF
fi

# Ensure .demo-secrets is in .gitignore
if ! grep -qxF ".demo-secrets" "$GITIGNORE_FILE"; then
  echo ".demo-secrets" >> "$GITIGNORE_FILE"
  echo "Added .demo-secrets to $GITIGNORE_FILE."
fi
if ! grep -qxF ".demo-secrets-test" "$GITIGNORE_FILE"; then
  echo ".demo-secrets-test" >> "$GITIGNORE_FILE"
  echo "Added .demo-secrets-test to $GITIGNORE_FILE."
fi

# Check for GitHub CLI
if ! command -v gh &> /dev/null; then
  echo "GitHub CLI (gh) is not installed. Please install it first."
  exit 1
fi

# Check for jq
if ! command -v jq &> /dev/null; then
  echo "jq is not installed. Please install it first (e.g., 'brew install jq')."
  exit 1
fi

# Check for secrets file
if [ ! -f "$SECRETS_FILE" ]; then
  echo "$SECRETS_FILE not found. Please create it as a JSON file with an AZURE_CREDENTIALS object."
  exit 1
fi

# Get repo name (owner/repo)
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

# Only set AZURE_CREDENTIALS as a secret, using the full JSON object
if jq -e 'has("AZURE_CREDENTIALS")' "$SECRETS_FILE" > /dev/null; then
  VALUE=$(jq -c '.AZURE_CREDENTIALS' "$SECRETS_FILE")
  echo "Setting secret: AZURE_CREDENTIALS"
  gh secret set AZURE_CREDENTIALS -b"$VALUE" -R "$REPO"
  echo "Secret set: AZURE_CREDENTIALS"
else
  echo "AZURE_CREDENTIALS key not found in $SECRETS_FILE."
  exit 1
fi

echo "All secrets from $SECRETS_FILE have been set for $REPO."

# If in test mode, verify, delete, and report
if [[ "$1" == "--test" ]]; then
  if gh secret list -R "$REPO" | grep -q "^AZURE_CREDENTIALS"; then
    echo "Verified secret: AZURE_CREDENTIALS"
    gh secret remove AZURE_CREDENTIALS -R "$REPO"
    echo "Deleted test secret: AZURE_CREDENTIALS"
    echo "✅ Test run successful: AZURE_CREDENTIALS was set, verified, and deleted."
  else
    echo "❌ Test run failed: AZURE_CREDENTIALS was not set or verified."
    exit 1
  fi
fi
