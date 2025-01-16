
#!/bin/bash

# Update system and install Apache if not already installed
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
echo "<html>" > $HTML_PAGE
echo "<head><title>Internal IP</title></head>" >> $HTML_PAGE
echo "<body>" >> $HTML_PAGE
echo "<h1>Your internal IP address is: $INTERNAL_IP</h1>" >> $HTML_PAGE
echo "</body>" >> $HTML_PAGE
echo "</html>" >> $HTML_PAGE

# Step 3: Configure passwordless restart for Apache
USERNAME="azureuser"
echo "$USERNAME ALL=(ALL) NOPASSWD: /bin/systemctl restart $SERVICE_NAME" | sudo tee /etc/sudoers.d/azureuser-apache

# Step 4: Restart Apache to apply changes
sudo systemctl restart $SERVICE_NAME

# Step 5: Enable Apache to start on boot
sudo systemctl enable $SERVICE_NAME

echo "Setup complete. Internal IP is displayed on the default Apache page."
  