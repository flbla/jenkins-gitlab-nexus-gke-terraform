resource "helm_release" "gitlab" {
  name  = "gitlab"
  chart = "stable/gitlab-ce"
  values = [<<EOF
ingress:
  enabled: true 
  annotations:
    kubernetes.io/tls-acme: "true"
  tls:
    - secretName: "gitlab.${var.public_ip_address}.nip.io"
      hosts:
        - "gitlab.${var.public_ip_address}.nip.io"
externalUrl: "gitlab.${var.public_ip_address}.nip.io"
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
