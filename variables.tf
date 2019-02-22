variable "helm_version" {
  default = "v2.9.1"
}

variable "app_name" {}

variable "acme_url" {
  default = "https://acme-v01.api.letsencrypt.org/directory"
}

variable "acme_email" {}

variable "region" {
  default = "europe-west3"
}
variable "zone" {
  default = "europe-west3-a"
}
variable "network_name" {
  default = "tf-gke"
}

variable "jenkins_admin_password" { 
  defautl = "admin123"
}

variable "nexus_admin_password" { 
  defautl = "admin123"
}
