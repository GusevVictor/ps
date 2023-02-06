#### Create Disk ####
resource "openstack_blockstorage_volume_v3" "control-vm" {
  name                 = "control-vm"
  size                 = "6"
  image_id             = data.openstack_images_image_v2.alma_image.id
  volume_type          = "ceph-hdd"
  enable_online_resize = true
}
#### End Create disk block ####
#### Create Instanse ####
resource "openstack_compute_instance_v2" "control-vm" {
  name             = "control-vm"
  flavor_name      = "d1.ram1cpu1"
  key_pair         = openstack_compute_keypair_v2.ssh.name
  security_groups  = [openstack_compute_secgroup_v2.security_group.name]
  depends_on = [
                openstack_networking_network_v2.private_network,
                openstack_blockstorage_volume_v3.control-vm
]  
  network {
    uuid           = openstack_networking_network_v2.private_network.id
          }
  block_device {
    uuid           = openstack_blockstorage_volume_v3.control-vm.id
    boot_index     = 0
    source_type    = "volume"
    destination_type = "volume"
    delete_on_termination = false
               }
                                                   }
#### End Create Instans block ####

												   