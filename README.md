# RAG AI Assistant 🤖

A simple Retrieval Augmented Generation (RAG) application built with Flask and OpenAI, designed for easy deployment to Azure Web App Service.

## Features

- 🚀 Simple and minimal dependencies
- 💬 Professional chat interface
- 🔍 RAG-powered responses using OpenAI
- ☁️ Azure Web App Service ready
- 📚 Dummy knowledge base included
- 🎨 Modern, responsive UI

## Prerequisites

- Python 3.9+
- OpenAI API key
- Azure account (for deployment)

## Local Development

### 1. Clone the repository

```bash
cd SampleDemo
```

### 2. Create virtual environment

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Set up environment variables

Create a `.env` file in the root directory:

```bash
OPENAI_API_KEY=your_openai_api_key_here
```

Or export it directly:

```bash
export OPENAI_API_KEY='your_openai_api_key_here'
```

### 5. Run the application

```bash
python app.py
```

Visit `http://localhost:8000` in your browser.

## Deployment to Azure Web App Service

### Method 1: Using Terraform (Recommended) 🌟

The easiest way to deploy is using Terraform for infrastructure as code.

**Quick Start:**

```bash
# 1. Configure your settings
cd terraform
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Edit with your app name and OpenAI API key

# 2. Deploy infrastructure
cd ..
chmod +x deploy.sh
./deploy.sh

# 3. Deploy application code
zip -r app.zip . -x "*.git*" "*terraform*" "*.venv*" "*__pycache__*"
az webapp deploy --resource-group rg-simplerag-app --name <your-app-name> --src-path app.zip --type zip
```

📖 **Detailed Guide:** See [terraform/README.md](terraform/README.md) for complete instructions, troubleshooting, and advanced options.

### Method 2: Using Azure CLI (Manual)

1. **Login to Azure**

```bash
az login
```

2. **Create a resource group** (if not exists)

```bash
az group create --name myResourceGroup --location eastus
```

3. **Create an App Service plan**

```bash
az appservice plan create --name myAppServicePlan --resource-group myResourceGroup --sku B1 --is-linux
```

4. **Create the web app**

```bash
az webapp create --resource-group myResourceGroup --plan myAppServicePlan --name myRAGApp --runtime "PYTHON:3.11"
```

5. **Configure the startup command**

```bash
az webapp config set --resource-group myResourceGroup --name myRAGApp --startup-file "startup.txt"
```

6. **Set environment variables**

```bash
az webapp config appsettings set --resource-group myResourceGroup --name myRAGApp --settings OPENAI_API_KEY='your_openai_api_key_here'
```

7. **Deploy the code**

```bash
az webapp up --resource-group myResourceGroup --name myRAGApp --runtime "PYTHON:3.11"
```

### Method 3: Using VS Code Azure Extension

1. Install the Azure App Service extension in VS Code
2. Sign in to your Azure account
3. Right-click on the project folder
4. Select "Deploy to Web App"
5. Follow the prompts to create/select a web app
6. After deployment, add the `OPENAI_API_KEY` in the Azure Portal:
   - Go to your Web App
   - Navigate to Configuration → Application Settings
   - Add `OPENAI_API_KEY` with your API key value

### Method 4: Using Azure Portal

1. Log in to [Azure Portal](https://portal.azure.com)
2. Create a new Web App:
   - Runtime: Python 3.11
   - Operating System: Linux
3. In the Configuration section, add:
   - Application Setting: `OPENAI_API_KEY` = your API key
   - Startup Command: `gunicorn --bind=0.0.0.0 --timeout 600 app:app`
4. Deploy using GitHub Actions, Local Git, FTP/FTPS, or ZIP deploy

### Method 5: Using Azure DevOps Pipeline

Use the included [azure-pipelines.yml](azure-pipelines.yml) for automated CI/CD deployment.

1. Log in to [Azure Portal](https://portal.azure.com)
2. Create a new Web App:
   - Runtime: Python 3.11
   - Operating System: Linux
3. In the Configuration section, add:
   - Application Setting: `OPENAI_API_KEY` = your API key
   - Startup Command: `gunicorn --bind=0.0.0.0 --timeout 600 app:app`
4. Deploy using:
   - GitHub Actions
   - Local Git
   - FTP/FTPS
   - Or ZIP deploy

## Knowledge Base

The app includes a simple dummy knowledge base with information about:
- Python programming
- Machine Learning
- Azure Web App Service
- RAG technology
- OpenAI

You can easily expand the knowledge base by adding more entries to the `KNOWLEDGE_BASE` list in `app.py`.

## API Endpoints

### `GET /`
Returns the main chat interface.

### `POST /api/chat`
Handles chat requests.

**Request body:**
```json
{
  "query": "What is Python?"
}
```

**Response:**
```json
{
  "response": "Python is a high-level...",
  "context": ["Python is a high-level, interpreted..."]
}
```

### `GET /api/health`
Health check endpoint.

**Response:**
```json
{
  "status": "healthy"
}
```

## Project Structure

```
SampleDemo/
├── app.py              # Main Flask application
├── templates/
│   └── index.html      # Frontend UI
├── requirements.txt    # Python dependencies
├── startup.txt         # Azure startup command
├── .env.example        # Environment variables template
├── .gitignore         # Git ignore rules
└── README.md          # This file
```

## Technologies Used

- **Backend**: Flask
- **AI**: OpenAI GPT-3.5-turbo & Embeddings
- **Vector Operations**: NumPy
- **Server**: Gunicorn
- **Frontend**: HTML, CSS, JavaScript

## Customization

### Change the AI Model

In `app.py`, modify the model parameter:

```python
model="gpt-4"  # Or any other OpenAI model
```

### Update the Knowledge Base

Add more entries to `KNOWLEDGE_BASE` in `app.py`:

```python
{
    "text": "Your knowledge text here",
    "embedding": get_embedding("Your knowledge text here")
}
```

### Customize the UI

Edit `templates/index.html` to change colors, layout, or add features.

## Troubleshooting

### OpenAI API Error
- Ensure your API key is correctly set
- Check your OpenAI account has available credits

### Azure Deployment Issues
- Verify Python version is 3.9+
- Check Application Settings in Azure Portal
- Review deployment logs in Azure Portal

### Port Issues
- Azure automatically assigns a port, the app listens on `0.0.0.0:8000` by default
- Gunicorn will bind to the correct port in production

## Cost Considerations

- **OpenAI API**: Pay per token usage
- **Azure Web App Service**: B1 tier ~$13/month (can use Free tier for testing)

## License

MIT License - feel free to use this project for learning and development.

## Support

For issues or questions, please check the Azure and OpenAI documentation.
