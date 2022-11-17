output "web_linuxvm_public_ip" {
  description = "Web Linux VM Public Address"
  value = azurerm_public_ip.web_linuxvm_publicbip.ip_address
}

output "web_linuxvm_network_interface_id" {
  description = "Web Linux VM Network Interface ID"
  value = azurerm_network_interface.web_linuxvm_nic.id
}

output "web_linuxvm_network_interface_private_ip_addresses" {
  value = [azurerm_network_interface.web_linuxvm_nic.private_ip_addresses]
}

