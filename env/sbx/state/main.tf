terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.66.0"
    }
  }
}

provider "azurerm" {
  features {}
}

/**
* State Terraform for Azure
*/
data "azurerm_subscription" "subscription" {
}

# ------------------
# Resource Group
# ------------------
resource "azurerm_resource_group" "rg_main" {
  name     = "rg-${var.prefix}-${var.environment}-state"
  location = var.location
  tags     = var.tags
}

resource "azurerm_management_lock" "rg_main" {
  name       = "rg-lock-${var.prefix}-${var.environment}-state"
  scope      = azurerm_resource_group.rg_main.id
  lock_level = "CanNotDelete"
  notes      = "Locked for compliance"
  depends_on = [azurerm_resource_group.rg_main]
}

# ------------------
# Storage
# ------------------
resource "azurerm_storage_account" "state" {
  name                            = "st${var.prefix}${var.environment}state"
  resource_group_name             = azurerm_resource_group.rg_main.name
  location                        = azurerm_resource_group.rg_main.location
  account_kind                    = "BlobStorage"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags
  allow_nested_items_to_be_public = false

  identity {
    type = "SystemAssigned"
  }

  blob_properties {
    delete_retention_policy {
      days = 30
    }
    container_delete_retention_policy {
      days = 30
    }
  }
}

resource "azurerm_storage_container" "content" {
  name                  = "stc${var.prefix}${var.environment}state"
  storage_account_name  = azurerm_storage_account.state.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.state]
}

resource "azurerm_storage_encryption_scope" "storage_encryption" {
  name               = "microsoftmanaged"
  storage_account_id = azurerm_storage_account.state.id
  source             = "Microsoft.Storage"

  depends_on = [azurerm_storage_container.content]
}
