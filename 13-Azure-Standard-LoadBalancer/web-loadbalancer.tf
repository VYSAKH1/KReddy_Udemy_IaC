resource "azurerm_public_ip" "web_lbpublicip" {
  name                = "${local.resource_name_prefix}-lbpublicip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_lb" "web_lb" {
  name                = "${local.resource_name_prefix}-weblb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "weblb-fe"
    public_ip_address_id = azurerm_public_ip.web_lbpublicip.id
  }
}

resource "azurerm_lb_backend_address_pool" "web_lb_bepool" {
  name = "web-backend"
  loadbalancer_id = azurerm_lb.web_lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  network_interface_id =   azurerm_network_interface.web_linuxvm_nic.id
  ip_configuration_name = azurerm_network_interface.web_linuxvm_nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_bepool.id
}

resource "azurerm_lb_probe" "web_lb_probe" {
  name = "tcp-probe"
  protocol = "Tcp"
  port = "80"
  loadbalancer_id = azurerm_lb.web_lb.id

}

resource "azurerm_lb_rule" "web_lb_rule_app1" {
  name = "web-app1-rule"
  protocol = "Tcp"
  frontend_port = "80"
  backend_port = "80"
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  loadbalancer_id = azurerm_lb.web_lb.id
  backend_address_pool_ids = [ "${azurerm_lb_backend_address_pool.web_lb_bepool.id}" ]
  probe_id = azurerm_lb_probe.web_lb_probe.id
}
