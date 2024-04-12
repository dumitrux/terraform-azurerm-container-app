package test

import (
	"io"
	"net/http"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestE2E_InitContainer(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples_cases/init-container",
		Vars: map[string]interface{}{
			"location": "uksouth",
		},
	}

	// To clean up the resources that have been created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	url := terraform.Output(t, terraformOptions, "url")
	html, err := getHTML(url)
	require.NoError(t, err)

	// website::tag::3::Check the output against expected values.
	// Verify we're getting back the outputs we expect
	assert.Contains(t, html, "Hello from the debian container")
}

func getHTML(url string) (string, error) {
	resp, err := http.Get(url) // #nosec G107
	if err != nil {
		return "", err
	}
	defer func() {
		_ = resp.Body.Close()
	}()

	bytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	return string(bytes), nil
}
