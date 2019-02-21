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
