resource "helm_release" "gitlab" {
  name  = "gitlab"
  chart = "stable/gitlab-ce"
  values = [<<EOF
ingress:
  enabled: true 
externalUrl: "${var.external_url}"
serviceType: ClusterIP
resources:
  requests:
    memory: 512Mi
    cpu: 500m
  limits:
    memory: 2Gi
    cpu: 1
postgresql:
  cpu: 500m
  memory: 512Mi
redis:
  resources:
    requests:
      memory: 512Mi
EOF
  ]
}
