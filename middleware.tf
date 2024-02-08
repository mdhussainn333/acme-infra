resource "azurerm_service_plan" "acme_middleware" {
  name                = "acme-middlewareservice-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "acme_middle_ware_backend" {
  name                = "acme-middleware-service"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.acme_middleware.id
  public_network_access_enabled = false
  site_config {
    application_stack {
      dotnet_version = "7.0"
    }

  }
}


resource "azurerm_private_endpoint" "endpoint" {
  name                = "sites-private-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.middlewaresubnet.id

  private_service_connection {
    name                           = "middleware-private-service-connection"
    private_connection_resource_id = azurerm_linux_web_app.acme_middle_ware_backend.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}

resource "azurerm_private_dns_a_record" "dns_a" {
  name                = azurerm_linux_web_app.acme_middle_ware_backend.name
  zone_name           = azurerm_private_dns_zone.dns_zone_sites.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 10
  records             = [azurerm_private_endpoint.endpoint.private_service_connection.0.private_ip_address]
}