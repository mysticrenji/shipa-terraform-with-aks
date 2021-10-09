terraform {
  required_providers {

    shipa = {
      version = "0.0.5"
      source  = "shipa-corp/shipa"
      
    }
  }
}

# Create app
resource "shipa_app" "application" {
  app {
    name        = var.applicationname
    teamowner   = var.teamname
    framework   = var.frameworkname
    description = var.appdescription
    tags        = [var.teamtag]
  }
}

# App deploy
resource "shipa_app_deploy" "deploy" {
  app = var.applicationname
  deploy {
    image = var.dockerimage
  }
  depends_on = [shipa_app.application]
}

# Set app envs
resource "shipa_app_env" "environmentconfig" {
  app = var.applicationname
  app_env {
    envs {
      name  = "DBConnection"
      value = "ConnectionString1"
    }
    envs {
      name  = "WebConnection"
      value = "ConnectionString2"
    }
    norestart = true
    private   = false
  }
  depends_on = [shipa_app_deploy.deploy]
}