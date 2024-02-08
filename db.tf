resource "azurerm_mssql_server" "acme-mssql" {
  name                          = "acme-mssql-id"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  version                       = "12.0"
  public_network_access_enabled = false
  administrator_login           = "sqladmin"
  administrator_login_password  = "YourPassword!123" #Password is only hardcoded here for the casestudy. However in real world scenarios, I would read this either from a 
  # keyvault or Hashicorp Vault or endup using MSI Based auth.

  minimum_tls_version = "1.2"

  azuread_administrator {
    login_username = azurerm_user_assigned_identity.ui.name
    object_id      = azurerm_user_assigned_identity.ui.principal_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.ui.id]
  }

  primary_user_assigned_identity_id            = azurerm_user_assigned_identity.ui.id
  transparent_data_encryption_key_vault_key_id = azurerm_key_vault_key.kvk.id

}

resource "azurerm_mssql_database" "acme-mssql-db" {
  name           = "acme-mssql-db"
  server_id      = azurerm_mssql_server.acme-mssql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
  enclave_type   = "VBS"
}

resource "azurerm_private_endpoint" "sqlServerendpoint" {
  name                = "sqlServerendpoint-private-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.dbsubnet.id

  private_service_connection {
    name                           = "sqlServerendpoint-private-service-connection"
    private_connection_resource_id = azurerm_mssql_server.acme-mssql.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }
}

resource "azurerm_private_dns_a_record" "dns_d" {
  name                = azurerm_mssql_server.acme-mssql.name
  zone_name           = azurerm_private_dns_zone.dns_zone_db.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 10
  records             = [azurerm_private_endpoint.sqlServerendpoint.private_service_connection.0.private_ip_address]
}
