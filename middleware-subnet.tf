resource "azurerm_subnet" "middlewaresubnet" {
  name                 = "middleware-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.87.0/24"]
}


resource "azurerm_network_security_group" "mw_subnet_nsg" {
  name                = "${azurerm_subnet.middlewaresubnet.name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_subnet_network_security_group_association" "mw_subnet_nsg_associate" {
  depends_on                = [azurerm_network_security_rule.mw_nsg_rule_inbound]
  subnet_id                 = azurerm_subnet.middlewaresubnet.id
  network_security_group_id = azurerm_network_security_group.mw_subnet_nsg.id
}


resource "azurerm_network_security_rule" "mw_nsg_rule_inbound" {
  for_each                    = local.mw_inbound_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.mw_subnet_nsg.name
}
