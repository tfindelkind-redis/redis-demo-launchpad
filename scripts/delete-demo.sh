#!/bin/bash
# delete-demo.sh - Delete a demo folder and remove its entry from site/index.json and workflow file

set -e

read -p "Enter demo folder name to delete (e.g., demo-005-azure-semantic-cache): " DEMO_NAME
DEMO_PATH="demos/$DEMO_NAME"
INDEX_JSON="site/index.json"

if [ ! -d "$DEMO_PATH" ]; then
  echo "Demo folder '$DEMO_PATH' does not exist."
  exit 1
fi

# Confirmation prompt
read -p "Are you sure you want to delete '$DEMO_PATH'? This action cannot be undone. (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Aborted. No changes made."
  exit 0
fi

# Remove demo folder
rm -rf "$DEMO_PATH"
echo "Deleted folder: $DEMO_PATH"

# Remove workflow files
WORKFLOW_FILE=".github/workflows/${DEMO_NAME}-workflow.yml"
CLEANUP_WORKFLOW_FILE=".github/workflows/${DEMO_NAME}-cleanup-workflow.yml"

if [ -f "$WORKFLOW_FILE" ]; then
  rm "$WORKFLOW_FILE"
  echo "Deleted workflow file: $WORKFLOW_FILE"
fi

if [ -f "$CLEANUP_WORKFLOW_FILE" ]; then
  rm "$CLEANUP_WORKFLOW_FILE"
  echo "Deleted cleanup workflow file: $CLEANUP_WORKFLOW_FILE"
fi

# Remove entry from site/index.json
if [ -f "$INDEX_JSON" ]; then
  DEMO_ID=""
  if [ -f "$DEMO_PATH/id.txt" ]; then
    DEMO_ID=$(cat "$DEMO_PATH/id.txt")
  fi
  if [ -z "$DEMO_ID" ]; then
    # Try to find by name if id.txt is missing
    jq "del(.[] | select(.name == \"$DEMO_NAME\"))" "$INDEX_JSON" > "$INDEX_JSON.tmp" && mv "$INDEX_JSON.tmp" "$INDEX_JSON"
  else
    jq "del(.[] | select(.id == \"$DEMO_ID\"))" "$INDEX_JSON" > "$INDEX_JSON.tmp" && mv "$INDEX_JSON.tmp" "$INDEX_JSON"
  fi
  echo "Removed demo entry from $INDEX_JSON."
fi

echo "Demo '$DEMO_NAME' deleted successfully."
