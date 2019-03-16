terraform {
  backend "gcs" {
    bucket = "matus-chladek-bucket"
  }
}

provider "google" {
  project     = "${var.gc_project}"
  region      = "${var.gc_region}"
}

provider "kubernetes" {
  host                   = "${google_container_cluster.cloudweekend.endpoint}"
  username               = "${google_container_cluster.cloudweekend.master_auth.0.username}"
  password               = "${google_container_cluster.cloudweekend.master_auth.0.password}"
  client_certificate     = "${base64decode(google_container_cluster.cloudweekend.master_auth.0.client_certificate)}"
  client_key             = "${base64decode(google_container_cluster.cloudweekend.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.cloudweekend.master_auth.0.cluster_ca_certificate)}"

}
