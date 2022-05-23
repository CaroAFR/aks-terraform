# Getting Started with AKS

The first thing that you need to do is install AZ CLI and login to your azure account. You can do it with the following commands.

## Azure CLI Ubuntu

```
#Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

## Azure CLI Windows

Open Powershell as Administrator and run the following command
```
#Install Azure CLI
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
```


## Login to azure

```
#Login following the instructions
az login
```

The next step is to generate a SSH key to set to the linux profile

## Generate SSH key UBUNTU

```
ssh-keygen -t rsa -b 4096 -N "YourSecret" -C "your_email@example.com" -q -f  ~/.ssh/id_rsa

#Set env var with public key to be used by terraform
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
```
## Generate SSH key PowerShell
Run this command in the user folder or use the path to the folder. Make sure the folder .ssh is already created.
```
ssh-keygen -t rsa -b 4096 -N "YourSecret" -C "your_email@example.com" -q -f  .ssh/id_rsa

#Set env var with public key to be used by terraform
Set-Variable -Name SSH_KEY -Value (cat .ssh/id_rsa.pub)
```

## Get Terraform UBUNTU
```
#Ensure that your system is up to date, and you have the gnupg, software-properties-common, and curl packages installed.
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

#Add the HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

#Add the official HashiCorp Linux repository.
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

#Update to add the repository, and install the Terraform CLI
sudo apt-get update && sudo apt-get install terraform
```

## Get Terraform WINDOWS
```
#Get Chocolatey to install Terraform. Run Powershell as administrator
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

#Install terraform with chocolatey
choco install terraform
```

## Deploy with terraform
Enter the folder of the cloned repo and deploy the app
```
cd aks-terraform
terraform init
terraform plan -var ssh_key="$SSH_KEY"
terraform apply -var ssh_key="$SSH_KEY"
```

## Check the deployment
### Get kubectl Ubuntu
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
```
### Get kubectl Windows
Run Powershell as Administrator
```
#Using chocolatey 
choco install kubernetes-cli
```

## Grab AKS config
```
az aks get-credentials --resource-group demo-kubernetes --name AKS-Demo
```
You can now interact with the cluster directly from the command line using kubectl command
```
#Deploy the app
kubectl apply -f app.yml

#Get pods
kubectl get pods --all-namespaces

#Get the external IP for the application
kubectl get services

```

## Clean up

```
terraform destroy -var ssh_key="$SSH_KEY"
```
