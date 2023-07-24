output "aks" {
  value     = azurerm_kubernetes_cluster.aks
  sensitive = true
}

output "resource_group_name" {
  value = azurerm_resource_group.rg_aks.name
}
