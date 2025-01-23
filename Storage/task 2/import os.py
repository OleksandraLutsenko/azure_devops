import os
import time
from datetime import datetime, timedelta

# File path
file_path = "Azure Compute Services Practical tasks1.pdf"

# Adjust the modified time to 30 days ago
days_to_subtract = 30
modified_time = datetime.now() - timedelta(days=days_to_subtract)
modified_timestamp = time.mktime(modified_time.timetuple())

# Set the file's modified time
os.utime(file_path, (modified_timestamp, modified_timestamp))

# Now upload the file using Azure CLI
os.system(f'az storage blob upload --container-name lifecycle-container --file "{file_path}" --name "{file_path}" --account-name staccforlifecycle02')
