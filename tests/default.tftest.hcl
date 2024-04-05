variables {
  location            = "uksouth"
  resource_group_name = "rg-ca-uks-test"
  resource_suffix     = "uks-test"
}

run "default_example" {

  command = apply

  module {
    source = "./examples/deployment"
  }

  assert {
    condition     = module.container_app.container_app_name == "example-app"
    error_message = "Container App name did not match expected"
  }
}

run "revision_mode_example" {

  command = apply

  module {
    source = "./examples/deployment"
  }

  variables {
    container_app_revision_mode = "Multiple"
  }

  assert {
    condition     = module.container_app.container_app_name == "example-app"
    error_message = "Container App name did not match expected"
  }
}
