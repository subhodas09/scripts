# Kubernetes Docker Hub Credentials Updater

This script updates the Docker Hub credentials stored in a Kubernetes secret across specified namespaces or all namespaces in a cluster, while excluding certain managed namespaces. It creates a backup of the existing secrets before updating them.

## Prerequisites

- `kubectl` installed and configured to access your Kubernetes cluster
- `yq` command-line tool installed (version 4.x)

## Configuration

Create a `config.txt` file in the same directory as the script, with the following contents:

```ini
# Docker Hub username
# Replace 'your_dockerhub_username' with your Docker Hub account username
DOCKERHUB_USERNAME=your_dockerhub_username

# Docker Hub password
# Replace 'your_dockerhub_password' with your Docker Hub account password or access token
DOCKERHUB_PASSWORD=your_dockerhub_password

# Kubernetes secret name
# Replace 'your_secret_name' with the name of the Kubernetes secret containing the Docker Hub credentials
SECRET_NAME=your_secret_name

# Namespaces to update
# Provide a list of namespaces to update, use '("all")' to update all namespaces except excluded ones
# For a single namespace: ("your_single_namespace")
# For multiple namespaces: ("namespace1" "namespace2" "namespace3")
# For all namespaces: ("all")
NAMESPACE=("all")

# Excluded namespaces
# Specify the namespaces you want to exclude from updates, separated by a '|' symbol
# By default, some Kubernetes and EKS managed namespaces are excluded
# Add any additional namespaces to exclude, separated by '|'
EXCLUDED_NAMESPACES=kube-system|aws-observability|aws-secrets-manager|aws-load-balancer-controller|your_additional_namespace

Follow the instructions in the comments to set the appropriate values for your environment.

Usage
Set up the config.txt file with your Docker Hub credentials, Kubernetes secret name, and desired namespaces.

Make the script executable:

bash
Copy code
chmod +x update_dockerhub_credentials.sh
Run the script:
bash
Copy code
./update_dockerhub_credentials.sh
The script will update the Docker Hub credentials in the specified namespaces or all namespaces (excluding the managed namespaces). It will also create a backup file with the existing secrets before updating them.

Backup
The script creates a backup file in the same directory, named backup_secrets_<timestamp>.txt, containing the existing secrets before updating them. The backup file includes the namespace information and the original secret configuration in YAML format.

Troubleshooting
Ensure that kubectl and yq are installed and properly configured. If you encounter issues with the script, check the following:

Verify that your Docker Hub credentials are correct.
Ensure that the Kubernetes secret name is correct and exists in the specified namespaces.
Confirm that you have the necessary permissions to access and modify the Kubernetes secrets in the desired namespaces.
If you still encounter issues, check the output of the script for error messages and refer to the Kubernetes and Docker Hub documentation for further guidance.