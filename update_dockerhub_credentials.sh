#!/bin/bash

# Read inputs from the config file
source config.txt

# Backup file
BACKUP_FILE="backup_secrets_$(date +%Y%m%d_%H%M%S).txt"

# Function to update the secret in the specified namespace
update_secret() {
  local namespace="$1"
  echo "-----------------------------------------------------------"  
  echo "Processing namespace: $namespace"

  # Retrieve the existing secret in YAML format
  SECRET_YAML=$(kubectl get secret "$SECRET_NAME" -n "$namespace" -o yaml)

  # Append the existing secret configuration to the backup file
  echo "Backing up existing secret in namespace: $namespace to $BACKUP_FILE"
  echo "Namespace: $namespace" >> "$BACKUP_FILE"
  echo "$SECRET_YAML" >> "$BACKUP_FILE"
  echo "------------------------------------------------------------" >> "$BACKUP_FILE"

  # Decode the existing dockerconfigjson
  EXISTING_DOCKERCONFIGJSON=$(echo "$SECRET_YAML" | yq  '.data.".dockerconfigjson"' - | base64 --decode)

  # Encode the Docker Hub credentials in base64 format
  AUTH_BASE64=$(echo -n "$DOCKERHUB_USERNAME:$DOCKERHUB_PASSWORD" | base64)

  # Update the auth for the Docker Hub registry
  UPDATED_DOCKERCONFIGJSON=$(echo "$EXISTING_DOCKERCONFIGJSON" | AUTH_BASE64="$AUTH_BASE64" yq  '.auths."'$DOCKER_REGISTRY'".auth = env(AUTH_BASE64)' -)

  # Encode the updated dockerconfigjson
  UPDATED_DOCKERCONFIGJSON_BASE64=$(echo -n "$UPDATED_DOCKERCONFIGJSON" | jq | base64)

  # Update the Kubernetes secret
  kubectl patch secret "$SECRET_NAME" -n "$namespace" -p "{\"data\":{\".dockerconfigjson\":\"$UPDATED_DOCKERCONFIGJSON_BASE64\"}}"

   echo "Updated secret in namespace: $namespace"

}

# Main script
if [[ "${NAMESPACE[0]}" == "all" ]]; then
  # Get all namespaces, excluding the specified namespaces
  
  NAMESPACES=$(kubectl get namespaces --no-headers -o custom-columns=":metadata.name" | grep -v -E "^($EXCLUDED_NAMESPACES)$")
  echo "Updating secrets in all namespaces: ${NAMESPACES[*]} ...and Skipping excluded namespace: $EXCLUDED_NAMESPACES"

  # Iterate through the namespaces and update the secret
  for ns in "${NAMESPACES[@]}"; do
    update_secret "$ns"
  done
elif [[ "${NAMESPACE[0]}" == "auto" ]]; then
    # Get all namespaces, which has specified secret name in it
   
    echo "Fetching namespaces with the secret \"$SECRET_NAME\"..."
    NAMESPACES=($(kubectl get secrets --all-namespaces -o json | jq -r ".items[] | select(.metadata.name == \"$SECRET_NAME\") | .metadata.namespace"))
    echo "Found ${#NAMESPACES[@]} namespaces with the secret \"$SECRET_NAME\": ${NAMESPACES[*]}"
  
  # Iterate through the namespaces and update the secret
  for ns in "${NAMESPACES[@]}"; do
    update_secret "$ns"
  done
else
  # Iterate through the list of namespaces and update the secret
  echo "Updating secrets in specified namespaces: ${NAMESPACE[*]}"
  for ns in "${NAMESPACE[@]}"; do
    update_secret "$ns"
  done
fi
