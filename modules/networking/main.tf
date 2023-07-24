resource "azurerm_resource_group" "rg_vnet" {
  name     = "rg-${var.prefix}-${var.environment}-vnet"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.prefix}-${var.environment}-network"
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = ["10.30.0.0/16"]
}

## Create subnet

resource "azurerm_subnet" "subnet" {
  name                 = "sn-${var.prefix}-${var.environment}-aks"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.30.1.0/24"]
}
