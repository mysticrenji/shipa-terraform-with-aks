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

provider "shipa" {
  host  = "http://target.shipa.cloud:8080"
  token = "a92d55249e71733fd526d650199bb411cdd9afd54647fa293369a77f292adb79"
}
