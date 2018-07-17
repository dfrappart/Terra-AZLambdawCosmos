######################################################
# This file deploys the base AZure Resource
# Resource Group + vNet
######################################################

######################################################################
# Access to Azure
######################################################################

# Configure the Microsoft Azure Provider with Azure provider variable defined in AzureDFProvider.tf

provider "azurerm" {
  subscription_id = "${var.AzureSubscriptionID1}"
  client_id       = "${var.AzureClientID}"
  client_secret   = "${var.AzureClientSecret}"
  tenant_id       = "${var.AzureTenantID}"
}

######################################################################
# Foundations resources, including ResourceGroup and vNET
######################################################################

# Creating the ResourceGroup

module "ResourceGroupInfra" {
  #Module Location
  source = "./Modules/01 ResourceGroup"

  #Module variable
  RGName              = "${var.RGName}-${var.EnvironmentUsageTag}${var.EnvironmentTag}-Infra"
  RGLocation          = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "ResourceGroupHDI" {
  #Module Location
  source = "./Modules/01 ResourceGroup"

  #Module variable
  RGName              = "${var.RGName}-${var.EnvironmentUsageTag}${var.EnvironmentTag}-HDI"
  RGLocation          = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

# Creating vNET

module "SampleArchi_vNet" {
  #Module location
  source = "./Modules/02 VNet"

  #Module variable
  vNetName            = "${var.vNetName}${var.EnvironmentUsageTag}${var.EnvironmentTag}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  vNetLocation        = "${var.AzureRegion}"
  vNetAddressSpace    = "${var.vNetIPRange}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Creating Storage Account for logs and Diagnostics

module "DiagStorageAccount" {
  #Module location
  source = "./Modules/03 StorageAccountGP"

  #Module variable
  StorageAccountName     = "${var.EnvironmentTag}log"
  RGName                 = "${module.ResourceGroupInfra.Name}"
  StorageAccountLocation = "${var.AzureRegion}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

module "LogStorageContainer" {
  #Module location
  source = "./Modules/04 StorageAccountContainer"

  #Module variable
  StorageContainerName = "logs"
  RGName               = "${module.ResourceGroupInfra.Name}"
  StorageAccountName   = "${module.DiagStorageAccount.Name}"
  AccessType           = "private"
}

#Creating Storage Account for HDI

module "HDIStorageAccount" {
  #Module location
  source = "./Modules/03 StorageAccountGP"

  #Module variable
  StorageAccountName     = "${var.EnvironmentTag}hdi"
  RGName                 = "${module.ResourceGroupInfra.Name}"
  StorageAccountLocation = "${var.AzureRegion}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

module "HDIStorageContainer" {
  #Module location
  source = "./Modules/04 StorageAccountContainer"

  #Module variable
  StorageContainerName = "hdi"
  RGName               = "${module.ResourceGroupInfra.Name}"
  StorageAccountName   = "${module.DiagStorageAccount.Name}"
  AccessType           = "private"
}

#Creating Storage Account for files exchange

module "FilesExchangeStorageAccount" {
  #Module location
  source = "./Modules/03 StorageAccountGP"

  #Module variable
  StorageAccountName     = "${var.EnvironmentTag}file"
  RGName                 = "${module.ResourceGroupInfra.Name}"
  StorageAccountLocation = "${var.AzureRegion}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

#Creating Storage Share

module "InfraFileShare" {
  #Module location
  source = "./Modules/05 StorageAccountShare"

  #Module variable
  ShareName          = "infrafileshare"
  RGName             = "${module.ResourceGroupInfra.Name}"
  StorageAccountName = "${module.FilesExchangeStorageAccount.Name}"
  Quota              = "0"
}

######################################################################
# Data sources
######################################################################

data "azurerm_resource_group" "KeyVaultRG" {
  name = "RG-KeyVaultTest"
}

data "azurerm_key_vault" "Keyvault" {
  name                = "dfkeyvaulttest01"
  resource_group_name = "${data.azurerm_resource_group.KeyVaultRG.name}"
}

#Data source for VM Password in keyvault

data "azurerm_key_vault_secret" "VMPassword" {
  name      = "DefaultVMPassword"
  vault_uri = "${data.azurerm_key_vault.Keyvault.vault_uri}"
}
