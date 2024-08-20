global_settings = {
  default_region = "region1"
  regions = {
    region1 = "australiaeast"
  }
}

resource_groups = {
  mysql_region1 = {
    name   = "mysql-region1"
    region = "region1"
  }
  security_region1 = {
    name = "security-region1"
  }
}

mysql_flexible_server = {
  primary_region1 = {
    name     = "vks-flexible-testservers"
    version  = "8.0.21" #Possible values are 5.7, and 8.0.21
    sku_name = "GP_Standard_D2ds_v4"
    zone     = 1
    resource_group = {
      key = "mysql_region1"
      # lz_key = ""                           # Set the lz_key if the resource group is remote.
    }

    private_dns_zone_id = "dns_zone1"

    # Auto-generated administrator credentials stored in azure keyvault when not set (recommended).
    #administrator_username  = "psqladmin"
    #administrator_password  = "ComplxP@ssw0rd!"
    keyvault = {
      key = "mysql_region1" # (Required) when auto-generated administrator credentials needed.
      # lz_key      = ""                      # Set the lz_key if the keyvault is remote.
    }

    # [Optional] Firewall Rules for Public Access
    # mysql_firewall_rules = {
    #   mysql-firewall-rule1 = {
    #     name             = "mysql-firewall-rule1"
    #     start_ip_address = "10.0.1.10"
    #     end_ip_address   = "10.0.1.11"
    #   }
    #   mysql-firewall-rule2 = {
    #     name             = "mysql-firewall-rule2"
    #     start_ip_address = "10.0.2.10"
    #     end_ip_address   = "10.0.2.11"
    #   }
    # }

    # [Optional] Server Configurations
    mysql_configurations = {
      mysql_configurations = {
        name  = "interactive_timeout"
        value = "600"
      }

    }
    # [Optional] Database Configurations
    mysql_databases = {
      flex_mysql_database = {
        name      = "exampledb"
        collation = "utf8mb3_unicode_ci"
        charset   = "utf8mb3"
      }
    }

    tags = {
      server = "MysqlFlexible"
    }

    private_endpoints = {
      private-link-level4 = {
        name       = "sales-sql-rg1"
        vnet_key   = "vnet_region1"
        subnet_key = "private_dns"
        #subnet_id          = "/subscriptions/97958dac-f75b-4ee3-9a07-9f436fa73bd4/resourceGroups/ppga-rg-sql-rg1/providers/Microsoft.Network/virtualNetworks/ppga-vnet-testvnet1/subnets/ppga-snet-web-subnet"
        resource_group_key = "sql_region1"

        private_service_connection = {
          name                 = "sales-sql-rg1"
          is_manual_connection = false
          subresource_names    = ["mysqlServer"]
        }

        # private_dns = {
        #   zone_group_name = "privatelink_database_windows_net"
        #   # lz_key          = ""   # If the DNS keys are deployed in a remote landingzone
        #   keys = ["privatelink"]
        # }
      }        
    }

  }

}

keyvaults = {
  mysql_region1 = {
    name                = "mysql-region123"
    resource_group_key  = "security_region1"
    sku_name            = "standard"
    soft_delete_enabled = true
    creation_policies = {
      logged_in_user = {
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge"]
      }
    }
  }
}

vnets = {
  vnet_region1 = {
    resource_group_key = "mysql_region1"
    region             = "region1"
    vnet = {
      name          = "mysql"
      address_space = ["10.10.0.0/24"]
    }
    subnets = {
      private_dns = {
        name                                           = "private-dns"
        cidr                                           = ["10.10.0.0/25"]
        enforce_private_link_endpoint_network_policies = true
        enforce_private_link_service_network_policies  = false
      }
    #   mysql = {
    #     name                                           = "mysql"
    #     cidr                                           = ["10.10.0.128/25"]
    #     enforce_private_link_endpoint_network_policies = true
    #     delegation = {
    #       name               = "mysql"
    #       service_delegation = "Microsoft.DBforMySQL/flexibleServers"
    #       actions = [
    #         "Microsoft.Network/virtualNetworks/subnets/join/action",
    #       ]
    #     }
    #   }
    }
  }
}