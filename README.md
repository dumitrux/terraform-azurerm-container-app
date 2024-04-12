# terraform-azurerm-tests <!-- omit in toc -->

- [Container App](#container-app)
- [Workflows](#workflows)
  - [Approve deployments](#approve-deployments)
- [Tests](#tests)
  - [Terraform Tests](#terraform-tests)
  - [Terratest](#terratest)
    - [Debugging interleaved test output](#debugging-interleaved-test-output)
- [Manually deploy examples](#manually-deploy-examples)
  - [Examples configurations](#examples-configurations)
  - [Examples cases](#examples-cases)
- [Docs](#docs)
  - [Changelog](#changelog)
  - [Dependenbot](#dependenbot)
  - [Rover](#rover)
    - [Generate static files](#generate-static-files)
    - [Terragrunt plan output](#terragrunt-plan-output)
    - [PowerShell](#powershell)

## Container App

- [Azure Container Apps overview | Microsoft Learn](https://learn.microsoft.com/en-gb/azure/container-apps/overview).  
- Example in [Azure/terraform-azure-container-apps: A Terraform module to deploy a container app in Azure (github.com)](https://github.com/Azure/terraform-azure-container-apps).
  - This example uses workflows and scripts from [tfmod-scaffold/scripts at main · Azure/tfmod-scaffold (github.com)](https://github.com/Azure/tfmod-scaffold/tree/main/scripts)

## Workflows

### Approve deployments

- [GitHub Actions: Terraform deployments with a review of planned changes](https://itnext.io/github-actions-terraform-deployments-with-a-review-of-planned-changes-30143358bb5c)
- [Reviewing deployments](https://docs.github.com/en/actions/managing-workflow-runs/reviewing-deployments)

## Tests

### Terraform Tests

- [Write Terraform Tests | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/tutorials/configuration-language/test)

```bash
terraform init

terraform test -var-file="examples_config/configurations/default.tfvars"

terraform test -var-file="examples_config/configurations/private-networking.tfvars"

terraform test -var-file="../../examples_config/configurations/default.tfvars"
```

### Terratest

- [Quick start (gruntwork.io)](https://terratest.gruntwork.io/docs/getting-started/quick-start/)
- [terratest/test/terraform_basic_example_test.go at master · gruntwork-io/terratest (github.com)](https://github.com/gruntwork-io/terratest/blob/master/test/terraform_basic_example_test.go)

```bash
cd terratest

go mod init terraform-azurerm-tests
go mod tidy
go test -timeout 30m | tee terratest_output.log
```

#### Debugging interleaved test output

[Debugging interleaved test output (gruntwork.io)](https://terratest.gruntwork.io/docs/testing-best-practices/debugging-interleaved-test-output/)

```bash
curl --location --silent --fail --show-error -o terratest_log_parser https://github.com/gruntwork-io/terratest/releases/download/v0.13.13/terratest_log_parser_linux_amd64

chmod +x terratest_log_parser

sudo mv terratest_log_parser /usr/local/bin

terratest_log_parser -testlog test_output.log -outputdir test_output
```

This will:

- Create a file TEST_NAME.log for each test it finds from the test output containing the logs corresponding to that test.
- Create a summary.log file containing the test result lines for each test.
- Create a report.xml file containing a Junit XML file of the test summary (so it can be integrated in your CI).

## Manually deploy examples

```bash
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="0000000000000000000000000000000000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
```

### Examples configurations

```bash
cd examples_config/deployment/
terraform init
terraform fmt -recursive

terraform apply -var-file="../configurations/default.tfvars"
terraform output

terraform destroy -var-file="../configurations/default.tfvars"
```

### Examples cases

```bash
cd examples_cases/startup
terraform init
terraform fmt -recursive

terraform apply
terraform output

terraform destroy -auto-approve
```


## Docs

### Changelog

### Dependenbot

### Rover

Based on article [The Magic of Visualizing Your Cloud Infrastructure: Real-time Terraform Visualization.](https://medium.com/@prasadanilmore/the-magic-of-visualizing-your-cloud-infrastructure-real-time-terraform-visualization-c85ac0ca4933) that shows how to use the tool developed in [im2nguyen/rover](https://github.com/im2nguyen/rover).

```bash
docker pull im2nguyen/rover:latest

cd examples_config/deployment/
terraform init
terraform plan -out=tfplan -var-file="../configurations/default.tfvars"
terraform show -json tfplan > tfplan.json

docker run --rm -it -p 9000:9000 -v $(pwd)/tfplan.json:/src/tfplan.json im2nguyen/rover:latest -planJSONPath=tfplan.json
```

Open `http://localhost:9000`

#### Generate static files

```bash
docker run --rm -it -p 9000:9000 -v $(pwd):/src im2nguyen/rover -planJSONPath=tfplan.json -standalone true
```

#### Terragrunt plan output

```bash
cd lm-aml-accelerator-draft/platform/environments
terragrunt run-all show -json tfplan
terragrunt run-all show -json tfplan > tfplan.json
```

#### PowerShell

```powershell
docker run --rm -it -p 9000:9000 -v "${PWD}\tfplan.json:/src/tfplan.json" im2nguyen/rover:latest -planJSONPath="tfplan.json"

docker run --rm -it -p 9000:9000 -v "${PWD}:/src" im2nguyen/rover -planJSONPath="tfplan.json" -standalone true
```
