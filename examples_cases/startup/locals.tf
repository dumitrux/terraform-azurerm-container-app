locals {
  counting_app_name  = "counting-ca-${random_id.container_name.hex}"
  dashboard_app_name = "dashboard-ca-${random_id.container_name.hex}"
}