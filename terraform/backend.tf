terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-mgmt"
    storage_account_name = "stdevopsassessmentstate"
    container_name       = "tfstate"
    key                  = "assessment.terraform.tfstate"
  }
}