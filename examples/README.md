# Examples

This directory contains examples demonstrating how to use the PostgreSQL Flexible Server Terraform module.

## Available Examples

| Example | Description |
|---------|-------------|
| [basic](./basic) | Minimal configuration with default settings |
| [complete](./complete) | Full configuration with multiple databases and RBAC |
| [no-high-availability](./no-high-availability) | Cost-optimized configuration for dev/test environments |

## Quick Start

1. Navigate to the example directory:
   ```bash
   cd examples/basic
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the execution plan:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) for authentication
- An Azure subscription with appropriate permissions

## Authentication

Before running the examples, authenticate with Azure:

```bash
az login
az account set --subscription "<subscription-id>"
```

## Cleanup

To destroy the resources created by an example:

```bash
terraform destroy
```
