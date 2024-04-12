package test

import (
	"os"
	"path"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	terraformCore "github.com/hashicorp/terraform/terraform"
)

func UnitTestExampleDefault(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples_config/deployment",
		Upgrade:      true,
		VarFiles:     []string{"../configurations/default.tfvars"},
	}

	// Terraform init and plan only
	tfPlanOutput := "terraform.tfplan"
	terraform.Init(t, terraformOptions)
	terraform.RunTerraformCommand(t, terraformOptions, terraform.FormatArgs(terraformOptions, "plan", "-out="+tfPlanOutput)...)

	// Read and parse the plan output
	f, err := os.Open(path.Join(terraformOptions.TerraformDir, tfPlanOutput))
	if err != nil {
		t.Fatal(err)
	}
	defer f.Close()
	plan, err := terraformCore.ReadPlan(f)
	if err != nil {
		t.Fatal(err)
	}

	// Validate the test result
	for _, mod := range plan.Diff.Modules {
		if len(mod.Path) == 2 && mod.Path[0] == "root" && mod.Path[1] == "terraform-tests" {
			actual := mod.Resources["module.container_apps"].Attributes["container_app_environment_name"].New
			if actual != "container-app-env-uks-test" {
				t.Fatalf("Expect %v, but found %v", "container-app-env-uks-test", actual)
			}
		}
	}

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
