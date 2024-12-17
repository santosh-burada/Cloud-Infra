resource "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_workload" {
  name                  = "dns-link-cosmos-workload"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

resource "azurerm_private_endpoint" "cosmos" {
  name                = "pep-${azurerm_cosmosdb_account.main.name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = azurerm_subnet.vpn.id

  private_service_connection {
    name                           = "${azurerm_cosmosdb_account.main.name}-link"
    private_connection_resource_id = azurerm_cosmosdb_account.main.id # this field tell us, to which azure resource we are linking this private endpoint
    subresource_names              = ["MongoDB"]
    is_manual_connection           = false
  }
  private_dns_zone_group { # this block is important to create a link between private endpoint and private DNS zone. Without this block we can't create the recordsets.
  # in private DNS zone.
    name                 = "cosmos-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos.id]
  }
}