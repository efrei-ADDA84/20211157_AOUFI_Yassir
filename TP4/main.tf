resource "azurerm_public_ip" "tp4" {
  name                = "devops-20211157"
  location            = "france central"
  resource_group_name = "ADDA84-CTP"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "tp4" {
  name                      = "devops-20211157"
  location                  = "france central"
  resource_group_name       = "ADDA84-CTP"

  ip_configuration {
    name                          = "devops-20211157"
    subnet_id                     = data.azurerm_subnet.tp4.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tp4.id
  }
}

data "azurerm_subnet" "tp4" {
  name                 = "internal"
  virtual_network_name = "network-tp4"
  resource_group_name  = "ADDA84-CTP"
}

output "subnet_id" {
  value = data.azurerm_subnet.tp4.id
}
resource "azurerm_virtual_machine" "tp4" {
  name                  = "devops-20211157"
  location              = "france central"
  resource_group_name   = "ADDA84-CTP"
  vm_size               = "Standard_D2s_v3"

  network_interface_ids = [azurerm_network_interface.tp4.id]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }


  storage_os_disk {
    name              = "devops-20211157"
    caching           = "ReadWrite"
    create_option    = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "devops-20211157"
    admin_username = "devops"
    custom_data    = filebase64("cloud-init.txt")
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/devops/.ssh/authorized_keys"
      key_data = tls_private_key.generated_ssh_key.public_key_openssh
    }
  }
  provisioner "remote-exec" {
    inline = [
      "echo 'Hello, World!'",
      "sudo apt-get update",
      "sudo apt-get install "
      ]
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.tp4.ip_address
      user        = "devops"
      private_key = tls_private_key.generated_ssh_key.private_key_pem
    }
  }
}

output "public_ip" {
  value = azurerm_public_ip.tp4.ip_address
}

resource "tls_private_key" "generated_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "tls_private_key" {
  value = tls_private_key.generated_ssh_key.private_key_pem
  sensitive = true
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.61.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = "true"
  subscription_id = "765266c6-9a23-4638-af32-dd1e32613047"
}