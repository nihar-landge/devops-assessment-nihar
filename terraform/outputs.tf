output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "jumpbox_public_connect_ip" {
  value       = module.custom_network.jumpbox_public_ip
}