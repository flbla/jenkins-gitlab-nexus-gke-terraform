resource "kubernetes_secret" "maven-setting" {
  metadata {
    name = "maven-setting"
  }

  data {
    setting.xml = <<EOF
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                      https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <servers>
    <server>
       <id>maven-releases</id>
       <username>${var.nexus_user}</username>
       <password>${var.nexus_password}</password>
     </server>
    <server>
       <id>maven-snapshots</id>
       <username>${var.nexus_user}</username>
       <password>${var.nexus_password}</password>
     </server>
  </servers>
</settings>
EOF
  }
}

resource "kubernetes_secret" "docker-config" {
  metadata {
    name = "docker-config"
  }

  data {
    config.json = <<EOF
{
  "auths": {
          "nexus-docker.${var.public_ip_address}.nip.io": {
                  "auth": "${base64encode(format("%s:%s", var.nexus_user, var.nexus_password))}"
          }
  }
}
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
NEXUS_DOCKER_URL=nexus-docker.${var.public_ip_address}.nip.io
PUBLIC_IP=${var.public_ip_address}
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
