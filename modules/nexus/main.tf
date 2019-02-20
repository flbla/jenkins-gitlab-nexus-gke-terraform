resource "helm_release" "nexus" {
  name  = "nexus"
  chart = "stable/sonatype-nexus"
  values = [<<EOF
ingress:
  enabled: true
  path: "/nexus"
  tls:
    enabled: false
nexusProxy:
  env: 
    nexusHttpHost: "nexus.local"
EOF
  ]
}
