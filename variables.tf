variable "helm_version" {
  default = "v2.9.1"
}

variable "app_name" {
  default = "jenkins"
}

variable "acme_url" {
  default = "https://acme-v01.api.letsencrypt.org/directory"
}

variable "acme_email" {
  default = "fblampey@adneom.com"
}
