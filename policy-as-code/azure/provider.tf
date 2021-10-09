terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.76.0"
    }

    shipa = {
      version = "0.0.5"
      source  = "shipa-corp/shipa"

    }
  }
}


provider "azurerm" {
  features {}
}

