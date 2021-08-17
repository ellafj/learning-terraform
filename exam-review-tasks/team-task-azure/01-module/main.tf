provider "azurerm" {
    subscription_id = "a0f22f4c-20d3-4429-9827-c7cee3d2e0ee"
    features {} # terraform needs this to configure the provider 
}

resource "azurerm_resource_group" "rg" {
    name = "${var.prefix}-network-1"
    location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
    name = "${var.prefix}-vnet-1"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "subnet1" {
    name = "subnet-1-1"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [ "10.0.2.0/24"]
}

resource "azurerm_network_interface" "interface" {
    name = "${var.prefix}-nic"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name = "testconfiguration1-1"
        subnet_id = azurerm_subnet.subnet1.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "vm1" {
    name = "${var.prefix}-vm"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.interface.id]
    vm_size = "Standard_DS1_v2"

    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04-LTS"
        version = "latest"
    }
    storage_os_disk {
        name = "myosdisk1"
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name = "hostname"
        admin_username = "testadmin"
        admin_password = "Password1234!"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
    tags = {
        environment = "staging"
    }
}