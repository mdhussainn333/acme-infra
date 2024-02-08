data "azurerm_client_config" "current" {}


resource "azurerm_user_assigned_identity" "ui" {
  name                = "kv-admin"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
