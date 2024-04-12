variables {
  location            = "uksouth"
  resource_group_name = "rg-tftest-uks-test"
  resource_suffix     = "uks-test"
}

run "integration_test_example_default" {

  command = apply

  module {
    source = "./examples_config/deployment"
  }

  assert {
    condition     = module.container_apps.container_app_environment_name == "container-app-env-uks-test"
    error_message = "Container App name did not match expected"
  }
}

run "integration_test_example_monitoring" {

  command = apply

  module {
    source = "./examples_config/deployment"
  }

  variables {
    monitoring_enabled = true
  }

  assert {
    condition     = module.container_apps.container_app_environment_name == "container-app-env-uks-test"
    error_message = "Container App name did not match expected"
  }

  assert {
    condition     = can(azurerm_log_analytics_workspace.test[0].id)
    error_message = "Log Analytics Workspace does not exist"
  }
}

# run "default_example_cases" {

#   command = apply

#   module {
#     source = "./examples/deployment"
#   }

#   assert {
#     condition     = startswith(module.container_app.container_app_environment_name, "example-env-")
#     error_message = "Container App name did not match expected"
#   }
# }

# Forced error
# run "revision_mode_example" {

#   command = apply

#   module {
#     source = "./examples/deployment"
#   }

#   variables {
#     container_app_revision_mode = "Multiple"
#   }

#   assert {
#     condition     = module.container_app.container_app_name == "example-app"
#     error_message = "Container App name did not match expected"
#   }
# }
