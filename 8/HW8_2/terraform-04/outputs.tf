output "vm_ip" {
  value = module.test-vm.external_ip_address
}

output "vpc_id" {
  value = module.vm_netwok.network_id
}

output "sub_id" {
  value = module.vm_netwok.subnet_id
}

output "cidr_sub" {
  value = module.vm_netwok.cidr_subnet
}
