provider "helm" {
  tiller_image = "gcr.io/kubernetes-helm/tiller:${var.helm_version}"

  kubernetes {
    host                   = "${google_container_cluster.default.endpoint}"
    token                  = "${data.google_client_config.current.access_token}"
    client_certificate     = "${base64decode(google_container_cluster.default.master_auth.0.client_certificate)}"
    client_key             = "${base64decode(google_container_cluster.default.master_auth.0.client_key)}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)}"
  }
}

module "jenkins" {
  source = "../modules/jenkins"
  app_name = "${var.app_name}"
  acme_email = "${var.acme_email}"
  acme_url = "${var.acme_url}"
  region = "${var.region}"
}

module "gitlab" {
  source = "../modules/gitlab"
  external_url = "${module.jenkins.public_ip_address}"
}

module "nexus" {
  source = "../modules/nexus"
}
