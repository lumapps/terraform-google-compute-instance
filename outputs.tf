output "addresses" {
  value = "${join(",", google_compute_address.static-addresses.*.address)}"
}
