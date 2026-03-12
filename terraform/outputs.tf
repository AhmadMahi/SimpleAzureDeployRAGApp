output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.webapp.name
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service"
  value       = azurerm_linux_web_app.webapp.default_hostname
}

output "app_service_url" {
  description = "URL of the deployed application"
  value       = "https://${azurerm_linux_web_app.webapp.default_hostname}"
}

output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.asp.id
}

output "app_insights_instrumentation_key" {
  description = "Application Insights Instrumentation Key"
  value       = var.enable_app_insights ? azurerm_application_insights.appinsights[0].instrumentation_key : null
  sensitive   = true
}

output "staging_slot_url" {
  description = "URL of the staging slot (if enabled)"
  value       = var.enable_staging_slot ? "https://${azurerm_linux_web_app.webapp.name}-staging.azurewebsites.net" : null
}
