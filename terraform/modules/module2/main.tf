provider "azurerm" {
  features {}
}

resource "random_id" "web_app_suffix" {
  byte_length = 6
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "my-app-webapp-${random_id.web_app_suffix.hex}"
  location            = "France Central"
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id

  site_config {
    application_stack {
      docker_image_name = "api:1.0.0"
      docker_registry_url = "https://${var.container_registry_login_server}"
      docker_registry_username = var.container_registry_admin_username
      docker_registry_password = var.container_registry_admin_password
    }
  }

  app_settings = {
    "WEBSITES_CONTAINER_START_TIME_LIMIT" = "1800"

    # Activation de l'intégration Application Insights
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.app_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.app_insights.connection_string

    # Activation de la télémétrie automatique (si supportée)
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }

  tags = {
    environment = "production"
  }
}

# Application Insights
resource "azurerm_application_insights" "app_insights" {
  name                = "app-insights-${random_id.web_app_suffix.hex}"
  location            = "France Central"
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

# Static Web App
resource "azurerm_static_web_app" "static_web_app" {
  name                = "static-web-app-${random_id.web_app_suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = "West Europe"

  sku_tier = "Standard"
  sku_size = "Standard"

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "REACT_APP_API_URL" = azurerm_linux_web_app.web_app.default_hostname
  }

  tags = {
    environment = "production"
  }
}