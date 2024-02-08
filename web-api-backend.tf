resource "azurerm_service_plan" "acme" {
  name                = "acme-appservice-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "acme_web_api_backend" {
  name                = "acme-web-api-backend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.acme.id
  site_config {
    application_stack {
      dotnet_version = "7.0"
    }

  }
}

# resource "azurerm_private_endpoint" "acme" {
#   name                = "acme-private-endpoint"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   subnet_id           = "/subscriptions/your-subscription-id/resourceGroups/your-rg-name/providers/Microsoft.Network/virtualNetworks/your-vnet-name/subnets/your-subnet-name"

#   private_service_connection {
#     name                           = "acme-privateservice-connection"
#     private_connection_resource_id = azurerm_web_app.acme.id
#     is_manual_connection           = false
#   }
# }

# resource "azurerm_private_dns_zone" "acme" {
#   name                = "privatelink.azurewebsites.net"
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_private_dns_record_set" "acme" {
#   name                = "acme-webapp"
#   zone_name           = azurerm_private_dns_zone.rg.name
#   resource_group_name = azurerm_resource_group.rg.name
#   ttl                 = 300
#   records             = [azurerm_web_app.acme.default_site_hostname]
# }
