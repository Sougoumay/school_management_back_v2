output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "app_service_plan_id" {
  value = azurerm_service_plan.app_service_plan.id
}

output "container_registry_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "container_registry_admin_username" {
  value = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "container_registry_admin_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "random_names" {
  value = {
    rg_name               = random_string.rg_name.result
    app_service_plan_name = random_string.app_service_plan_name.result
    acr_name              = random_string.acr_name.result
  }
}
