#!/bin/bash

# Ensure the script exits on any error
set -e

# Define variables
RESOURCE_GROUP="vmss-demo"
LOCATION="EastUS"
VNET_NAME="MyVNet"
SUBNET_NAME="MySubnet"
VMSS_NAME="MyVMSS"
CLOUD_INIT_FILE="./cloud-init.txt"
VM_SKU="Standard_B1s"
IMAGE="Ubuntu2204"
INSTANCE_COUNT=2
ADMIN_USERNAME="azureuser"
LOAD_BALANCER_NAME="MyLoadBalancer"
PUBLIC_IP_NAME="MyPublicIP"
BACKEND_POOL_NAME="MyBackendPool"
HEALTH_PROBE_NAME="MyHealthProbe"
LB_RULE_NAME="MyHTTPRule"
FRONTEND_IP_NAME="LoadBalancerFrontEnd"
SUBSCRIPTION_ID="09cced6e-2902-4e56-803c-60c54328dcb9"

# Custom Data Script embedded directly
# Custom Data Script embedded directly
CUSTOM_DATA=$(cat <<'EOF'
#!/bin/bash

# Update system and install Apache
sudo apt-get update -y
sudo apt-get install -y apache2

# Set variables
HTML_PAGE="/var/www/html/index.html"
SERVICE_NAME="apache2"

# Step 1: Get the internal IP address
INTERNAL_IP=$(hostname -I | awk '{print $1}')

# Check if IP was retrieved successfully
if [[ -z "$INTERNAL_IP" ]]; then
  echo "Error: Unable to retrieve internal IP address."
  exit 1
fi

# Step 2: Update the default HTML page
cat <<HTML > $HTML_PAGE
<html>
<head><title>Internal IP</title></head>
<body>
<h1>Your internal IP address is: $INTERNAL_IP</h1>
</body>
</html>
HTML

# Step 3: Configure passwordless restart for Apache
USERNAME="azureuser"
echo "$USERNAME ALL=(ALL) NOPASSWD: /bin/systemctl restart $SERVICE_NAME" | sudo tee /etc/sudoers.d/azureuser-apache

# Step 4: Restart Apache to apply changes
sudo systemctl restart $SERVICE_NAME

# Step 5: Enable Apache to start on boot
sudo systemctl enable $SERVICE_NAME

echo "Setup complete. Internal IP is displayed on the default Apache page."
EOF
)

# Create Resource Group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create Virtual Network and Subnet
az network vnet create \
  --name $VNET_NAME \
  --resource-group $RESOURCE_GROUP \
  --address-prefix 10.0.0.0/16 \
  --subnet-name $SUBNET_NAME \
  --subnet-prefix 10.0.0.0/24

# Create the VM Scale Set
echo "Creating VM Scale Set..."
az vmss create \
  --resource-group "$RESOURCE_GROUP" \
  --orchestration-mode Uniform \
  --name "$VMSS_NAME" \
  --image "$IMAGE" \
  --admin-username $ADMIN_USERNAME \
  --generate-ssh-keys \
  --vm-sku "$VM_SKU" \
  --instance-count "$INSTANCE_COUNT" \
  --custom-data "$CUSTOM_DATA" \
  --upgrade-policy-mode Manual \
  --single-placement-group true

# Create Load Balancer and Public IP
az network lb create \
  --resource-group $RESOURCE_GROUP \
  --name $LOAD_BALANCER_NAME \
  --sku Basic \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --public-ip-address $PUBLIC_IP_NAME

# Create Load Balancer Backend Address Pool
az network lb address-pool create \
  --resource-group $RESOURCE_GROUP \
  --lb-name $LOAD_BALANCER_NAME \
  --name $BACKEND_POOL_NAME

# Update VMSS to associate with the Backend Pool
az vmss update \
  --name $VMSS_NAME \
  --resource-group $RESOURCE_GROUP \
  --set virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations[0].loadBalancerBackendAddressPools="[{'id':'/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Network/loadBalancers/$LOAD_BALANCER_NAME/backendAddressPools/$BACKEND_POOL_NAME'}]"

# Create Health Probe
az network lb probe create \
  --resource-group $RESOURCE_GROUP \
  --lb-name $LOAD_BALANCER_NAME \
  --name $HEALTH_PROBE_NAME \
  --protocol Tcp \
  --port 80

# Create Load Balancer Rule
az network lb rule create \
  --resource-group $RESOURCE_GROUP \
  --lb-name $LOAD_BALANCER_NAME \
  --name $LB_RULE_NAME \
  --protocol Tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name $FRONTEND_IP_NAME \
  --backend-pool-name $BACKEND_POOL_NAME \
  --probe-name $HEALTH_PROBE_NAME

# Retrieve Public IP
PUBLIC_IP=$(az network public-ip show \
  --resource-group $RESOURCE_GROUP \
  --name $PUBLIC_IP_NAME \
  --query "ipAddress" --output tsv)

# Output the Public IP Address
echo "Public IP Address of the Load Balancer: $PUBLIC_IP"
