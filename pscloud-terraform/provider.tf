#### Configure the OpenStack Provider ####
terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" {
  user_name   = "11348"
  tenant_name = "project"
  password    = "y3hBhq)byavc"
  auth_url    = "https://auth.pscloud.io/v3/"
  region      = "kz-ala-1"
                     }


#### End config block ####