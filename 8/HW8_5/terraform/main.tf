
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    ssh_public_key = file("~/.ssh/yc.pub")
  }
}
module "vm_netwok" {
  source       = "./vpc"
  env_name     = "prod"
  vm_zone      = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" }
    ]
}


module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=b266a31489d2681541ea41c5bca6dcfb92ab886a"
  env_name        = "develop"
  network_id      = module.vm_netwok.network_id
  subnet_zones    = [ module.vm_netwok.ya_zone[0] ]
  subnet_ids      = [ module.vm_netwok.subnet_id[0] ]
  instance_name   = "study"
  instance_count  = 3
  image_family    = "centos-7"
  public_ip       = true

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}


#resource "local_file" "ip" {
#  content  = module.test-vm.external_ip_address[0]
#  filename = "ip"
#}