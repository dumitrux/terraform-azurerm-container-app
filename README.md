# terraform-azurerm-container-app

## Container App

- [Microsoft Docs about Azure Container Apps overview](https://learn.microsoft.com/en-gb/azure/container-apps/overview).  
- Example in [Azure/terraform-azure-container-apps](https://github.com/Azure/terraform-azure-container-apps).

## Deploy

```bash
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="0000000000000000000000000000000000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"

cd examples/deployment/
terraform init
terraform fmt -recursive

terraform apply -var-file="../configurations/default.tfvars"
terraform output

terraform destroy -var-file="../configurations/default.tfvars"
```

## Workflows

### Approve deployments

- [GitHub Actions: Terraform deployments with a review of planned changes](https://itnext.io/github-actions-terraform-deployments-with-a-review-of-planned-changes-30143358bb5c)
- [Reviewing deployments](https://docs.github.com/en/actions/managing-workflow-runs/reviewing-deployments)
