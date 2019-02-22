resource "kubernetes_secret" "maven-setting" {
  metadata {
    name = "maven-setting"
  }

  data {
    setting.xml = <<EOF
<server>
   <id>${var.nexus_repo_id}</id>
   <username>${var.nexus_user}</username>
   <password>${var.nexus_password}</password>
 </server>
EOF
  }
}

resource "kubernetes_config_map" "env-vars" {
  metadata {
    name = "jenkins-env-vars"
  }

  data {
    vars = <<EOF
NEXUS_URL=https://nexus.${var.public_ip_address}.nip.io
EOF
  }
}

resource "helm_release" "jenkins" {
  name  = "jenkins"
  chart = "stable/jenkins"

  values = [<<EOF
Agent:
  Enabled: false
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
