resource "google_compute_address" "cicd" {
  name   = "tf-gke-helm-${var.app_name}"
  region = "${var.region}"
}

resource "helm_release" "kube-lego" {
  name  = "kube-lego"
  chart = "stable/kube-lego"

  values = [<<EOF
rbac:
  create: false
config:
  LEGO_EMAIL: ${var.acme_email}
  LEGO_URL: ${var.acme_url}
  LEGO_SECRET_NAME: lego-acme
EOF
  ]
}

resource "helm_release" "nginx-ingress" {
  name  = "nginx-ingress"
  chart = "stable/nginx-ingress"

  values = [<<EOF
rbac:
  create: false
controller:
  service:
    loadBalancerIP: ${google_compute_address.cicd.address}
EOF
  ]

  depends_on = [
    "helm_release.kube-lego",
  ]
}
