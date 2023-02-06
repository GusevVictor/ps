#### Vars ####
variable "image_id" {
default = "f524facf-2447-4c9c-aa16-83b25a44b90c"
}
#### End vars block####
#### Import SSH key ####
resource "openstack_compute_keypair_v2" "ssh" {
  name             = "keypair_name"
  public_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgsDVcrm5OkdGgSgP/aOSyKQ/HW+AF79sSI8URcWeFLoLfv4Tb3MfIqgUJVLF/VXdxR+uBglzKg6As8uD6GfrnVZ5XJAH5i3SSbbUJJ8x684jIFUpHFKwT04zhkJmabRxj/hN6TZWHSK3xZ0I4Ng5ZbQniCyhfTPuaaC5Z/KC7L1k34wrF9uTNYJ95pgdrOcFTAd6cp+yiYNRtEgVsFwxPZBE/Q06LCTJP6PM75yMoI8XpHkwWHBZZmgaAs8z+Zyz6nNHwfOE1/fHqu8VYxwAcZT1t2pyk11sXw4muSxMF2CAMPBsEL1om/YtnSYw+S1pvUrmAqX9lFSt2DXqJKlbF rsa-key-20230203"
                                              }
#### End Import block ####
#### Create Network ####
resource "openstack_networking_network_v2" "private_network" {
  name             = "network_name"
  admin_state_up   = "true"
                                                             }
#### End Network block ####
#### Сreate subnet ####
resource "openstack_networking_subnet_v2" "private_subnet" {
  name             = "subnet_name"
  network_id       = openstack_networking_network_v2.private_network.id
  cidr             = "192.168.0.0/24"
  dns_nameservers  = [
                      "195.210.46.195",
                      "195.210.46.132"
                     ]
  ip_version       = 4
  enable_dhcp      = true
  depends_on = [openstack_networking_network_v2.private_network]
                                                           }
#### End subnet block ####
#### Create Router ####
resource "openstack_networking_router_v2" "router" {
  name             = "router_name"
  external_network_id = "83554642-6df5-4c7a-bf55-21bc74496109" #UUID of the floating ip network
  admin_state_up   = "true"
  depends_on = [openstack_networking_network_v2.private_network]
                                                   }
#### End router block ####
#### Adding interface to the router ####
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id        = openstack_networking_router_v2.router.id
  subnet_id        = openstack_networking_subnet_v2.private_subnet.id
  depends_on       = [openstack_networking_router_v2.router]
                                                                       }
#### End interface block ####
#### Allocate ip to the project ####
resource "openstack_networking_floatingip_v2" "instance_fip" {
  pool             = "FloatingIP Net"
                                                             }
#### End Allocate IP block ####
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

#### Create Disk ####
# Searching for the image ID (that the server will be created from) by its name
data "openstack_images_image_v2" "alma_image" {
  most_recent = true
  visibility  = "public"
  name        = "AlmaLinux-8.x86_64-202205"
}

resource "openstack_blockstorage_volume_v3" "volume_server" {
  name                 = "volume_server"
  size                 = "6"
  image_id             = data.openstack_images_image_v2.alma_image.id
  volume_type          = "ceph-hdd"
  enable_online_resize = true
}

#### End Create disk block ####

#### Create Instanse ####
resource "openstack_compute_instance_v2" "instance" {
  name             = "haproxy"
  flavor_name      = "d1.ram2cpu1"
  key_pair         = openstack_compute_keypair_v2.ssh.name
  security_groups  = [openstack_compute_secgroup_v2.security_group.name]
  depends_on = [
                openstack_networking_network_v2.private_network,
                openstack_blockstorage_volume_v3.vm-06
]
  network {
    uuid           = openstack_networking_network_v2.private_network.id
          }
  block_device {
    uuid           = openstack_blockstorage_volume_v3.volume_server.id
    boot_index     = 0
    source_type    = "volume"
    destination_type = "volume"
    delete_on_termination = false
               }

                                                   }
											   												      
#### End Create Instans block ####


#### Assign floating IP ####
resource "openstack_compute_floatingip_associate_v2" "instance_fip_association" {
  floating_ip      = openstack_networking_floatingip_v2.instance_fip.address
  instance_id      = openstack_compute_instance_v2.instance.id
  fixed_ip         = openstack_compute_instance_v2.instance.access_ip_v4
                                                                                }
#### End Assign floadting IP block ####