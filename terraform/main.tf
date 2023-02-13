#### Vars ####
variable "image_id" {
description = "Almalinux-9-x86_64-202207"
default = "b46c9eb9-39c3-4521-ac0d-b26455cc16c7"
}

locals {
 virtual_machines_apache = {
   "VM1" =     { ip_address = "192.168.0.223", volume_type="ceph-hdd", hdd_size = "10" },
   "VM2" =     { ip_address = "192.168.0.224", volume_type="ceph-hdd", hdd_size = "10" },
   "VM3" =     { ip_address = "192.168.0.227", volume_type="ceph-hdd", hdd_size = "10" }
 }
}
### end vars ###

#### Import SSH key ####
resource "openstack_compute_keypair_v2" "ssh-HAproxy" {
  name             = "ssh-HAproxy-pub"
  public_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgsDVcrm5OkdGgSgP/aOSyKQ/HW+AF79sSI8URcWeFLoLfv4Tb3MfIqgUJVLF/VXdxR+uBglzKg6As8uD6GfrnVZ5XJAH5i3SSbbUJJ8x684jIFUpHFKwT04zhkJmabRxj/hN6TZWHSK3xZ0I4Ng5ZbQniCyhfTPuaaC5Z/KC7L1k34wrF9uTNYJ95pgdrOcFTAd6cp+yiYNRtEgVsFwxPZBE/Q06LCTJP6PM75yMoI8XpHkwWHBZZmgaAs8z+Zyz6nNHwfOE1/fHqu8VYxwAcZT1t2pyk11sXw4muSxMF2CAMPBsEL1om/YtnSYw+S1pvUrmAqX9lFSt2DXqJKlbF rsa-key-20230203"
                                              }
resource "openstack_compute_keypair_v2" "ssh-ansible" {
  name             = "ssh-ansible-pub"
  public_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCEdlmnZfHOqfMIx4Y2w1E3WjVi24uZBpMjI81fDOBtSPMK/+P9Bu8cmT0Is5k8F+kIox7LdaGoTIe8ae4cTzjaM42i4K37rNIHaoJoqT0CBFKn8BqJHgxhvvxr3iy8vAT5hiXxmgzfhNCNsxaihvCTBNCv7VZy0YDT+HZstFtAn6x/DR71VIDAvXK6paplZJnsrytp/wKT870FG2snEabKKmUknWLkVjK+95Nm8s3Ct3q270hOntpN3kRRhdv8bN6IGFZpL9Bbco/Z2/j3G4qSGAztKfO/5aPCUzOH64BrdizEE84mbHFoPGF/7X2JZ1zdfj2uSD9h9XtVt49DLjCB rsa-key-20230211"
                                              }
#### End Import block ####


#### Create security group #####
resource "openstack_compute_secgroup_v2" "security_group" {
  name             = "sg_name"
  description      = "open all icmp, ssh, and http"
  rule {
    from_port      = 22
    to_port        = 22
    ip_protocol    = "tcp"
    cidr           = "0.0.0.0/0"
       }
  rule {
    from_port      = 80
    to_port        = 80
    ip_protocol    = "tcp"
    cidr           = "0.0.0.0/0"
       }
  rule {
    from_port      = -1
    to_port        = -1
    ip_protocol    = "icmp"
    cidr           = "0.0.0.0/0"
       }
		}
#### End security group block ####

#### Create disk #####
resource "openstack_blockstorage_volume_v3" "control" {
  name             = "control"
  volume_type      = "ceph-hdd"
  size             = "10"
  image_id         = var.image_id
}

resource "openstack_blockstorage_volume_v3" "HAproxy" {
  name             = "HAproxy"
  volume_type      = "ceph-hdd"
  size             = "10"
  image_id         = var.image_id
}

resource "openstack_blockstorage_volume_v3" "disk_apache" {
  for_each = local.virtual_machines_apache
  name             = each.key
  volume_type      = each.value.volume_type
  size             = each.value.hdd_size
  image_id         = var.image_id
}
#### End Create disk block ####

#### Сreate subnet ####
resource "openstack_networking_network_v2" "network_1" {
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr       = "192.168.0.0/24"
}

#### End subnet block ####


#### Create Router ####
resource "openstack_networking_router_v2" "router" {
  external_network_id = "83554642-6df5-4c7a-bf55-21bc74496109" #UUID of the floating ip network
  admin_state_up   = "true"
                                                   }
#### End router block ####


#### Adding interface to the router ####
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id        = openstack_networking_router_v2.router.id
  subnet_id        = openstack_networking_subnet_v2.subnet_1.id
  depends_on       = [openstack_networking_router_v2.router]
                                                                       }
#### End interface block ####
                                                   
#### Create VMs ####												   

resource "openstack_compute_instance_v2" "HAproxy" {

  name             = "HAproxy"
  flavor_name      = "d1.ram1cpu1"
  user_data        = "${file("HAproxy.sh")}"
  key_pair         = openstack_compute_keypair_v2.ssh-HAproxy.name
  security_groups  = [openstack_compute_secgroup_v2.security_group.name]

  network {
    uuid           = "${openstack_networking_network_v2.network_1.id}"
	fixed_ip_v4    = "192.168.0.225"
          }

  block_device {
    uuid           = "${openstack_blockstorage_volume_v3.HAproxy.id}"
    boot_index     = 0
    source_type    = "volume"
    destination_type = "volume"
               }
}

resource "openstack_compute_instance_v2" "vms_apache" {

  for_each = local.virtual_machines_apache
  name             = each.key
  flavor_name      = "d1.ram1cpu1"
  key_pair         = openstack_compute_keypair_v2.ssh-ansible.name
  security_groups  = [openstack_compute_secgroup_v2.security_group.name]

  network {
    uuid           = "${openstack_networking_network_v2.network_1.id}"
	fixed_ip_v4    = each.value.ip_address
          }

  block_device {
    uuid           = "${openstack_blockstorage_volume_v3.disk_apache[each.key].id}"
    boot_index     = 0
    source_type    = "volume"
    destination_type = "volume"
               }
}

resource "openstack_compute_instance_v2" "control" {

  name             = "control"
  flavor_name      = "d1.ram1cpu1"
  user_data        = "${file("configure.sh")}"
  key_pair         = openstack_compute_keypair_v2.ssh-ansible.name
  security_groups  = [openstack_compute_secgroup_v2.security_group.name]
  depends_on       = [openstack_compute_instance_v2.HAproxy, openstack_compute_instance_v2.vms_apache]

  network {
    uuid           = "${openstack_networking_network_v2.network_1.id}"
	fixed_ip_v4    = "192.168.0.226"
          }

  block_device {
    uuid           = "${openstack_blockstorage_volume_v3.control.id}"
    boot_index     = 0
    source_type    = "volume"
    destination_type = "volume"
               }
}										   												      
#### End Create Instans block ####

#### Allocate ip to the project ####
resource "openstack_networking_floatingip_v2" "instance_fip" {
  pool             = "FloatingIP Net"
                                                             }
#### End Allocate IP block ####

#### Assign floating IP ####
resource "openstack_compute_floatingip_associate_v2" "instance_fip_association" {  

  floating_ip      = openstack_networking_floatingip_v2.instance_fip.address
  instance_id      = openstack_compute_instance_v2.HAproxy.id
  fixed_ip         = openstack_compute_instance_v2.HAproxy.access_ip_v4  
                                                                              }
																			  
#### End Assign floadting IP block ####