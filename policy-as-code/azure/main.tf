provider "shipa" {
  host  = var.shipahost
  token = var.shipatoken
}

# Module for dev - policy as code
module "policy-as-code-dev" {
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

# Module for dev - app deploy
module "app-deploy-dev" {
  source          = "./modules/app-deploy"
  teamname        = var.teamname
  teamtag         = var.teamtag
  frameworkname   = var.frameworkname
  applicationname = var.applicationname
  appdescription  = var.appdescription
  dockerimage     = var.dockerimage
  depends_on      = [module.policy-as-code-dev]
}