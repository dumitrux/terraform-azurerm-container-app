locals {
  acr_login_server = [
    for c in azurerm_private_endpoint.pep.custom_dns_configs : c.ip_addresses[0]
    if c.fqdn == "${azurerm_container_registry.acr.name}.azurecr.io"
  ][0]

  data_endpoint_ips = { for e in azurerm_private_endpoint.pep.custom_dns_configs : e.fqdn => e.ip_addresses[0] }

  public_ip = module.public_ip.public_ip
}
