variable "resource_group_name" {
  type        = string
  description = "Parent resource group name"
}

variable "location" {
  type        = string
  description = "Target Azure region"
}

variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# The three isolated network tiers
variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "aks_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "endpoint_subnet_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "my_home_ip" {
  type        = string
  default     = "0.0.0.0"
  description = "Your exact personal internet IP to secure the jumpbox firewall"
}

variable "tags" {
  type    = map(string)
  default = {}
}