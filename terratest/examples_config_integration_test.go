package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func IntegrationTestExampleDefault(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples_config/deployment",
		Upgrade:      true,
		VarFiles:     []string{"../configurations/default.tfvars"},
	}

	// To clean up the resources that have been created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	container_app_env_name := terraform.Output(t, terraformOptions, "container_app_environment_name")

	// website::tag::3::Check the output against expected values.
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "container-app-env-uks-test", container_app_env_name)
}

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
