resource "google_compute_global_address" "cloudweekend" {
  name = "cloudweekend"
}

output "static-ip" {
  value = "${google_compute_global_address.cloudweekend.address}"
}