# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group}_${var.environment}"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "terraform-k8s" {
  name                = "${var.cluster_name}_${var.environment}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  default_node_pool {
    name            = "agentpool"
    node_count      = var.node_count
    vm_size         = "standard_d2as_v5"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = var.environment
  }
}

# provider "azurerm" {
#   features {}
# }

# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = ">=2.95.0"
#     }
#     azuread = {
#       source  = "hashicorp/azuread"
#     }
#   }
#   backend "azurerm" {
#     # storage_account_name="<<storage_account_name>>" #OVERRIDE in TERRAFORM init
#     # access_key="<<storage_account_key>>" #OVERRIDE in TERRAFORM init
#     # key="<<env_name.k8s.tfstate>>" #OVERRIDE in TERRAFORM init
#     # container_name="<<storage_account_container_name>>" #OVERRIDE in TERRAFORM init
#   }
# }

#   terraform {
#    required_version = ">= 0.11" 
#      backend "azurerm" {
#      storage_account_name="<<storage_account_name>>" #OVERRIDE in TERRAFORM init
#      access_key="<<storage_account_key>>" #OVERRIDE in TERRAFORM init
#      key="<<env_name.k8s.tfstate>>" #OVERRIDE in TERRAFORM init
#      container_name="<<storage_account_container_name>>" #OVERRIDE in TERRAFORM init
#      features{}
#     }
#  	}
#    provider "azurerm" {
#      version = "=2.0.0"
#   features {}
#  }

# terraform {
#   required_version = ">= 0.12"
#   backend "azurerm" {
#      storage_account_name="<<storage_account_name>>" #OVERRIDE in TERRAFORM init
#      access_key="<<storage_account_key>>" #OVERRIDE in TERRAFORM init
#      key="<<env_name.k8s.tfstate>>" #OVERRIDE in TERRAFORM init
#      container_name="<<storage_account_container_name>>" #OVERRIDE in TERRAFORM init
#     features{}
#   }
# }
