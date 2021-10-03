resource "azurerm_resource_group" "rg" {
  name     = "shipa-testing-v1"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "shipa-testing-v1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "mysticrenjiv1"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}



# Create team
resource "shipa_team" "team" {
  team {
    name = "dev"
    tags = ["dev"]
  }
}

# Create plan
resource "shipa_plan" "plan" {
  plan {
    name     = "shipa-plan-v2"
    teams    = [shipa_team.team.team[0].name]
    cpushare = 4
    memory   = 0
    swap     = 0
  }
  depends_on = [shipa_team.team]
}

resource "shipa_framework" "framework" {
  framework {
    name        = "default-framework"
    provisioner = "kubernetes"
    resources {
      general {
        setup {
          public  = true
          default = false
        }
        security {
          disable_scan         = true
          scan_platform_layers = false
        }
        router = "traefik"
        app_quota {
          limit = "2"
        }
        access {
          append = [shipa_team.team.team[0].name]
        }
        plan {
          name = shipa_plan.plan.plan[0].name
        }
      }
    }
  }
  depends_on = [shipa_plan.plan, shipa_team.team]
}

output "my_tf_framework" {
  value = shipa_framework.framework
}

resource "shipa_app" "application" {
  app {
    name      = "terraformapp"
    teamowner = shipa_team.team.team[0].name
    framework = shipa_framework.framework.framework[0].name
    tags        = ["dev"]
  }
  depends_on = [
    shipa_framework.framework,shipa_team.team
  ]
}

resource "shipa_app_deploy" "tf" {
  app = shipa_app.application.app[0].name
  deploy {
    image = "docker.io/shipasoftware/bulletinboard:1.0"
  }
}

# #Create cluster
resource "shipa_cluster" "tf" {
  cluster {
    name = "azurekubernetes"
    endpoint {
      addresses = [var.cluster_address]
      ca_cert   = file(var.cluster_ca_path)
      token     = var.cluster_token
    }

    resources {
      frameworks {
        name = [
          shipa_framework.framework.framework[0].name,
        ]
      }
    }
  }
  depends_on = [shipa_framework.framework]
}

# # Create user
# resource "shipa_user" "tf" {
#   email    = "mysticrenji@shipa.com"
#   password = "terraform"
# }

# # Create plan
# resource "shipa_plan" "tf" {
#   plan {
#     name     = "terraform-plan"
#     teams    = [shipa_team.tf.team[0].name]
#     cpushare = 4
#     memory   = 0
#     swap     = 0
#   }
#   depends_on = [shipa_team.tf]
# }

# # Create team
# resource "shipa_team" "tf" {
#   team {
#     name = "dev"
#     tags = ["dev"]
#   }
# }

# # Create app
# resource "shipa_app" "tf" {
#   app {
#     name        = "app1"
#     teamowner   = shipa_team.tf.team[0].name
#     framework   = shipa_framework.tf.framework[0].name
#     description = "test description update"
#     tags        = ["dev"]
#   }
#   # depends_on = [shipa_cluster.tf]
# }

# # Set app envs
# resource "shipa_app_env" "tf" {
#   app = shipa_app.tf.app[0].name
#   app_env {
#     envs {
#       name  = "SHIPA_ENV1"
#       value = "test-1"
#     }
#     envs {
#       name  = "SHIPA_ENV2"
#       value = "test-2"
#     }
#     norestart = true
#     private   = false
#   }
#   depends_on = [shipa_app_deploy.tf]
# }

# # Set app cname
# resource "shipa_app_cname" "tf" {
#   app     = shipa_app.tf.app[0].name
#   cname   = "test.com"
#   encrypt = true
# }

# # Deploy app


# # Create role
# resource "shipa_role" "role1" {
#   name    = "RoleName"
#   context = "app"
#   // Optional
#   description = "test"
# }

# # Create role permission
# resource "shipa_permission" "p1" {
#   name       = shipa_role.role1.name
#   permission = ["app.read", "app.deploy"]
# }

# # Create role association
# resource "shipa_role_association" "r1" {
#   name  = shipa_role.role1.name
#   email = shipa_user.tf.email
# }