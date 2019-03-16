resource "google_container_cluster" "cloudweekend" {
  zone                     = "${var.gc_zone}"
  name                     = "${var.env_prefix}cloudweekend"
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "cloudweekend_np" {
  cluster            = "${google_container_cluster.cloudweekend.name}"
  name               = "cloudweekend-np"
  zone               = "${var.gc_zone}"
  initial_node_count = "${var.initial_node_count}"

  autoscaling {
    min_node_count = "${var.initial_node_count}"
    max_node_count = "${var.max_node_count}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    machine_type = "${var.k8s_machine_type}"
  }
}
