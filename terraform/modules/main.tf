module "module1" {
  source = "./module1"
}

module "module2" {
  source = "./module2"

  # Passer les outputs de module1 comme inputs pour module2
  resource_group_name                = module.module1.resource_group_name
  app_service_plan_id                = module.module1.app_service_plan_id
  container_registry_login_server    = module.module1.container_registry_login_server
  container_registry_admin_username  = module.module1.container_registry_admin_username
  container_registry_admin_password  = module.module1.container_registry_admin_password
}
