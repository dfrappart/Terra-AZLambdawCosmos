######################################################################
# This file activate Endpoint for CosmosDB
######################################################################

data "template_file" "templateSubnetwEP" {
  template = "${file("./Templates/templateEPSubnet.json")}"
}

resource "azurerm_template_deployment" "Template-VNetEndpoint" {
  name                = "terraVNettemplate"
  resource_group_name = "${module.ResourceGroupInfra.Name}"

  template_body = "${data.template_file.templateSubnetwEP.rendered}"

  parameters {
    "location"            = "${module.SampleArchi_vNet.RGLocation}"
    "ExistingVNetName"    = "${module.SampleArchi_vNet.Name}"
    "subnetName"          = "${module.HDI_Subnet.Name}"
    "subnetAddressPrefix" = "${lookup(var.SubnetAddressRange, 3)}"
    "nSGID"               = "${module.NSG_FE_Subnet.Id}"
  }

  deployment_mode = "Incremental"
}
