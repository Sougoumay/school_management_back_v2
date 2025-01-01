variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
}

variable "app_service_plan_id" {
  description = "ID du App Service Plan"
  type        = string
}

variable "container_registry_login_server" {
  description = "Serveur de login pour le Container Registry"
  type        = string
}

variable "container_registry_admin_username" {
  description = "Nom d'utilisateur admin pour le Container Registry"
  type        = string
}

variable "container_registry_admin_password" {
  description = "Mot de passe admin pour le Container Registry"
  type        = string
  sensitive   = true
}
