package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestIT_Startup(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples_cases/startup",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"location": "uksouth",
		},
	}

	// To clean up the resources that have been created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}

func TestIT_InitContainer(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples_cases/init-container",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"location": "uksouth",
		},
	}

	// To clean up the resources that have been created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}

func TestIT_ACR(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples_cases/acr",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"location": "uksouth",
		},
	}

	// To clean up the resources that have been created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
