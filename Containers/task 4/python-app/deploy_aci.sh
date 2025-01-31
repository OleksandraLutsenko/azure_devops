#!/bin/bash

# Define Variables
RESOURCE_GROUP="OleksandraLutsenko"
ACI_NAME="secure-aci-test"
KEY_VAULT_NAME="kv-aci-test-ol"  # Your Key Vault
SECRET_NAME="test-secret"  # Secret Name
ACR_NAME="acrregistryfordocker"
ACR_LOGIN_SERVER="acrregistryfordocker.azurecr.io"  # ✅ Fixed Syntax
IMAGE_NAME="python-app:v2"
MANAGED_IDENTITY_NAME="identity4task"

# Get the Managed Identity **Resource ID** (NOT just the name)
MANAGED_IDENTITY_ID=$(az identity show --name $MANAGED_IDENTITY_NAME --resource-group $RESOURCE_GROUP --query id --output tsv)

# Ensure Managed Identity ID is retrieved correctly
if [[ -z "$MANAGED_IDENTITY_ID" ]]; then
  echo "Error: Managed Identity ID could not be found."
  exit 1
fi

# Get ACR Login Credentials
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query "username" --output tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query "passwords[0].value" --output tsv)

# Deploy ACI with Authentication for ACR
az container create \
  --resource-group $RESOURCE_GROUP \
  --name $ACI_NAME \
  --image $ACR_LOGIN_SERVER/$IMAGE_NAME \
  --cpu 0.5 \
  --memory 1.0 \
  --ports 80 \
  --dns-name-label secure-aci-test-ol \
  --environment-variables KEY_VAULT_NAME=$KEY_VAULT_NAME SECRET_NAME=$SECRET_NAME \
  --assign-identity \
  --registry-login-server $ACR_LOGIN_SERVER \
  --registry-username $ACR_USERNAME \
  --registry-password $ACR_PASSWORD

# Get ACI FQDN (Public URL)
ACI_FQDN=$(az container show --name $ACI_NAME --resource-group $RESOURCE_GROUP --query ipAddress.fqdn --output tsv)

echo "Deployment complete! Access your app at: http://$ACI_FQDN"

