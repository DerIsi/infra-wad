output "vnet" {
  value       = azurerm_virtual_network.vnet
  description = "Reference to the virtual network"
}

output "subnet" {
  value       = azurerm_subnet.subnet
  description = "Reference to all subnets of the virtual network"
}
