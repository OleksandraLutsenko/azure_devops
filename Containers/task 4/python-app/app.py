import os
from flask import Flask
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

app = Flask(__name__)

@app.route('/')
def get_secret():
    try:
        key_vault_name = os.environ["KEY_VAULT_NAME"]
        secret_name = os.environ["SECRET_NAME"]
        KV_URI = f"https://{key_vault_name}.vault.azure.net/"

        # Authenticate with Managed Identity
        credential = DefaultAzureCredential()
        client = SecretClient(vault_url=KV_URI, credential=credential)

        # Retrieve the secret
        retrieved_secret = client.get_secret(secret_name)

        return f"Retrieved Secret: {retrieved_secret.value}"

    except Exception as e:
        return f"Error retrieving secret: {str(e)}"

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=80)

# The app retrieves a secret from Azure Key Vault using Managed Identity.
    