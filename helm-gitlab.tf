resource "helm_release" "gitlab" {
  name  = "gitlab"
  chart = "stable/gitlab-ce"
  values = [<<EOF
ingress:
  enabled: true 
externalUrl: "http://34.95.68.59/"
EOF
  ]
  depends_on = [
    "helm_release.kube-lego",
    "helm_release.nginx-ingress",
    "google_container_cluster.default",
  ]
}
