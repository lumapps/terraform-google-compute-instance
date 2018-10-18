data "google_compute_zones" "available" {
  region = "${var.region}"
  status = "UP"
}

data "google_compute_default_service_account" "default_service_account" {}

resource "google_compute_address" "static-addresses" {
  count  = "${var.amount}"
  name   = "${var.name_prefix}-${count.index}"
  region = "${var.region}"
}

resource "google_compute_disk" "boot-disks" {
  count = "${var.amount}"

  name = "${var.name_prefix}-${count.index+1}"
  type = "${var.boot_disk_type}"
  size = "${var.boot_disk_size_gb}"
  zone = "${coalesce(var.zone, data.google_compute_zones.available.names[count.index % length(data.google_compute_zones.available.names)])}"

  image = "${var.boot_disk_image}"

  provisioner "local-exec" {
    command    = "${var.disk_create_local_exec_command_or_fail}"
    on_failure = "fail"
  }

  provisioner "local-exec" {
    command    = "${var.disk_create_local_exec_command_and_continue}"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    when       = "destroy"
    command    = "${var.disk_destroy_local_exec_command_or_fail}"
    on_failure = "fail"
  }

  provisioner "local-exec" {
    when       = "destroy"
    command    = "${var.disk_destroy_local_exec_command_and_continue}"
    on_failure = "continue"
  }
}

resource "google_compute_disk" "data-disks" {
  count = "${var.amount}"

  name = "${var.name_prefix}-data-${count.index+1}"
  type = "${var.data_disk_type}"
  size = "${var.data_disk_size_gb}"
  zone = "${coalesce(var.zone, data.google_compute_zones.available.names[count.index % length(data.google_compute_zones.available.names)])}"

  provisioner "local-exec" {
    command    = "${var.disk_create_local_exec_command_or_fail}"
    on_failure = "fail"
  }

  provisioner "local-exec" {
    command    = "${var.disk_create_local_exec_command_and_continue}"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    when       = "destroy"
    command    = "${var.disk_destroy_local_exec_command_or_fail}"
    on_failure = "fail"
  }

  provisioner "local-exec" {
    when       = "destroy"
    command    = "${var.disk_destroy_local_exec_command_and_continue}"
    on_failure = "continue"
  }
}

resource "google_compute_instance" "instances" {
  count = "${var.amount}"
  allow_stopping_for_update = "${var.allow_stopping_for_update}"

  name = "${var.name_prefix}-${count.index+1}"
  zone = "${coalesce(var.zone, data.google_compute_zones.available.names[count.index % length(data.google_compute_zones.available.names)])}"

  machine_type = "${var.machine_type}"
  tags         = ["${var.tag == "" ? var.name_prefix : var.tag}"]

  boot_disk = {
    source      = "${google_compute_disk.boot-disks.*.name[count.index]}"
    auto_delete = false
  }

  attached_disk = {
    source = "${google_compute_disk.data-disks.*.name[count.index]}"
  }

  service_account = {
    email = "${var.service_account == "" ? "" : (var.service_account == "default" ? data.google_compute_default_service_account.default_service_account.email : var.service_account)}"
    scopes = "${split(", ", var.scopes)}"
  }

  network_interface = {
    network = "${var.network}"

    access_config = {
      nat_ip = "${google_compute_address.static-addresses.*.address[count.index]}"
    }
  }
  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = "true"
  }
}
