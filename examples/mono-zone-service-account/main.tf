variable "project_name" {
  type = "string"
}

variable "region" {
  type    = "string"
  default = "us-central1"
}

variable "region_zone" {
  type    = "string"
  default = "us-central1-a"
}

provider "google" {
  project = "${var.project_name}"
  region  = "${var.region}"
  zone    = "${var.region_zone}"
}

data "google_compute_image" "coreos_stable" {
  family  = "coreos-stable"
  project = "coreos-cloud"
}

module "gce_test" {
  source            = "../../"
  region            = "us-central1"
  zone              = "us-central1-a"
  name_prefix       = "test"
  machine_type      = "f1-micro"
  boot_disk_size_gb = "10"
  boot_disk_image   = "${data.google_compute_image.coreos_stable.self_link}"
  data_disk_size_gb = "10"
  allow_stopping_for_update = true
  service_account = "gce_test@my_project_id.iam.gserviceaccount.com"
  // disable CGE scopes and rely exclusively on IAM for permissions management
  scopes = "https://www.googleapis.com/auth/cloud-platform"
}
