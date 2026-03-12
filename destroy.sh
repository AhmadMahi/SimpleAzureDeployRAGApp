#!/bin/bash

# Destroy Azure resources created by Terraform
# Usage: ./destroy.sh

set -e

echo "⚠️  WARNING: This will destroy all Azure resources created by Terraform!"
echo ""

# Navigate to terraform directory
cd "$(dirname "$0")/terraform"

# Check if Terraform is initialized
if [ ! -d ".terraform" ]; then
    echo "❌ Terraform not initialized. Run ./deploy.sh first or 'terraform init'"
    exit 1
fi

read -p "🤔 Are you sure you want to destroy all resources? Type 'yes' to confirm: " confirm

if [ "$confirm" = "yes" ]; then
    echo "💥 Destroying resources..."
    terraform destroy
    
    echo ""
    echo "✅ All resources have been destroyed"
else
    echo "❌ Destruction cancelled"
fi
