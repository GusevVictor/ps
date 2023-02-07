#### Configure the OpenStack Provider ####
terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" {
  user_name   = "user"
  tenant_name = "project"
  password    = "pass"
  auth_url    = "https://auth.pscloud.io/v3/"
  region      = "kz-ala-1"
                     }


#### End config block ####