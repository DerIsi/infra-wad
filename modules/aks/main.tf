
resource "azurerm_resource_group" "rg_aks" {
  name     = "rg-${var.prefix}-${var.environment}-aks"
  location = var.location
  tags     = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.prefix}-${var.environment}-nuke"
  location            = azurerm_resource_group.rg_aks.location
  resource_group_name = azurerm_resource_group.rg_aks.name
  dns_prefix          = "aks-${var.prefix}-${var.environment}-nuke"

  default_node_pool {
    name           = "default"
    node_count     = 2
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = var.snet_aks.id
  }

  network_profile {
    network_plugin = "none"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "WAD Nuking"
  }
}

