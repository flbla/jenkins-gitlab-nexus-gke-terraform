resource "helm_release" "nexus" {
  name  = "nexus"
  chart = "stable/sonatype-nexus"
  values = [<<EOF
ingress:
  annotations: 
    kubernetes.io/tls-acme: true
    nginx.ingress.kubernetes.io/proxy-body-size: 500m
  enabled: true
  tls:
    enabled: true
    secretName: nexus-tls
nexusProxy:
  env: 
    nexusHttpHost: "nexus.${var.public_ip_address}.nip.io"
    nexusDockerHost: "nexus-docker.${var.public_ip_address}.nip.io"
EOF
  ]
}
