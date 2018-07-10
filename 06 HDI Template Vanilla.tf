######################################################################
# Creation HDInsight Spark
######################################################################

#NSG Rules

module "AllowHDInsightHealthIn" {
  #Module source
  source = "./Modules/09 NSGRule"

  #Module variable
  RGName                            = "${module.ResourceGroup.Name}"
  NSGReference                      = "${module.NSG_BE_Subnet.Name}"
  NSGRuleName                       = "AllowHDInsightHealthIn"
  NSGRulePriority                   = 101
  NSGRuleDirection                  = "Inbound"
  NSGRuleAccess                     = "Allow"
  NSGRuleProtocol                   = "*"
  NSGRuleDestinationPortRanges      = ["443"]
  NSGRuleSourceAddressPrefixes      = ["168.61.49.99", "23.99.5.239", "168.61.48.131", "138.91.141.162", "52.166.243.90", "52.174.36.244"]
  NSGRuleDestinationAddressPrefixes = ["${lookup(var.SubnetAddressRange, 1)}"]
}

data "template_file" "customscripttemplate" {
  template = "${file("./Templates/templatehdi.json")}"
}

/*

resource "azurerm_template_deployment" "Template-LambdaSpark" {
  name                = "terraclustersparktemplate"
  resource_group_name = "${module.NetworkWatcherAgentForBastion.RGName}"

  template_body = "${data.template_file.customscripttemplate.rendered}"

  parameters {
    "location"              = "${var.AzureRegion}"
    "clusterName"           = "HDICluster"
    "clusterLoginUserName"  = "HDIAdmin"
    "clusterLoginPassword"  = "Devoteam752018!"
    "sshUserName"           = "HDISSHUSer"
    "sshPassword"           = "Devoteam752018!"
    "existingVNETId"        = "${module.SampleArchi_vNet.Id}"
    "headNodeSubnet"        = "${module.BE_Subnet.Name}"
    "workerNodeSubnet"      = "${module.BE_Subnet.Name}"
    "zooKeeperNodeSubnet"   = "${module.BE_Subnet.Name}"
    "hdistorageaccountname" = "${module.HDIStorageAccount.Id}"
    "hdistoragecontainer"   = "${module.HDIStorageContainer.Id}"
    "hdistoragekey"         = "${module.HDIStorageAccount.PrimaryAccessKey}"
    "zooKeeperNodeVMSize"   = "${lookup(var.VMSize,1)}"
    "headNodeVMSize"        = "${lookup(var.VMSize,1)}"
    "workerNodeVMSize"      = "${lookup(var.VMSize,1)}"
  }

  deployment_mode = "Incremental"
}
*/