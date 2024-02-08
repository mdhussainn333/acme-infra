resource "azurerm_private_dns_zone" "dns_zone_sites" {
  name                = "privatelink.sites.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link_sites" {
  name                  = "sites-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone_sites.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}


resource "azurerm_private_dns_zone" "dns_zone_db" {
  name                = "privatelink.sqlServer.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link_db" {
  name                  = "sqlServer-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone_db.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}