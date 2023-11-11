variable "env_name" {
  type    = string
  default = null
}
variable "vm_zone" {
  type        = list(object({
    zone = string,
    cidr = string
  })
  )
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
#variable "vm_cidr" {
#  type        = list(string)
##  default     = ["10.0.1.0/24"]
#  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
#}