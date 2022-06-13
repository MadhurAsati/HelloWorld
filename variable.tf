
variable "resource_group_name" {
  type = string
  default = "testrg1"
}
variable "location" {
  type = string
  default = "west europe"
}
variable "subnet_name" {
  type = string
  default = ""
}
variable "nic_name" {
  type = string
  default = ""
}
variable "vm_name" {
  type = string
  default = ""
}
variable "count_vm" {
  type = number 
  default = 4
}
