package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func UnitTestExampleDefault(t *testing.T) {
	t.Parallel()

	// Make a copy of the terraform module to a temporary directory. This allows running multiple tests in parallel
	// against the same terraform module.
	// exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples_config/deployment")

	expectedName := "container-app-env-uks-test"

	// website::tag::1::Configure Terraform setting path to Terraform code. We also
	// configure the options with default retryable errors to handle the most common retryable errors encountered in
	// terraform testing.
	// planFilePath := filepath.Join("../examples_config/deployment", "plan.out")
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples_config/deployment",

		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"../configurations/default.tfvars"},
		// Upgrade:  true,

		// Configure a plan file path so we can introspect the plan and make assertions about it.
		PlanFilePath: "unittest_plan.out",
	})

	// website::tag::2::Run `terraform init`, `terraform plan`, and `terraform show` and fail the test if there are any errors
	plan := terraform.InitAndPlanAndShowWithStruct(t, terraformOptions)

	// website::tag::3::Use the go struct to introspect the plan values.
	terraform.RequirePlannedValuesMapKeyExists(t, plan, "module.container_apps.azurerm_container_app_environment.container_env[0]")
	container_app_environment := plan.ResourcePlannedValuesMap["module.container_apps.azurerm_container_app_environment.container_env[0]"]
	container_app_environment_name := container_app_environment.AttributeValues["name"]
	assert.Equal(t, expectedName, container_app_environment_name)
}
