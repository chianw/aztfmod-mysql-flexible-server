resource "azapi_resource_action" "allow_public_network_access" {
  type        = "Microsoft.DBforMySQL/flexibleServers@2023-06-30"
  resource_id = module.caf.mysql_flexible_server.primary_region1.id
  method      = "PATCH"

  body = jsonencode({
    properties = {
      network = {
        publicNetworkAccess = "Disabled"
      }
    }
  })
  depends_on = [module.caf.mysql_flexible_server]
}