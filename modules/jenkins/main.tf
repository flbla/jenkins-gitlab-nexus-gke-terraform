resource "helm_release" "jenkins" {
  name  = "jenkins"
  chart = "stable/jenkins"

  values = [<<EOF
Agent:
  Enabled: true
  envVars:
    - name: NEXUS_URL
      value: https://nexus.${var.public_ip_address}.nip.io
Master:
  AdminPassword: "${var.admin_password}"
  ServiceType: "ClusterIP"
  HostName: "jenkins.${var.public_ip_address}.nip.io"
  Ingress: 
    Annotations: 
      kubernetes.io/tls-acme: "true"
    TLS:
      - secretName: "jenkins.${var.public_ip_address}.nip.io"
        hosts:
          - "jenkins.${var.public_ip_address}.nip.io"
  resources:
    requests:
      cpu: "50m"
      memory: "128Mi"
    limits:
      cpu: "500m"
      memory: "1024Mi"
EOF
  ]
}
