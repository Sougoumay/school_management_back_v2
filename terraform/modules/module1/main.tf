provider "azurerm" {
  features {}
}

# Générer un nom aléatoire pour le Resource Group
resource "random_string" "rg_name" {
  length  = 12
  special = false
  upper   = false
}

# Générer un nom aléatoire pour l'App Service Plan
resource "random_string" "app_service_plan_name" {
  length  = 12
  special = false
  upper   = false
}

# Générer un nom aléatoire pour le Container Registry
resource "random_string" "acr_name" {
  length  = 12
  special = false
  upper   = false
}

# Création du Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${random_string.rg_name.result}"
  location = "France Central"
}

# App Service Plan (F1 - Gratuit)
resource "azurerm_service_plan" "app_service_plan" {
  name                = "asp-${random_string.app_service_plan_name.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "S1"
}

# Container Registry (Standard - Minimum requis)
resource "azurerm_container_registry" "acr" {
  name                = "acr${random_string.acr_name.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "France Central"
  sku                 = "Standard"
  admin_enabled       = true
}