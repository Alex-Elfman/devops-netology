output "network_id" {
  value = yandex_vpc_network.develop.id
}

output "subnet_id" {
  value = yandex_vpc_subnet.develop[*].id
}

output "ya_zone" {
  value = yandex_vpc_subnet.develop[*].zone
}

output "cidr_subnet" {
  value = yandex_vpc_subnet.develop[*].v4_cidr_blocks
}