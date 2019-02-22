# jenkins-gitlab-nexus-gke-terraform

Easily deploy Jenkins, Gitlab and Nexus on GoogleCloudEngine (GKE) with Terraform

## Pre-requisites

- Google account 
- Compute Engine API and Kubernetes Engine API enabled
  - You need to connect to http://console.cloud.google.com/ then click on Compute Engine, then Kubernetes Engine, wait some minutes

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
- Init Google API services
```shell
gcloud services enable servicemanagement.googleapis.com
```

- Install Helm
```shell
cd ~
export HELM_VERSION="2.12.3"
wget https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz
tar xf helm-v${HELM_VERSION}-linux-amd64.tar.gz
cd linux-amd64
mv helm ~/gopath/bin
cd ~
rm -rf linux-amd64 helm-v${HELM_VERSION}-linux-amd64.tar.gz
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

https://github.com/jenkinsci/kubernetes-plugin
