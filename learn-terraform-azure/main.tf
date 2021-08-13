terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 2.65"
        }
    }

    backend "remote" {
        organization = "ellafj_tutorial"
        workspaces {
            name = "Example-Workspace"
        }
    }
}

provider "azurerm" {
    features {}
}