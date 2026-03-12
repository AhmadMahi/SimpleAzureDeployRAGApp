# Terraform Deployment for Azure

This directory contains Terraform configuration to deploy the Simple RAG App to Azure Web App Service.

## 📋 Prerequisites

1. **Azure CLI** - [Install guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   ```bash
   az --version
   ```

2. **Terraform** - [Install guide](https://www.terraform.io/downloads)
   ```bash
   terraform --version
   ```

3. **Azure Subscription** - Active Azure subscription with permissions to create resources

4. **OpenAI API Key** - Get from [OpenAI Platform](https://platform.openai.com/api-keys)

## 🚀 Quick Start

### 1. Login to Azure

```bash
az login
```

### 2. Configure Variables

Copy the example file and edit with your values:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # or use your preferred editor
```

**Required variables:**
- `app_name` - Must be globally unique (e.g., "my-rag-app-12345")
- `openai_api_key` - Your OpenAI API key

### 3. Deploy Infrastructure

From the project root:

```bash
chmod +x deploy.sh
./deploy.sh
```

Or manually:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 4. Deploy Application Code

After infrastructure is created, deploy your code:

**Option A: Using Azure CLI (ZIP Deploy)**
```bash
# Create ZIP file (excluding unnecessary files)
zip -r app.zip . -x "*.git*" "*terraform*" "*.venv*" "*__pycache__*"

# Deploy
az webapp deploy \
  --resource-group rg-simplerag-app \
  --name your-app-name \
  --src-path app.zip \
  --type zip
```

**Option B: Using Local Git**
```bash
# Configure local git deployment
az webapp deployment source config-local-git \
  --resource-group rg-simplerag-app \
  --name your-app-name

# Get deployment URL
az webapp deployment list-publishing-credentials \
  --resource-group rg-simplerag-app \
  --name your-app-name \
  --query scmUri -o tsv

# Add remote and push
git remote add azure <deployment-url>
git push azure main
```

**Option C: Using Azure DevOps Pipeline**
Use the included `azure-pipelines.yml` file

## 📁 File Structure

```
terraform/
├── main.tf                     # Main Terraform configuration
├── variables.tf                # Variable definitions
├── outputs.tf                  # Output values
├── terraform.tfvars.example    # Example variable values
├── .gitignore                  # Terraform-specific ignores
└── README.md                   # This file
```

## ⚙️ Configuration Options

### SKU Tiers

| SKU | Name | Price | Features |
|-----|------|-------|----------|
| F1 | Free | $0 | 1GB RAM, 60 min/day, no always-on |
| B1 | Basic | ~$13/mo | 1.75GB RAM, always-on |
| S1 | Standard | ~$69/mo | 1.75GB RAM, auto-scaling, slots |
| P1V2 | Premium | ~$146/mo | 3.5GB RAM, better performance |

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `resource_group_name` | Resource group name | rg-simplerag-app | No |
| `location` | Azure region | East US | No |
| `app_name` | Web app name (globally unique) | - | **Yes** |
| `app_service_plan_name` | App Service Plan name | asp-simplerag | No |
| `sku_name` | SKU tier | B1 | No |
| `openai_api_key` | OpenAI API key | - | **Yes** |
| `environment` | Environment name | production | No |
| `enable_app_insights` | Enable monitoring | false | No |
| `enable_staging_slot` | Enable staging slot | false | No |

## 📊 Outputs

After deployment, Terraform provides:

- `app_service_url` - Your application URL
- `app_service_name` - Name of the web app
- `resource_group_name` - Resource group name
- `staging_slot_url` - Staging slot URL (if enabled)

View outputs:
```bash
cd terraform
terraform output
```

## 🔐 Security Best Practices

1. **Never commit `terraform.tfvars`** - Contains sensitive data
2. **Use Azure Key Vault** - For production, store secrets in Key Vault
3. **Enable HTTPS only** - Already configured in main.tf
4. **Rotate API keys** - Regularly rotate OpenAI API keys
5. **Use managed identities** - Consider Azure Managed Identity for production

## 🔄 Update Deployment

To update infrastructure:

```bash
cd terraform
terraform plan
terraform apply
```

To update application code, redeploy using your preferred method from step 4 above.

## 🧹 Cleanup

To destroy all resources:

```bash
chmod +x destroy.sh
./destroy.sh
```

Or manually:

```bash
cd terraform
terraform destroy
```

## 🐛 Troubleshooting

### App name already exists
```
Error: Web App name already taken
```
**Solution:** Change `app_name` in `terraform.tfvars` to something unique

### Authentication failed
```
Error: building account: getting authenticated object ID
```
**Solution:** Run `az login` again

### OpenAI API errors
**Solution:** Verify your API key in Azure Portal:
- Go to Web App → Configuration → Application Settings
- Check `OPENAI_API_KEY` value

### App not starting
1. Check logs in Azure Portal: Web App → Log stream
2. Verify startup command: `gunicorn --bind=0.0.0.0 --timeout 600 app:app`
3. Check Python version: Should be 3.11

### Quota exceeded
```
Error: Quota exceeded for quota ID
```
**Solution:** 
- Choose a different Azure region
- Use a different SKU tier
- Request quota increase from Azure support

## 📚 Additional Resources

- [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure App Service Docs](https://docs.microsoft.com/en-us/azure/app-service/)
- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/)

## 💡 Tips

1. **Start with F1 (Free) tier** for testing
2. **Enable App Insights** for production monitoring
3. **Use staging slots** for zero-downtime deployments (S1+ tier)
4. **Set up CI/CD** with Azure DevOps or GitHub Actions
5. **Monitor costs** in Azure Cost Management

## 🆘 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Azure Portal logs
3. Consult Terraform and Azure documentation
