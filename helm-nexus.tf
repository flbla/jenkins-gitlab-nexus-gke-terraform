resource "helm_release" "nexus" {
  name  = "nexus"
  chart = "stable/sonatype-nexus"
  values = [<<EOF
ingress:
  path: "/nexus"
EOF
  ]
  depends_on = [
    "helm_release.kube-lego",
    "helm_release.nginx-ingress",
    "google_container_cluster.default",
  ]
}
