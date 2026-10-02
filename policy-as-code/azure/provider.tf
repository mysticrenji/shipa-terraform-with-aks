terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.8.0"
    }

    shipa = {
      version = "0.0.18"
      source  = "shipa-corp/shipa"

    }
  }
}


provider "azurerm" {
  features {}
}

