variables {
  location            = "uksouth"
  resource_group_name = "rg-tftest-uks-test"
  resource_suffix     = "uks-test"
}

run "integration_test_example_default" {

  command = plan

  module {
    source = "./examples_config/deployment"
  }

  assert {
    condition     = module.container_apps.container_app_environment_name == "container-app-env-uks-test"
    error_message = "Container App name did not match expected"
  }
}
