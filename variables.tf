variable "region" {}

variable "zone" {
  default = ""
}

variable "amount" {}
variable "name_prefix" {}
variable "machine_type" {}

variable "tag" {
  type    = "string"
  default = ""
}

variable "network" {
  default = "default"
}

variable "boot_disk_type" {
  default = "pd-standard"
}

variable "boot_disk_size_gb" {}
variable "boot_disk_image" {}

variable "data_disk_type" {
  default = "pd-ssd"
}

variable "data_disk_size_gb" {}

variable "disk_create_local_exec_command_or_fail" {
  default = ":"
}

variable "disk_create_local_exec_command_and_continue" {
  default = ":"
}

variable "disk_destroy_local_exec_command_or_fail" {
  default = ":"
}

variable "disk_destroy_local_exec_command_and_continue" {
  default = ":"
}
