# Azure VM Deployment Setup Guide

This guide will help you set up the Terraform configuration and GitHub Actions workflow to deploy a Windows Server 2022 VM in Azure.

## Prerequisites

1. Azure subscription with appropriate permissions
2. GitHub repository
3. Azure Service Principal for GitHub Actions

## Setup Instructions

### 1. Create Azure Service Principal

Run these commands in Azure CLI to create a service principal:

```bash
# Login to Azure
az login

# Create service principal
az ad sp create-for-rbac --name "github-actions-sp" --role contributor --scopes /subscriptions/{subscription-id} --sdk-auth
```

Save the JSON output - you'll need it for GitHub Secrets.

### 2. Configure GitHub Secrets

In your GitHub repository, go to Settings > Secrets and variables > Actions, and add these secrets:

- `AZURE_CREDENTIALS`: The complete JSON output from the service principal creation
- `VM_ADMIN_PASSWORD`: A strong password for the VM administrator account (must meet Azure complexity requirements)

### 3. File Structure

Create the following files in your repository:

```
├── .github/
│   └── workflows/
│       └── deploy-azure-vm.yml
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars.example
```

### 4. Azure Password Requirements

The VM admin password must meet these requirements:
- 12-123 characters long
- Must contain 3 of the following: lowercase, uppercase, numbers, special characters
- Cannot contain the username or parts of the username

Example strong password: `MySecureP@ssw0rd123!`

### 5. Deploy the VM

1. Go to your GitHub repository
2. Click on "Actions" tab
3. Select "Deploy Azure VM with Terraform" workflow
4. Click "Run workflow"
5. Fill in the parameters:
   - Action: choose `plan` to preview changes, `apply` to deploy, `destroy` to remove resources
   - Resource Group Name: e.g., `rg-vm-deployment`
   - Location: e.g., `East US`
   - VM Name: e.g., `vm-windows2022`
   - VM Size: e.g., `Standard_B2s` (choose based on your needs)
   - Admin Username: e.g., `azureuser`

### 6. Access Your VM

After successful deployment:
1. Check the workflow output for the public IP address
2. Use Remote Desktop Connection (RDP) to connect:
   - Computer: `[Public IP Address]`
   - Username: `[Admin Username you specified]`
   - Password: `[Password from GitHub Secrets]`

## VM Sizes Reference

Common VM sizes you can use:

- `Standard_B1s`: 1 vCPU, 1 GB RAM (Basic)
- `Standard_B2s`: 2 vCPU, 4 GB RAM (Recommended for testing)
- `Standard_D2s_v3`: 2 vCPU, 8 GB RAM (Production ready)
- `Standard_D4s_v3`: 4 vCPU, 16 GB RAM (Higher performance)

## Azure Regions

Common Azure regions:
- `East US`
- `West US 2`
- `Central US`
- `North Europe`
- `West Europe`
- `Southeast Asia`

## Security Considerations

1. **Network Security**: The configuration creates an NSG that allows RDP (port 3389) from anywhere. Consider restricting this to your IP range in production.

2. **Password Management**: Store the VM password securely in GitHub Secrets. Consider using Azure Key Vault for production environments.

3. **Updates**: Ensure Windows updates are configured properly after deployment.

## Customization

You can modify the Terraform configuration to:
- Add multiple VMs
- Configure additional network security rules
- Add managed disks
- Set up backup policies
- Configure monitoring and logging

## Troubleshooting

### Common Issues:

1. **Authentication Error**: Verify your Azure credentials in GitHub Secrets
2. **Resource Already Exists**: Change the resource names or destroy existing resources
3. **Password Complexity**: Ensure the password meets Azure requirements
4. **Quota Limits**: Check your Azure subscription limits for the selected VM size

### Useful Commands:

```bash
# Check Terraform state locally
terraform state list

# Get output values
terraform output

# Format Terraform files
terraform fmt

# Validate configuration
terraform validate
```

## Cost Management

Remember to destroy resources when not needed to avoid charges:
1. Run the workflow with action set to `destroy`
2. Or manually delete the resource group in Azure portal

The cost depends on the VM size and how long it runs. A Standard_B2s VM typically costs around $60-80/month if running 24/7.