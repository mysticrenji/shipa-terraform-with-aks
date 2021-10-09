terraform {
  required_providers {

    shipa = {
      version = "0.0.5"
      source  = "shipa-corp/shipa"
      
    }
  }
}

# Create team
resource "shipa_team" "team" {
  team {
    name = var.teamname
    tags = [var.teamtag]
  }
}

# Shipa framework
resource "shipa_framework" "framework" {
  framework {
    name        = var.frameworkname
    provisioner = var.provisioner
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
          limit = "4"
        }
        access {
          append = [shipa_team.team.team[0].name]
        }
        plan {
          name = var.plan
        }
      }
    }
  }
  depends_on = [ shipa_team.team]
}

# Create entry for the cluster
resource "shipa_cluster" "cluster" {
  cluster {
    name = var.clustername
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
