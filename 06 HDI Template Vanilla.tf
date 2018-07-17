######################################################################
# Creation HDInsight Spark
######################################################################
#FE_Subnet NSG

module "NSG_HDI_Subnet" {
  #Module location
  source = "./Modules/07 NSG"

  #Module variable
  NSGName             = "NSG_${lookup(var.SubnetName, 3)}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  NSGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#FE_Subnet

module "HDI_Subnet" {
  #Module location
  source = "./Modules/06 Subnet"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 3)}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  vNetName            = "${module.SampleArchi_vNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 3)}"
  NSGid               = "${module.NSG_FE_Subnet.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NSG Rules

module "AllowHDInsightHealthIn" {
  #Module source
  source = "./Modules/09 NSGRule"

  #Module variable
  RGName                            = "${module.ResourceGroupInfra.Name}"
  NSGReference                      = "${module.NSG_HDI_Subnet.Name}"
  NSGRuleName                       = "AllowHDInsightHealthIn"
  NSGRulePriority                   = 101
  NSGRuleDirection                  = "Inbound"
  NSGRuleAccess                     = "Allow"
  NSGRuleProtocol                   = "*"
  NSGRuleDestinationPortRanges      = ["443"]
  NSGRuleSourceAddressPrefixes      = ["168.61.49.99", "23.99.5.239", "168.61.48.131", "138.91.141.162", "52.166.243.90", "52.174.36.244"]
  NSGRuleDestinationAddressPrefixes = ["${lookup(var.SubnetAddressRange, 3)}"]
}

data "template_file" "templateHDISpark" {
  template = "${file("./Templates/templatehdi.json")}"
}

resource "azurerm_template_deployment" "Template-LambdaSpark" {
  name                = "terraclustersparktemplate"
  resource_group_name = "${module.ResourceGroupHDI.Name}"

  template_body = "${data.template_file.templateHDISpark.rendered}"

  parameters {
    "location"              = "${var.AzureRegion}"
    "clusterName"           = "HDICluster${var.EnvironmentTag}${var.EnvironmentUsageTag}"
    "clusterLoginUserName"  = "hdiadmin"
    "clusterLoginPassword"  = "${data.azurerm_key_vault_secret.VMPassword.value}"
    "sshUserName"           = "hdisshuser"
    "sshPassword"           = "${data.azurerm_key_vault_secret.VMPassword.value}"
    "existingVNETId"        = "${module.SampleArchi_vNet.Id}"
    "headNodeSubnet"        = "${module.HDI_Subnet.Id}"
    "workerNodeSubnet"      = "${module.HDI_Subnet.Id}"
    "zooKeeperNodeSubnet"   = "${module.HDI_Subnet.Id}"
    "hdistorageaccountname" = "${module.HDIStorageAccount.Name}"
    "hdistoragecontainer"   = "${module.HDIStorageContainer.Name}"
    "hdistoragekey"         = "${module.HDIStorageAccount.PrimaryAccessKey}"
    "zooKeeperNodeVMSize"   = "${lookup(var.VMSize,1)}"
    "headNodeVMSize"        = "${lookup(var.VMSize,1)}"
    "workerNodeVMSize"      = "${lookup(var.VMSize,1)}"
  }

  deployment_mode = "Incremental"
}
