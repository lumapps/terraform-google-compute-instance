variable "region" {}

variable "zone" {
  default = ""
}

variable "amount" {
  description = "How many element of this ressource type you want to create."
  default = 1
}

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

variable "allow_stopping_for_update" {
  description = "If true, allows Terraform to stop the instance to update its properties. If you try to update a property that requires stopping the instance without setting this field, the update will fail."
  default = false
}

variable "service_account" {
  type = "string"
  description = "Service account to attribute to the GCE instance. Keep it empty (default value) to avoid attributing a service account to the instances. Use \"default\" to attribute the Google managed default compute engine service account. Use the email of any other existing user-managed service account."
  default = ""
}

variable "scopes" {
  type = "string"
  description = "Comma separated list of scope to attribute to GCE instances. Use \"https://www.googleapis.com/auth/cloud-platform\" to disable access scope and manage permissions completly with IAM"
  default = "https://www.googleapis.com/auth/devstorage.read_only, https://www.googleapis.com/auth/logging.write, https://www.googleapis.com/auth/monitoring.write"
}
