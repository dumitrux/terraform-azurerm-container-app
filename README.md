# terraform-azurerm-container-app

- [terraform-azurerm-container-app](#terraform-azurerm-container-app)
  - [Container App](#container-app)
  - [Deploy](#deploy)
  - [Workflows](#workflows)
    - [Approve deployments](#approve-deployments)
  - [Rover](#rover)
    - [Generate static files](#generate-static-files)
    - [Terragrunt plan output](#terragrunt-plan-output)
    - [PowerShell](#powershell)

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

## Rover

Based on article [The Magic of Visualizing Your Cloud Infrastructure: Real-time Terraform Visualization.](https://medium.com/@prasadanilmore/the-magic-of-visualizing-your-cloud-infrastructure-real-time-terraform-visualization-c85ac0ca4933) that shows how to use the tool developed in [im2nguyen/rover](https://github.com/im2nguyen/rover).

```bash
docker pull im2nguyen/rover:latest

cd examples/deployment/
terraform init
terraform plan -out=tfplan -var-file="../configurations/default.tfvars"
terraform show -json tfplan > tfplan.json

docker run --rm -it -p 9000:9000 -v $(pwd)/tfplan.json:/src/tfplan.json im2nguyen/rover:latest -planJSONPath=tfplan.json
```

Open `http://localhost:9000`

### Generate static files

```bash
docker run --rm -it -p 9000:9000 -v $(pwd):/src im2nguyen/rover -planJSONPath=tfplan.json -standalone true
```

### Terragrunt plan output

```bash
cd lm-aml-accelerator-draft/platform/environments
terragrunt run-all show -json tfplan
terragrunt run-all show -json tfplan > tfplan.json
```

### PowerShell

```powershell
docker run --rm -it -p 9000:9000 -v "${PWD}\tfplan.json:/src/tfplan.json" im2nguyen/rover:latest -planJSONPath="tfplan.json"

docker run --rm -it -p 9000:9000 -v "${PWD}:/src" im2nguyen/rover -planJSONPath="tfplan.json" -standalone true
```
