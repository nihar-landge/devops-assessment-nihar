resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "clouddrove_labels" {
  source      = "clouddrove/labels/azure"
  version     = "1.0.0"
  name        = "nihar-secure-infra"
  environment = "dev"
  label_order = ["name", "environment"]
}

module "custom_network" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  my_home_ip          = "0.0.0.0" # Change this to your home IP address for testing
  tags                = module.clouddrove_labels.tags
}


resource "azurerm_kubernetes_cluster" "aks" {
  depends_on = [
    module.custom_network
  ]
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "cloudmaven-secure-k8s"

  oidc_issuer_enabled = true

  default_node_pool {
    name           = "agentpool"
    node_count     = var.node_count  
    vm_size        = var.aks_vm_size 
    vnet_subnet_id = module.custom_network.aks_subnet_id 
    type           = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"

    service_cidr   = "172.16.0.0/16"    
    dns_service_ip = "172.16.0.10"  
  }
  tags = module.clouddrove_labels.tags
}

resource "azurerm_storage_account" "storage" {
  name                     = "stcloudmavensecurev2"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  

  public_network_access_enabled = false
  tags                          = module.clouddrove_labels.tags
}

resource "azurerm_private_endpoint" "storage_pe" {
  name                = "pe-storage-blob"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.custom_network.endpoint_subnet_id

  private_service_connection {
    name                           = "psc-storage-link"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  tags = module.clouddrove_labels.tags
}


resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "link-dns-to-vnet"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = module.custom_network.vnet_id
}


resource "azurerm_private_dns_a_record" "storage_dns_a" {
  name                = "stcloudmavensecurev2"
  zone_name           = azurerm_private_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.storage_pe.private_service_connection[0].private_ip_address]
}
