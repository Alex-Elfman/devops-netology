terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}


resource "yandex_vpc_network" "develop" {
  name = var.env_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = "${var.env_name}-${count.index}"
  network_id     = yandex_vpc_network.develop.id
  count = length(var.vm_zone)
  zone = var.vm_zone[count.index].zone
  v4_cidr_blocks = [var.vm_zone[count.index].cidr]
}

