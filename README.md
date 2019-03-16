# Kiwi weekend in the Cloud

This repository is based on topics covered in [Weekend in the Cloud](https://cloudweekend.cz/) event organized by Kiwi Platform team.

* Terraform:
    * Configuration
    * Planning, Applying
* Kubernetes
    * Namespaces, Services, Pods
    * Load Balancers, Ingress, NodePort
    * Deploying
* Stackdrier
    * Monitoring
    * Alerting

## Terraform basics


#### Initial setup

* Have a GCP Project.
* Set up `Google cloud SDK` - https://cloud.google.com/sdk/install

* Log in

```
gcloud auth login
gcloud auth application-default login
```
* Create bucket for remote state - https://cloud.google.com/storage/docs/creating-buckets#storage-create-bucket-gsutil

```
gsutil mb -p [PROJECT_NAME] -c [STORAGE_CLASS] -l [BUCKET_LOCATION] gs://[BUCKET_NAME]/
```

#### Further steps

##### `providers.tf`

Configure `providers.tf` and configure created bucket as your remote state

```
terraform {
  backend "gcs" {
    bucket = "YOUR_BUCKET_NAME"
  }
}
```

Add Google as a provider

```
provider "google" {
  project     = "${var.gc_project}"
  region      = "${var.gc_region}"
}
```

Prepare kubernetes provider

```
provider "kubernetes" {
  host                   = "${google_container_cluster.cloudweekend.endpoint}"
  username               = "${google_container_cluster.cloudweekend.master_auth.0.username}"
  password               = "${google_container_cluster.cloudweekend.master_auth.0.password}"
  client_certificate     = "${base64decode(google_container_cluster.cloudweekend.master_auth.0.client_certificate)}"
  client_key             = "${base64decode(google_container_cluster.cloudweekend.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.cloudweekend.master_auth.0.cluster_ca_certificate)}"

}
```

##### `cluster.tf`

Prepare container cluster
```
resource "google_container_cluster" "cloudweekend" {
  zone                     = "${var.gc_zone}"
  name                     = "${var.env_prefix}cloudweekend"
  remove_default_node_pool = true
  initial_node_count       = 1
}
```

and node pool

```
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
```

##### `var.tf`

List variables used in our configuration

```
variable "gc_project" {
  type = "string"
}

variable "gc_region" {
  type = "string"
}

variable "gc_zone" {}

variable "initial_node_count" {}

variable "max_node_count" {}

variable "k8s_machine_type" {}

variable "env_prefix" {
  default = ""
}
```

##### `vars.tfvars`

Define variables values

```
gc_project = "YOUR_PROJECT"
gc_region = "europe-west1"
gc_zone = "europe-west1-b"
k8s_machine_type = "n1-standard-1"
```

##### Terraform

`terraform init`
`terraform plan -var-file=vars.tfvars`
`terraform apply -var-file=vars.tfvars`

##### Pull remote state

`terraform state pull > tmp.json`
