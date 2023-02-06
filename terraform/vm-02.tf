#### Create Disk ####
resource "openstack_blockstorage_volume_v3" "vm-02" {
  name                 = "vm-02"
  size                 = "6"
  image_id             = data.openstack_images_image_v2.alma_image.id
  volume_type          = "ceph-hdd"
  enable_online_resize = true
}
#### End Create disk block ####
#### Create Instanse ####
resource "openstack_compute_instance_v2" "vm-02" {
  name             = "vm-02"
  flavor_name      = "d1.ram1cpu1"
  key_pair         = openstack_compute_keypair_v2.ssh.name
  security_groups  = [openstack_compute_secgroup_v2.security_group.name]
  depends_on = [
                openstack_networking_network_v2.private_network,
                openstack_blockstorage_volume_v3.vm-02
]  
  network {
    uuid           = openstack_networking_network_v2.private_network.id
          }
  block_device {
    uuid           = openstack_blockstorage_volume_v3.vm-02.id
    boot_index     = 0
    source_type    = "volume"
    destination_type = "volume"
    delete_on_termination = false
               }
                                                   }
#### End Create Instans block ####

												   