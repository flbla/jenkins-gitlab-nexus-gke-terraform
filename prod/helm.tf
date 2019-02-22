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

provider "kubernetes" {
  host                   = "${google_container_cluster.default.endpoint}"
  client_certificate     = "${base64decode(google_container_cluster.default.master_auth.0.client_certificate)}"
  client_key             = "${base64decode(google_container_cluster.default.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)}"
}

module "nginx-ingress-lego" {
  source = "../modules/nginx-ingress-lego"
  app_name = "${var.app_name}"
  acme_email = "${var.acme_email}"
  acme_url = "${var.acme_url}"
  region = "${var.region}"
}

module "jenkins" {
  source = "../modules/jenkins"
  public_ip_address = "${module.nginx-ingress-lego.public_ip_address}"
  admin_password = "${var.jenkins_admin_password}"
  nexus_password = "admin123"
  nexus_user = "admin"
  nexus_repo_id = "repo"
}

module "nexus" {
  source = "../modules/nexus"
  public_ip_address = "${module.nginx-ingress-lego.public_ip_address}"
}
