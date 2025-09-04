#!/bin/bash

# This script should create a new service principal in Azure
# and assign it the necessary permissions.
# Usage: ./create_sp.sh 
# Make sure you have the Azure CLI and GitHub CLI installed before running this script.
# Make sure the variable SERVICE_PRINCIPAL_NAME is set to the desired name for the service principal.
# Make sure the variable SUBSCRIPTION_ID is set to the desired Azure subscription ID.
# The ouptput will be the service principal ID and stored in Github secrets and in a file named service_principal_id.txt


SERVICE_PRINCIPAL_NAME=SP_Automation
SUBSCRIPTION_ID=43b862e9-2d27-444d-b2d2-dff41c98ba0f 


# Make sure the Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "Azure CLI is not installed. Please install it first."
    exit 1
fi

# Make sure the GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI is not installed. Please install it first."
    exit 1
fi

# Check if logged in
if ! az account show &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in to Azure. Please login first.${NC}"
    az login
fi

# Create the service principal and store the secret in a variable called SP_OUTPUT
SP_OUTPUT=$(az ad sp create-for-rbac --name "$SERVICE_PRINCIPAL_NAME" --role Contributor --scopes /subscriptions/"$SUBSCRIPTION_ID" --json-auth)

# Output the SP_OUTPUT
echo "Service Principal Output: $SP_OUTPUT"

# If AZURE_CREDENTIALS is already set, prompt the user to confirm overwriting it
if gh secret list | grep -q AZURE_CREDENTIALS; then
    read -p "AZURE_CREDENTIALS already exists in GitHub secrets. Do you want to overwrite it? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
        echo "Exiting without overwriting the existing secret."
        exit 0
    fi
    gh secret delete AZURE_CREDENTIALS
    gh secret set AZURE_CREDENTIALS --body "$SP_OUTPUT"
    echo "Azure credentials have been saved to GitHub secrets as AZURE_CREDENTIALS"    
fi

# save the AZURE_CREDENTIALS to GitHub secrets via the GitHub CLI
gh secret set AZURE_CREDENTIALS --body "$SP_OUTPUT"
echo "Azure credentials have been saved to GitHub secrets as AZURE_CREDENTIALS"

# Output the AZURE_CREDENTIALS to a file
echo "$SP_OUTPUT" > azure_credentials.json
echo "Azure credentials have been saved to azure_credentials.json"

# Grant the Service Principal access to the subscription with role "User Access Administrator"
az role assignment create --assignee "$SP_APP_ID" --role "User Access Administrator" --scope /subscriptions/"$SUBSCRIPTION_ID"