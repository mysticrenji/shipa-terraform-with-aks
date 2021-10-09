
module "policy-as-code" {
  source          = "./modules/policy-as-code"
  teamname        = var.teamname
  teamtag         = var.teamtag
  frameworkname   = var.frameworkname
  provisioner     = var.provisioner
  plan            = var.plan
  clustername     = var.clustername
  cluster_address = var.cluster_address
  cluster_ca_path = var.cluster_ca_path
  cluster_token   = var.cluster_token
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