# Getting Started with AKS

## Azure CLI

```
#Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

## Login to azure

```
#Login following the instructions
az login
```

## Generate SSH key

```
ssh-keygen -t rsa -b 4096 -N "YourSecret" -C "your_email@example.com" -q -f  ~/.ssh/id_rsa

#Set env var with publick key to be used by terraform
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
```

## Deploy with terraform

```
terraform init
terraform plan -var ssh_key="$SSH_KEY"
terraform apply -var ssh_key="$SSH_KEY"
```

## Check the deployment

```
# Get kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

# grab AKS config
az aks get-credentials -n aks-getting-started -g aks-getting-started
```
You can now interact with the cluster directly from the command line using kubectl command, like:
```
kubectl get pods --all-namespaces
```

## Clean up

```
terraform destroy -var ssh_key="$SSH_KEY"
```
