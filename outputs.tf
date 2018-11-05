output "names" {
  value = "${google_compute_instance.instances.*.name}"
}

output "addresses" {
  value = "${google_compute_address.static-addresses.*.address}"
}

output "data-disks" {
  value = "${google_compute_disk.data-disks.*.name}"
}
