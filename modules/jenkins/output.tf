output "public_ip_address" {
  value = "${google_compute_address.cicd.address}"
}
