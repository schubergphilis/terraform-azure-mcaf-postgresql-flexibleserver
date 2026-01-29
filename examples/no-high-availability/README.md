# No High Availability Example

This example demonstrates a PostgreSQL Flexible Server without high availability, suitable for development or non-critical workloads.

## Features

- Single-zone PostgreSQL Flexible Server (no HA)
- Burstable SKU for cost efficiency
- Minimal backup retention
- Simple database configuration
- Private endpoint connectivity
- Customer-managed key encryption

## Use Cases

- Development environments
- Testing environments
- Non-critical workloads
- Cost-conscious deployments

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Cost Considerations

This configuration uses a burstable SKU (`B_Standard_B1ms`) and disables high availability, resulting in significantly lower costs compared to production configurations. However, this is not suitable for production workloads that require high availability and performance.

## Requirements

- Azure subscription
- Terraform >= 1.0
- AzureRM provider >= 3.0
