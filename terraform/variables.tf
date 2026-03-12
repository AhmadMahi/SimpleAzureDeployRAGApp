variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-simplerag-app"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "app_name" {
  description = "Name of the Azure Web App (must be globally unique)"
  type        = string
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "asp-simplerag"
}

variable "sku_name" {
  description = "SKU name for App Service Plan (F1=Free, B1=Basic, S1=Standard, P1V2=Premium)"
  type        = string
  default     = "B1"
}

variable "openai_api_key" {
  description = "OpenAI API Key for the RAG application"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "production"
}

variable "enable_app_insights" {
  description = "Enable Application Insights for monitoring"
  type        = bool
  default     = false
}

variable "enable_staging_slot" {
  description = "Enable staging deployment slot"
  type        = bool
  default     = false
}
