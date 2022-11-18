output "bastion_service_publicbip" {
  description = "Bastion Public IP"
  value = azurerm_public_ip.bastion_service_publicbip.ip_address
}