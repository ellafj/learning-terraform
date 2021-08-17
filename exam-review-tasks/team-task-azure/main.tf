provider "azurerm" {
    subscription_id = "a0f22f4c-20d3-4429-9827-c7cee3d2e0ee"
    features {} # terraform needs this to configure the provider 
}

module "module_1" {
    source = "./01-module"
}

module "module_2" {
    source = "./02-module"
}