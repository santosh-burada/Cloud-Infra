resource "azurerm_resource_group" "main" {
  name     = "rg_${var.application_name}_${var.environment_name}"
  location = var.primary_region
}