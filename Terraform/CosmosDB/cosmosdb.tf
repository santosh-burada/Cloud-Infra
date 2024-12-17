resource "azurerm_cosmosdb_account" "main" {
  name                                  = "cosmos-origenai"
  location                              = azurerm_resource_group.main.location
  resource_group_name                   = azurerm_resource_group.main.name
  offer_type                            = "Standard"
  kind                                  = "MongoDB"
  automatic_failover_enabled            = true
  public_network_access_enabled         = false
  network_acl_bypass_for_azure_services = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = var.primary_region
    failover_priority = 0
    zone_redundant    = false
  }

  capacity {
    total_throughput_limit = 400
  }

  capabilities {
    name = "EnableMongo"
  }

}

resource "azurerm_cosmosdb_mongo_database" "mongo_db" {
  name                = "cosmos-mongo-db"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  throughput          = 400
}