terraform {
  required_version = ">= 1.5.7"
}

variable "pool" {
  description = "Slurm pool of compute nodes"
  default = []
}

module "openstack" {
  source         = "git::https://github.com/ComputeCanada/magic_castle.git//openstack?ref=15.1.0"
  config_git_url = "https://github.com/ComputeCanada/puppet-magic_castle.git"
  config_version = "15.1.0"
  # Uncomment to create a cluster on the Beluga cloud
  #subnet_id = "a7f9fef1-a43e-4502-83a9-e47c936b635d"

  cluster_name = "winter2026-uofa"
  domain       = "c3.ca"
  image        = "Rocky-9"

  instances = {
    mgmt   = { type = "p4-7.5gb", tags = ["puppet", "mgmt", "nfs"], count = 1 }
    login  = { type = "c8-30gb", tags = ["login", "public", "proxy"], count = 1 }
    node   = { type = "c8-30gb", tags = ["node"], count = 1 }
    #gpu-node   = { type = "g1-8gb-c4-22gb", tags = ["node"], count = 4 }
  }

  # var.pool is managed by Slurm through Terraform REST API.
  # To let Slurm manage a type of nodes, add "pool" to its tag list.
  # When using Terraform CLI, this parameter is ignored.
  # Refer to Magic Castle Documentation - Enable Magic Castle Autoscaling
  pool = var.pool

  volumes = {
    nfs = {
      home     = { size = 200, enable_resize = true }
      project  = { size = 50, enable_resize = true }
      scratch  = { size = 50, enable_resize = true }
    }
  }

  public_keys = compact(concat(split("\n", file("../keys/sshkeys.pub")), ))

  nb_users = 0
  # Shared password, randomly chosen if blank
  guest_passwd = ""
  
  hieradata = file("./config.yaml")
}

output "accounts" {
  value = module.openstack.accounts
}

output "public_ip" {
  value = module.openstack.public_ip
}

## Uncomment to register your domain name with CloudFlare
module "dns" {
  source           = "git::https://github.com/ComputeCanada/magic_castle.git//dns/cloudflare"
  name             = module.openstack.cluster_name
  domain           = module.openstack.domain
  public_instances = module.openstack.public_instances
}

## Uncomment to register your domain name with Google Cloud
# module "dns" {
#   source           = "git::https://github.com/ComputeCanada/magic_castle.git//dns/gcloud"
#   project          = "your-project-id"
#   zone_name        = "you-zone-name"
#   name             = module.openstack.cluster_name
#   domain           = module.openstack.domain
#   public_instances = module.openstack.public_instances
# }

#output "hostnames" {
#  value = module.dns.hostnames
#}
