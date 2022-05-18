terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo-kubernetes" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_kubernetes_cluster" "AKS-demo" {
  name                = "AKS-Demo"
  location            = azurerm_resource_group.demo-kubernetes.location
  resource_group_name = azurerm_resource_group.demo-kubernetes.name
  dns_prefix          = "demok8s"

  default_node_pool {
    name                = "defaultnodes"
    node_count          = 1
    vm_size             = "Standard_B2s"
    os_disk_size_gb     = 30
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3

  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = var.ssh_key
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }


  identity {
    type = "SystemAssigned"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.AKS-demo.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.AKS-demo.kube_config_raw
  sensitive = true
}

