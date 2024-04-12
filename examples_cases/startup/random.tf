resource "random_id" "container_name" {
  byte_length = 4
}

resource "random_id" "env_name" {
  byte_length = 8
}

resource "random_id" "rg_name" {
  byte_length = 8
}
