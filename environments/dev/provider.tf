terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "desh-rg"
    storage_account_name = "deshstg0001"
    container_name       = "dp-container"
    key                  = "dp.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "dc1b0d18-b7a7-4981-90c1-5f01ea6fc258"
}
