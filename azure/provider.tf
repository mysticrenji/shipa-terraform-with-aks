terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.43.0"
    }

    shipa = {
      version = "0.0.18"
      source  = "shipa-corp/shipa"
    }
  }
}

provider "azurerm" {
  version = ">2.0"
  features {}
}

provider "shipa" {
  host  = "http://target.shipa.cloud:8080"
  token = "<token>"
}