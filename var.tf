variable "gc_project" {
  type = "string"
}

variable "gc_region" {
  type = "string"
}

variable "gc_zone" {}

variable "initial_node_count" {
  default = 1
}

variable "max_node_count" {
  default = 1
}

variable "k8s_machine_type" {}

variable "env_prefix" {
  default = ""
}
