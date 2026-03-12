#!/bin/bash

# Deploy RAG App to Azure using Terraform
# Usage: ./deploy.sh

set -e

echo "🚀 Starting Terraform deployment to Azure..."

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install it first:"
    echo "   https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install it first:"
    echo "   https://www.terraform.io/downloads"
    exit 1
fi

# Check if logged in to Azure
echo "📋 Checking Azure login status..."
if ! az account show &> /dev/null; then
    echo "🔐 Please login to Azure..."
    az login
fi

echo "✅ Azure login confirmed"
echo ""

# Navigate to terraform directory
cd "$(dirname "$0")/terraform"

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo "❌ terraform.tfvars not found!"
    echo "📝 Please create it from terraform.tfvars.example:"
    echo "   cp terraform.tfvars.example terraform.tfvars"
    echo "   Then edit it with your values"
    exit 1
fi

# Initialize Terraform
echo "🔧 Initializing Terraform..."
terraform init

# Validate configuration
echo "✓ Validating Terraform configuration..."
terraform validate

# Plan deployment
echo "📋 Creating deployment plan..."
terraform plan -out=tfplan

# Ask for confirmation
echo ""
read -p "🤔 Do you want to apply this plan? (yes/no): " confirm

if [ "$confirm" = "yes" ]; then
    echo "🚀 Applying Terraform configuration..."
    terraform apply tfplan
    
    echo ""
    echo "✅ Deployment complete!"
    echo ""
    echo "📊 Application URLs:"
    terraform output -json | grep -E "(app_service_url|staging_slot_url)"
    
    echo ""
    echo "🔄 Next steps:"
    echo "1. Wait 2-3 minutes for the app to fully start"
    echo "2. Deploy your code using one of these methods:"
    echo "   - Azure DevOps pipeline (azure-pipelines.yml)"
    echo "   - GitHub Actions"
    echo "   - ZIP deploy: az webapp deploy --resource-group <rg> --name <app-name> --src-path app.zip"
    echo "   - Local Git: az webapp deployment source config-local-git"
    
else
    echo "❌ Deployment cancelled"
    rm -f tfplan
fi
