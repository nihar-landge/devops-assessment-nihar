variable "resource_group_name" {
  type        = string
  default     = "rg-cloudmaven-secure"
}


variable "location" {
  type        = string
  default     = "centralindia"
}

variable "cluster_name" {
  type        = string
  default     = "aks-cloudmaven-cluster"
}

variable "aks_vm_size" {
  type        = string
  default     = "Standard_D2as_v4" 
}

variable "node_count" {
  type        = number
  default     = 1
}