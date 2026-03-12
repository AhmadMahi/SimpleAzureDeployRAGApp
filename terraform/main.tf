terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "SimpleRAGApp"
  }
}

# App Service Plan (Linux)
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.sku_name

  tags = {
    Environment = var.environment
    Project     = "SimpleRAGApp"
  }
}

# Linux Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = var.app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = var.sku_name != "F1" ? true : false
    
    application_stack {
      python_version = "3.11"
    }

    # Startup command
    app_command_line = "gunicorn --bind=0.0.0.0 --timeout 600 app:app"
  }

  app_settings = {
    "OPENAI_API_KEY"                  = var.openai_api_key
    "SCM_DO_BUILD_DURING_DEPLOYMENT"  = "true"
    "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = "7"
  }

  https_only = true

  tags = {
    Environment = var.environment
    Project     = "SimpleRAGApp"
  }

  lifecycle {
    ignore_changes = [
      site_config[0].scm_type
    ]
  }
}

# Optional: Enable application insights
resource "azurerm_application_insights" "appinsights" {
  count               = var.enable_app_insights ? 1 : 0
  name                = "${var.app_name}-insights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"

  tags = {
    Environment = var.environment
    Project     = "SimpleRAGApp"
  }
}

# Add App Insights connection string to web app if enabled
resource "azurerm_linux_web_app_slot" "webapp_staging" {
  count          = var.enable_staging_slot ? 1 : 0
  name           = "staging"
  app_service_id = azurerm_linux_web_app.webapp.id

  site_config {
    always_on = var.sku_name != "F1" ? true : false
    
    application_stack {
      python_version = "3.11"
    }

    app_command_line = "gunicorn --bind=0.0.0.0 --timeout 600 app:app"
  }

  app_settings = {
    "OPENAI_API_KEY"                  = var.openai_api_key
    "SCM_DO_BUILD_DURING_DEPLOYMENT"  = "true"
  }

  https_only = true
}
