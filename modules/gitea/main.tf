resource "helm_release" "gitea" {
  name  = "gitea"
  chart = "jfelten/gitea"
  values = [<<EOF
ingress:
  enabled: true 
resources:
  gitea:
    requests:
      memory: 128Mi
      cpu: 200m
    limits:
      memory: 1Gi
      cpu: 800m
persistence:
  enabled: true
EOF
  ]
}
