variable "region" {
  default = "europe-west3"
}

variable "zone" {
  default = "europe-west3-a"
}

variable "network_name" {
  default = "tf-gke-helm-jenkins"
}

provider "google" {
  region = "${var.region}"
}

data "google_client_config" "current" {}

resource "google_compute_network" "default" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name                     = "${var.network_name}"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = true
}

data "google_container_engine_versions" "default" {
  zone = "${var.zone}"
}

resource "google_container_cluster" "default" {
  name               = "tf-gke-helm-cicd"
  zone               = "${var.zone}"
  initial_node_count = 3
  #min_master_version = "${data.google_container_engine_versions.default.latest_master_version}"
  min_master_version = "1.11.7-gke.4"
  network            = "${google_compute_subnetwork.default.name}"
  subnetwork         = "${google_compute_subnetwork.default.name}"

  enable_legacy_abac = true

  provisioner "local-exec" {
    when    = "destroy"
    command = "sleep 90"
  }
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]
    disk_size_gb = 30
    #machine_type = "g1-small"
    machine_type = "n1-standard-1"
    preemptible = true 
  }
}

output "network" {
  value = "${google_compute_subnetwork.default.network}"
}

output "subnetwork_name" {
  value = "${google_compute_subnetwork.default.name}"
}

output "cluster_name" {
  value = "${google_container_cluster.default.name}"
}

output "cluster_region" {
  value = "${var.region}"
}

output "cluster_zone" {
  value = "${google_container_cluster.default.zone}"
}
