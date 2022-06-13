terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.1.0"
        
  }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "az-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "az-vn" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.az-rg.location
  resource_group_name = azurerm_resource_group.az-rg.name
}

resource "azurerm_subnet" "az-subnet" {
  name                 = "internal"
  resource_group_name = azurerm_resource_group.az-rg.name
  virtual_network_name = azurerm_virtual_network.az-vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "az-nic" {
  #count               = var.count_vm
  name                = "examhappym"
  location            = azurerm_resource_group.az-rg.location
  resource_group_name = azurerm_resource_group.az-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.az-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "az-vm" {
  count               = "${var.count_vm}"
  name                = "examhappym-${count.index}"
  resource_group_name = azurerm_resource_group.az-rg.name
  location            = azurerm_resource_group.az-rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.az-nic.*.id,count.index,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
