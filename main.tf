terraform {
  required_providers {
  }
  required_version = ">= 1.9.2"
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  alias                      = "vhub"
}

module "caf" {
  source  = "github.com/chianw/terraform-azurerm-caf?ref=mysqlflexpe"
#   version = "5.7.13"

  providers = {
    azurerm.vhub = azurerm.vhub
  }

  global_settings = var.global_settings
  resource_groups = var.resource_groups
  keyvaults       = var.keyvaults
  database = {
    mysql_flexible_server = var.mysql_flexible_server
  }
  networking = {
    vnets = var.vnets
    # dns_zones = var.dns_zones
  }
}