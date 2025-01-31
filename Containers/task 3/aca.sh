#!/bin/bash

# Variables
RESOURCE_GROUP="OleksandraLutsenko"
LOCATION="eastus"
CONTAINERAPPS_ENVIRONMENT="myContainerAppEnv"
CONTAINER_APP="my-container-app"
CONTAINER_IMAGE="nginx"  
CPU_THRESHOLD=50  # CPU percentage threshold for autoscaling
MAX_INSTANCES=5   # Maximum number of instances for scaling
MIN_INSTANCES=3   # Minimum number of instances for scaling


# Create a Container Apps Environment
az containerapp env create \
  --name $CONTAINERAPPS_ENVIRONMENT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION

# Deploy a Container App
az containerapp create \
  --name $CONTAINER_APP \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINERAPPS_ENVIRONMENT \
  --image $CONTAINER_IMAGE \
  --target-port 80 \
  --ingress external \
  --min-replicas $MIN_INSTANCES \
  --max-replicas $MAX_INSTANCES \
  --cpu 0.5 \
  --memory 1.0Gi \
  --scale-rule-name my-http-rule \
  --scale-rule-http-concurrency 50


# Test Load Distribution
echo "Container App is deployed and will scale based on CPU usage."

az containerapp revision list \
  --name $CONTAINER_APP \
  --resource-group $RESOURCE_GROUP \
  --query "[].{Name:name, Replicas:properties.activeReplicaCount}" \
  --output table

# Perform your load testing here, or use a tool to send requests

# ab -n 1000 -c 10 http://<your-container-app-url>/


# # Cleanup: Stop the Container App
echo "Cleaning up resources..."
az containerapp delete --name $CONTAINER_APP --resource-group $RESOURCE_GROUP --yes
az containerapp env delete --name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP --yes

# echo "Deployment and cleanup complete!"
