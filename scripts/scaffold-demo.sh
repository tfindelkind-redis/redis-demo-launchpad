#!/bin/bash
# scaffold-demo.sh - Scaffold a new demo environment

set -e

# Prompt for demo name with abort option
while true; do
  read -p "Enter demo folder name (e.g., demo-005-azure-semantic-cache, or type 'q' to quit and abort): " DEMO_NAME
  if [[ "$DEMO_NAME" == "q" ]]; then
    echo "Aborted by user."
    exit 0
  fi
  if [[ -n "$DEMO_NAME" ]]; then
    break
  fi
done

# List available template types
TEMPLATE_DIR="templates"
TEMPLATES=()
for d in "$TEMPLATE_DIR"/*/; do
  [ -d "$d" ] && TEMPLATES+=("$(basename "$d")")
  done

# Template selection with abort and default
echo "Available template types (type the number, or type 'q' to quit and abort; press Enter for default 'azure-bicep'):"
while true; do
  select TEMPLATE_TYPE in "${TEMPLATES[@]}"; do
    if [[ "$REPLY" == "" ]]; then
      for i in "${!TEMPLATES[@]}"; do
        if [[ "${TEMPLATES[$i]}" == "azure-bicep" ]]; then
          TEMPLATE_TYPE="azure-bicep"
          echo "Default selected: $TEMPLATE_TYPE (press Enter for default)"
          break 2
        fi
      done
      TEMPLATE_TYPE="${TEMPLATES[0]}"
      echo "Default selected: $TEMPLATE_TYPE (press Enter for default)"
      break 2
    fi
    if [[ "$REPLY" == "q" ]]; then
      echo "Aborted by user."
      exit 0
    fi
    if [[ -n "$TEMPLATE_TYPE" ]]; then
      echo "Selected template: $TEMPLATE_TYPE"
      break 2
    else
      echo "Invalid selection. Please try again."
      break
    fi
  done
  break
done

# Paths
DEMO_PATH="demos/$DEMO_NAME"
TEMPLATE_PATH="templates/$TEMPLATE_TYPE"
ID_FILE="$DEMO_PATH/id.txt"
INDEX_JSON="site/index.json"

# Create demo folder
mkdir -p "$DEMO_PATH"

# Generate unique ID (UUID)
DEMO_ID=$(uuidgen)
echo "$DEMO_ID" > "$ID_FILE"

# Create demo folder structure
mkdir -p "$DEMO_PATH"
mkdir -p ".github/workflows"

# Copy non-workflow template files
for file in "$TEMPLATE_PATH"/*; do
  if [ "$(basename "$file")" != "workflow.yml" ]; then
    cp -r "$file" "$DEMO_PATH"/
  fi
done

# Process config.json in the demo folder with placeholders replaced
CONFIG_FILE="$DEMO_PATH/config.json"
TIMESTAMP=$(date +%Y%m%d)
if [ -f "$CONFIG_FILE" ]; then
  # Replace placeholders in the copied config.json
  sed -i '' "s/{{DEMO_NAME}}/$DEMO_NAME/g" "$CONFIG_FILE"
  sed -i '' "s/{{TIMESTAMP}}/$TIMESTAMP/g" "$CONFIG_FILE"
  echo "Updated config.json for demo: $CONFIG_FILE"
else
  echo "Warning: config.json not found in template"
fi

# Copy workflow files to .github/workflows/
mkdir -p ".github/workflows"

# Copy and configure main workflow
WORKFLOW_SRC="$TEMPLATE_PATH/workflow.yml"
WORKFLOW_DEST=".github/workflows/${DEMO_NAME}-workflow.yml"
if [ -f "$WORKFLOW_SRC" ]; then
  # Copy and update workflow name
  awk -v demo_name="$DEMO_NAME" 'BEGIN{replaced=0} /^name:/ && !replaced {print "name: " demo_name; replaced=1; next} {print}' "$WORKFLOW_SRC" > "$WORKFLOW_DEST"
  echo "Main workflow copied to $WORKFLOW_DEST with name set to $DEMO_NAME"
fi

# Copy and configure cleanup workflow
CLEANUP_SRC="$TEMPLATE_PATH/cleanup-workflow.yml"
CLEANUP_DEST=".github/workflows/${DEMO_NAME}-cleanup-workflow.yml"
if [ -f "$CLEANUP_SRC" ]; then
  # Copy and update workflow name
  awk -v demo_name="$DEMO_NAME" 'BEGIN{replaced=0} /^name:/ && !replaced {print "name: " demo_name "-cleanup"; replaced=1; next} {print}' "$CLEANUP_SRC" > "$CLEANUP_DEST"
  echo "Cleanup workflow copied to $CLEANUP_DEST"
fi

# Add entry to site/index.json
if [ ! -f "$INDEX_JSON" ]; then
  echo "[]" > "$INDEX_JSON"
fi

# Create demo metadata JSON
DEMO_METADATA=$(jq -n --arg name "$DEMO_NAME" --arg id "$DEMO_ID" --arg template "$TEMPLATE_TYPE" '{name: $name, id: $id, template: $template}')

# Append to index.json
jq ". + [ $DEMO_METADATA ]" "$INDEX_JSON" > "$INDEX_JSON.tmp" && mv "$INDEX_JSON.tmp" "$INDEX_JSON"

# Success message
echo "Demo '$DEMO_NAME' scaffolded successfully!"
echo "- Folder: $DEMO_PATH"
echo "- ID: $DEMO_ID"
echo "- Template: $TEMPLATE_TYPE"
echo "- Registered in $INDEX_JSON"
