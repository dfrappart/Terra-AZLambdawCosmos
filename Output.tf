######################################################
# This file defines which value are sent to output
######################################################

######################################################
# Resource group info Output

output "ResourceGroupName" {
  value = "${module.ResourceGroup.Name}"
}

output "ResourceGroupId" {
  value = "${module.ResourceGroup.Id}"
}

######################################################
# vNet info Output

output "vNetName" {
  value = "${module.SampleArchi_vNet.Name}"
}

output "vNetId" {
  value = "${module.SampleArchi_vNet.Id}"
}

output "vNetAddressSpace" {
  value = "${module.SampleArchi_vNet.AddressSpace}"
}

######################################################
# Diag & Log Storage account Info

output "DiagStorageAccountName" {
  value = "${module.DiagStorageAccount.Name}"
}

output "DiagStorageAccountID" {
  value = "${module.DiagStorageAccount.Id}"
}

output "DiagStorageAccountPrimaryBlobEP" {
  value = "${module.DiagStorageAccount.PrimaryBlobEP}"
}

output "DiagStorageAccountPrimaryQueueEP" {
  value = "${module.DiagStorageAccount.PrimaryQueueEP}"
}

output "DiagStorageAccountPrimaryTableEP" {
  value = "${module.DiagStorageAccount.PrimaryTableEP}"
}

output "DiagStorageAccountPrimaryFileEP" {
  value = "${module.DiagStorageAccount.PrimaryFileEP}"
}

output "DiagStorageAccountPrimaryAccessKey" {
  value = "${module.DiagStorageAccount.PrimaryAccessKey}"
}

output "DiagStorageAccountSecondaryAccessKey" {
  value = "${module.DiagStorageAccount.SecondaryAccessKey}"
}

######################################################
# HDI Storage account Info

output "HDIStorageAccountName" {
  value = "${module.HDIStorageAccount.Name}"
}

output "HDIStorageAccountID" {
  value = "${module.HDIStorageAccount.Id}"
}

output "HDIStorageAccountPrimaryBlobEP" {
  value = "${module.HDIStorageAccount.PrimaryBlobEP}"
}

output "HDIStorageAccountPrimaryQueueEP" {
  value = "${module.HDIStorageAccount.PrimaryQueueEP}"
}

output "HDIStorageAccountPrimaryTableEP" {
  value = "${module.HDIStorageAccount.PrimaryTableEP}"
}

output "HDIStorageAccountPrimaryFileEP" {
  value = "${module.HDIStorageAccount.PrimaryFileEP}"
}

output "HDIStorageAccountPrimaryAccessKey" {
  value = "${module.HDIStorageAccount.PrimaryAccessKey}"
}

output "HDIStorageAccountSecondaryAccessKey" {
  value = "${module.HDIStorageAccount.SecondaryAccessKey}"
}

output "HDIStorageAccountConnectionURI" {
  value = "${module.HDIStorageAccount.ConnectionURI}"
}

######################################################
# Files Storage account Info

output "FilesExchangeStorageAccountName" {
  value = "${module.FilesExchangeStorageAccount.Name}"
}

output "FilesExchangeStorageAccountID" {
  value = "${module.FilesExchangeStorageAccount.Id}"
}

output "FilesExchangeStorageAccountPrimaryBlobEP" {
  value = "${module.FilesExchangeStorageAccount.PrimaryBlobEP}"
}

output "FilesExchangeStorageAccountPrimaryQueueEP" {
  value = "${module.FilesExchangeStorageAccount.PrimaryQueueEP}"
}

output "FilesExchangeStorageAccountPrimaryTableEP" {
  value = "${module.FilesExchangeStorageAccount.PrimaryTableEP}"
}

output "FilesExchangeStorageAccountPrimaryFileEP" {
  value = "${module.FilesExchangeStorageAccount.PrimaryFileEP}"
}

output "FilesExchangeStorageAccountPrimaryAccessKey" {
  value = "${module.FilesExchangeStorageAccount.PrimaryAccessKey}"
}

output "FilesExchangeStorageAccountSecondaryAccessKey" {
  value = "${module.FilesExchangeStorageAccount.SecondaryAccessKey}"
}

######################################################
# Subnet info Output
######################################################

######################################################
#FE_Subnet

output "FE_SubnetName" {
  value = "${module.FE_Subnet.Name}"
}

output "FE_SubnetId" {
  value = "${module.FE_Subnet.Id}"
}

output "FE_SubnetAddressPrefix" {
  value = "${module.FE_Subnet.AddressPrefix}"
}

######################################################
#BE_Subnet

output "BE_SubnetName" {
  value = "${module.BE_Subnet.Name}"
}

output "BE_SubnetId" {
  value = "${module.BE_Subnet.Id}"
}

output "BE_SubnetAddressPrefix" {
  value = "${module.BE_Subnet.AddressPrefix}"
}

######################################################
#Bastion_Subnet

output "Bastion_SubnetName" {
  value = "${module.Bastion_Subnet.Name}"
}

output "Bastion_SubnetId" {
  value = "${module.Bastion_Subnet.Id}"
}

output "Bastion_SubnetAddressPrefix" {
  value = "${module.Bastion_Subnet.AddressPrefix}"
}

######################################################
#Bastion VMs Output

output "Bastionfqdn" {
  value = ["${module.BastionPublicIP.fqdns}"]
}

output "BastionPrivateIP" {
  value = ["${module.NICs_Bastion.PrivateIPs}"]
}

output "BastionNICId" {
  value = ["${module.NICs_Bastion.Ids}"]
}

######################################################
#CosmosDB Output

output "LambdaCosmosDBId" {
  value = "${module.LambdaCosmosDB.Id}"
}

output "LambdaCosmosDBEP" {
  value = "${module.LambdaCosmosDB.EP}"
}

output "LambdaCosmosDBREP" {
  value = "${module.LambdaCosmosDB.REP}"
}

output "LambdaCosmosDBWEP" {
  value = "${module.LambdaCosmosDB.WEP}"
}

output "LambdaCosmosDBPMK" {
  value     = "${module.LambdaCosmosDB.PMK}"
  sensitive = true
}

output "LambdaCosmosDBSMK" {
  value     = "${module.LambdaCosmosDB.SMK}"
  sensitive = true
}

output "LambdaCosmosDBPRMK" {
  value     = "${module.LambdaCosmosDB.PRMK}"
  sensitive = true
}

output "LambdaCosmosDBSRMK" {
  value     = "${module.LambdaCosmosDB.SRMK}"
  sensitive = true
}

output "LambdaCosmosDBCSTR" {
  value = "${module.LambdaCosmosDB.CSTR}"
}
