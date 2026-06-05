output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "endpoint_subnet_id" {
  value = azurerm_subnet.endpoints.id
}

output "jumpbox_public_ip" {
  value = azurerm_public_ip.jumpbox_ip.ip_address
}