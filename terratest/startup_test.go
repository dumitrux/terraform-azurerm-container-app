package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesCaseStartup(t *testing.T) {
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

// func TestDefault(t *testing.T) {
// 	terraformOptions := &terraform.Options{
// 		TerraformDir: "../examples/deployment",
// 		VarFiles:     []string{"../configurations/default.tfvars"},
// 		// It is more common to use the Vars map to set variables
// 		// Vars: map[string]interface{}{
// 		// 	"location": "uksouth",
// 		// },
// 	}

// 	// To clean up the resources that have been created
// 	defer terraform.Destroy(t, terraformOptions)

// 	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
// 	terraform.InitAndApply(t, terraformOptions)
// }

// func TestPrivateNetworking(t *testing.T) {
// 	terraformOptions := &terraform.Options{
// 		// Source path of Terraform directory
// 		TerraformDir: "../examples/deployment",
// 		VarFiles:     []string{"../configurations/private-networking.tfvars"},
// 	}

// 	// To clean up the resources that have been created
// 	defer terraform.Destroy(t, terraformOptions)

// 	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
// 	terraform.InitAndApply(t, terraformOptions)
// }
