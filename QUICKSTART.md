# 🚀 Quick Start Guide - Deploy RAG App with Terraform

This guide will help you deploy the Simple RAG App to Azure in under 5 minutes using Terraform.

## Prerequisites (5 minutes setup)

1. **Install Azure CLI**
   ```bash
   # macOS
   brew install azure-cli
   
   # Windows
   # Download from: https://aka.ms/installazurecliwindows
   
   # Linux
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```

2. **Install Terraform**
   ```bash
   # macOS
   brew install terraform
   
   # Windows (Chocolatey)
   choco install terraform
   
   # Linux
   # Download from: https://www.terraform.io/downloads
   ```

3. **Get OpenAI API Key**
   - Go to https://platform.openai.com/api-keys
   - Create a new API key
   - Copy it (you'll need it in step 3)

## Deployment Steps

### Step 1: Login to Azure (1 minute)

```bash
az login
```

This will open your browser for authentication.

### Step 2: Clone and Configure (2 minutes)

```bash
# If you haven't cloned yet
git clone https://github.com/AhmadMahi/SimpleAzureDeployRAGApp.git
cd SimpleAzureDeployRAGApp

# Configure Terraform variables
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:
```bash
nano terraform.tfvars  # or use VS Code/any editor
```

**Minimum required changes:**
```hcl
app_name = "my-unique-rag-app-789"  # Change this to something unique!
openai_api_key = "sk-your-actual-key-here"  # Paste your OpenAI key
```

Save and close the file.

### Step 3: Deploy Infrastructure (2 minutes)

```bash
# Go back to project root
cd ..

# Run deployment script
./deploy.sh
```

When prompted, type `yes` to confirm.

### Step 4: Deploy Application Code (1 minute)

After infrastructure is ready:

```bash
# Create deployment package
zip -r app.zip . -x "*.git*" "*terraform*" "*.venv*" "*__pycache__*" "*.md"

# Deploy to Azure (replace with your app name from step 2)
az webapp deploy \
  --resource-group rg-simplerag-app \
  --name my-unique-rag-app-789 \
  --src-path app.zip \
  --type zip
```

### Step 5: Test Your App! 🎉

Wait 2-3 minutes for the app to start, then visit:
```
https://your-app-name.azurewebsites.net
```

## Common Issues & Fixes

### ❌ "App name already taken"
**Solution:** Change `app_name` in `terraform.tfvars` to something more unique:
```hcl
app_name = "my-rag-app-12345-xyz"
```

### ❌ "az: command not found"
**Solution:** Install Azure CLI (see prerequisites above)

### ❌ "terraform: command not found"
**Solution:** Install Terraform (see prerequisites above)

### ❌ "OpenAI API Error"
**Solution:** 
1. Check your API key is correct
2. Ensure you have credits in your OpenAI account
3. Update in Azure Portal: Web App → Configuration → Application Settings → OPENAI_API_KEY

### ❌ "Application Error" when visiting the site
**Solution:** 
1. Wait 2-3 more minutes (first deployment takes time)
2. Check deployment logs:
   ```bash
   az webapp log tail --resource-group rg-simplerag-app --name your-app-name
   ```

## Cleanup (Delete Everything)

To remove all Azure resources:

```bash
./destroy.sh
```

Type `yes` when prompted.

## Cost Estimate

With B1 tier (default):
- **~$13/month** for App Service
- **~$0.10-1.00/month** for OpenAI API calls (depends on usage)

**Total: ~$13-14/month**

💡 **Tip:** Use F1 (Free) tier for testing:
```hcl
sku_name = "F1"
```

## Next Steps

- ✅ Customize the knowledge base in `app.py`
- ✅ Set up CI/CD with Azure DevOps (see `azure-pipelines.yml`)
- ✅ Enable Application Insights for monitoring
- ✅ Add your own data to the RAG system

## Need Help?

1. Check [terraform/README.md](terraform/README.md) for detailed docs
2. Check [README.md](README.md) for app documentation
3. Review Azure Portal logs

---

**Congratulations!** 🎉 Your RAG app is now live on Azure!
