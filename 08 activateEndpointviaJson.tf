######################################################################
# This file activate Endpoint for CosmosDB
######################################################################
data "template_file" "customscripttemplateEPVNet" {
  template = "${file("./Templates/templateEPVNet.json")}"
}

resource "azurerm_template_deployment" "Template-VNetEndpoint" {
  name                = "terraVNettemplate"
  resource_group_name = "${module.ResourceGroupInfra.Name}"

  template_body = "${data.template_file.customscripttemplateEPVNet.rendered}"

  parameters {
    "name"                = "${module.SampleArchi_vNet.Name}"
    "location"            = "${module.SampleArchi_vNet.RGLocation}"
    "addressPrefix"       = "${element(var.vNetIPRange,0)}"
    "SubnetName"          = "HDI_Subnet"
    "SubnetAddressPRefix" = "10.0.3.0/24"

    #"enableDdosProtection" = "true"
  }

  deployment_mode = "Incremental"
}
