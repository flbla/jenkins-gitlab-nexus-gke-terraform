# jenkins-gitlab-nexus-gke-terraform

Easily deploy Jenkins, Gitlab and Nexus on GoogleCloudEngine (GKE) with Terraform

## Pre-requisites

- Google account 
- Compute Engine API and Kubernetes Engine API enabled

## How to deploy?

- Launch Google shell
- Download terraform (example): 
```shell
export TERRAFORM_VERSION="0.11.11"
mkdir -p ~/gopath/bin 
cd ~/gopath/bin
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
```
- Clone me : 
```shell
cd ~
git clone https://github.com/flbla/jenkins-gitlab-nexus-gke-terraform.git
cd  jenkins-gitlab-nexus-gke-terraform
```
- Deploy 'prod'
```shell
cd prod
# Terraform init will initialize terraform => download/load all needed modules and providers
terraform init

# Terraform plan will show you what will be deploy if you do an apply
terraform plan --var-file=prod.tfvars

# Terraform apply will work for you and deploy all the infrasctructure
terraform apply --var-file=prod.tfvars
```

## How to connect to Jenkins/Nexus/Gitlab?

```shell
kubectl get ing
```

## How to create Jenkins pipeline/job?

You can take a look at : https://gitlab.com/flbla/springboot-sample/tree/master
=> Jenkinsfile

https://github.com/jenkinsci/kubernetes-plugin : 

```groovy
def label = "mypod-${UUID.randomUUID().toString()}"
podTemplate(label: label, containers: [
    containerTemplate(name: 'maven', image: 'maven:3.3.9-jdk-8-alpine', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'golang', image: 'golang:1.8.0', ttyEnabled: true, command: 'cat')
  ]) {

    node(label) {
        stage('Get a Maven project') {
            git 'https://github.com/jenkinsci/kubernetes-plugin.git'
            container('maven') {
                stage('Build a Maven project') {
                    sh 'mvn -B clean install'
                }
            }
        }

        stage('Get a Golang project') {
            git url: 'https://github.com/hashicorp/terraform.git'
            container('golang') {
                stage('Build a Go project') {
                    sh """
                    mkdir -p /go/src/github.com/hashicorp
                    ln -s `pwd` /go/src/github.com/hashicorp/terraform
                    cd /go/src/github.com/hashicorp/terraform && make core-dev
                    """
                }
            }
        }

    }


}
```
