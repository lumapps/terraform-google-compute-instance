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

locals {
  tag = "gce-test"
}

provider "google" {
  project = "${var.project_name}"
  region  = "${var.region}"
  zone    = "${var.region_zone}"
}

module "gce_test_network" {
  source                  = "tasdikrahman/network/google"
  name                    = "gce-test-network"
  auto_create_subnetworks = true
}

module "firewall-ssh" {
  source        = "github.com/lumapps/terraform-google-network-firewall"
  name          = "rule-ssh"
  network       = "${module.gce_test_network.name}"
  protocol      = "tcp"
  ports         = ["22"]
  source_ranges = ["0.0.0.0/0"]
  target_tag    = "${local.tag}"
}

data "google_compute_image" "coreos_stable" {
  family  = "coreos-stable"
  project = "coreos-cloud"
}

module "gce_test" {
  source            = "../../"
  amount            = 2
  region            = "us-central1"
  zone              = "us-central1-a"
  name_prefix       = "test"
  machine_type      = "f1-micro"
  network           = "${module.gce_test_network.self_link}"
  tag               = "${local.tag}"
  boot_disk_size_gb = "10"
  boot_disk_image   = "${data.google_compute_image.coreos_stable.self_link}"
  data_disk_size_gb = "20"
}
