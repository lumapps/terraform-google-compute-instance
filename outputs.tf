output "addresses" {
  value = "${google_compute_address.static-addresses.*.address}"
}
