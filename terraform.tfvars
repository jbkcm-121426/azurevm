# terraform.tfvars.example
# Copy this file to terraform.tfvars and update the values

resource_group_name = "rg-vm-deployment"
location           = "East US"
vm_name           = "vm-windows2022"
vm_size           = "Standard_B2s"
admin_username    = "azureuser"
# admin_password will be provided via GitHub Secrets

# Network Configuration
vnet_name               = "vnet-main"
subnet_name            = "subnet-internal"
vnet_address_space     = ["10.0.0.0/16"]
subnet_address_prefixes = ["10.0.1.0/24"]