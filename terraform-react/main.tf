provider "azurerm" {
  features {}
   subscription_id = "80725b9c-38b3-402c-872fec66539e39d9"
}

resource "azurerm_resource_group" "rgas" {
  name     = "rg-jenkins-react-01"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "deep_app_service_plan"
  location            = azurerm_resource_group.rgas.location
  resource_group_name = azurerm_resource_group.rgas.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "my-app_service" {
  name                = "deep-react-integrated-dot-net"
  location            = azurerm_resource_group.rgas.location
  resource_group_name = azurerm_resource_group.rgas.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}