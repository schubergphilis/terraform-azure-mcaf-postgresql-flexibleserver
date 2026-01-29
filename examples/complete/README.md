# Complete Example

This example demonstrates a full configuration for the PostgreSQL Flexible Server module with multiple databases and role-based access control.

## Features

- PostgreSQL Flexible Server with custom configuration
- Multiple databases with different access patterns
- Entra ID (Active Directory) authentication enabled
- Role-based access control using Entra ID groups and managed identities
- Zone-redundant high availability
- Customer-managed key encryption
- Private endpoint connectivity

## Databases

| Database | Purpose | Access Configuration |
|----------|---------|---------------------|
| `app_production` | Production application database | Admin groups, writer managed identities, reader groups |
| `app_staging` | Staging environment database | Writer groups for developers |
| `analytics` | Analytics and reporting database | Multiple reader groups, admin group for data engineers |

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Requirements

- Azure subscription
- Terraform >= 1.0
- AzureRM provider >= 3.0
- Existing Entra ID groups (or modify the example to use your own groups)
