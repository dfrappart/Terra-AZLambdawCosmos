######################################################################
# Creation HDInsight Spark
######################################################################

resource "azurerm_template_deployment" "Template-LambdaSpark" {
  name                = "terraclustersparktemplate"
  resource_group_name = "${module.ResourceGroup.Name}"

  template_body = <<DEPLOY
{
   "$schema":"https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
   "contentVersion": "1.0.0.0",
      "location":{
        "type":"string",
        "metadata":{
          "description":"The location of the resources aka the location of the resource group"
        }
      },
      "clusterName":{
         "type":"string",
         "metadata":{
            "description":"The name of the HDInsight cluster to create."
         }
      },
      "clusterLoginUserName":{
         "type":"string",
         "defaultValue":"admin",
         "metadata":{
            "description":"These credentials can be used to submit jobs to the cluster and to log into cluster dashboards."
         }
      },
      "clusterLoginPassword":{
         "type":"securestring",
         "metadata":{
            "description":"The password must be at least 10 characters in length and must contain at least one digit, one non-alphanumeric character, and one upper or lower case letter."
         }
      },
      "sshUserName":{
         "type":"string",
         "defaultValue":"sshuser",
         "metadata":{
            "description":"These credentials can be used to remotely access the cluster."
         }
      },
      "sshPassword":{
         "type":"securestring",
         "metadata":{
            "description":"The password must be at least 10 characters in length and must contain at least one digit, one non-alphanumeric character, and one upper or lower case letter."
         }
      },
    "headNodeNumber": {
      "type": "string",
      "defaultValue": "3",
      "metadata": {
        "description": "Number of Head Nodes"
      }
    },
    "workerNodeNumber": {
      "type": "string",
      "defaultValue": "3",
      "metadata": {
        "description": "Number of Worker Nodes"
      }
    },    
    "zooKeeperNodeNumber": {
      "type": "string",
      "defaultValue": "3",
      "metadata": {
        "description": "Number of ZooKeeper Nodes"
      }
    },
    "headNodeVMSize": {
      "type": "string",
      "defaultValue": "Standard_D2_v3"
    },
    "workerNodeVMSize": {
      "type": "string",
      "defaultValue": "Standard_D2_v3"
    },
    "zooKeeperNodeVMSize": {
      "type": "string",
      "defaultValue": "Standard_D2_v3"
    },
    "existingVNETId": {
      "type": "string",
      "metadata": {
        "description": "Id of the target VNET"
      }
    },
    "zooKeeperNodeSubnet": {
      "type": "string",
      "metadata": {
        "description": "Name of the subnet for zooKeeper"
      }
    },
    "workerNodeSubnet": {
      "type": "string",
      "metadata": {
        "description": "Name of the subnet for workerNode"
      }
    },
    "headNodeSubnet": {
      "type": "string",
      "metadata": {
        "description": "Name of the subnet for headNode"
      }
    },
    "hdistorageaccountname":{
      "type":"string",
      "metadata": {
        "description":"Target Storage Account Name"
      }
    },
    "hdistoragecontainer":{
      "type":"string",
      "metadata": {
        "description":"Target Storage Container Name"
      }
    },
    "hdistoragekey":{
      "type":"string",
      "metadata": {
        "description":"Target Storage account key"
      }
    },
    "clusVersion":{
      "type":"string",
      "defaultValue":"3.6",
      "metadata":{
        "description":"The HDI Cluster Version"
      }
    },
    "hDIKind":{
      "type":"string",
      "defaultValue":"spark",
      "metadata":{
        "description":"The HDI Cluster Kind, can be Spark, HBase..."
      }
    }
   },
   "variables":{
   },
   "resources":[

      {
         "type":"Microsoft.HDInsight/clusters",
         "name":"[parameters('clusterName')]",
         "location":"[parameters('location')]",
         "apiVersion":"2015-03-01-preview",
         "properties":{
            "clusterVersion":"[parameters('clusVersion')]",
            "osType":"Linux",
            "clusterDefinition":{
               "kind":"[parameters('hDIKind')]",
               "configurations":{
                  "gateway":{
                     "restAuthCredential.isEnabled":true,
                     "restAuthCredential.username":"[parameters('clusterLoginUserName')]",
                     "restAuthCredential.password":"[parameters('clusterLoginPassword')]"
                  }
               }
            },
            "storageProfile":{
               "storageaccounts":[
                  {
                     "name":"[parameters('hdistorageaccountname')]",
                     "isDefault":true,
                     "container":"[parameters('hdistoragecontainer')]",
                     "key":"[parameters('hdistoragekey')]"
                  }
               ]
            },
            "computeProfile":{
               "roles":[
                  {
                     "name":"headnode",
                     "targetInstanceCount":"[parameters('headNodeNumber')]",
                     "hardwareProfile":{
                        "vmSize":"[parameters('headNodeVMSize')]"
                     },
                     "osProfile":{
                        "linuxOperatingSystemProfile":{
                           "username":"[parameters('sshUserName')]",
                           "password":"[parameters('sshPassword')]"
                        }
                     },
                     "virtualNetworkProfile": {
                          "id": "[parameters('existingVNetId')]",
                          "subnet": "[parameters('headNodeSubnet')]"
                        }
                  },
                  {
                     "name":"workernode",
                     "targetInstanceCount":"[parameters('workerNodeNumber')]",
                     "hardwareProfile":{
                        "vmSize":"[parameters('workerNodeVMSize')]"
                     },
                     "osProfile":{
                        "linuxOperatingSystemProfile":{
                           "username":"[parameters('sshUserName')]",
                           "password":"[parameters('sshPassword')]"
                        }
                     },
                     "virtualNetworkProfile": {
                          "id": "[parameters('existingVNetId')]",
                          "subnet": "[parameters('workerNodeSubnet')]"
                        }
                  },
                  {
                    "name": "zookeepernode",
                    "targetInstanceCount": "[parameters('zooKeeperNodeNumber')]",
                    "hardwareProfile": {
                        "vmSize": "[parameters('zooKeeperNodeVMSize')]"
                    },
                    "osProfile": {
                        "linuxOperatingSystemProfile": {
                            "username":"[parameters('sshUserName')]",
                            "password":"[parameters('sshPassword')]"
                        }
                    },
                    "virtualNetworkProfile": {
                        "id": "[parameters('existingVNETId')]",
                        "subnet": "[parameters('zooKeeperNodeSubnet')]"
                    }
                    }
               ]
            }
         }
      }
   ]
}
DEPLOY

  parameters {
    "resourceGroupName"    = "${module.ResourceGroup.Name}"
    "location"             = "${var.AzureRegion}"
    "clusterName"          = "HDICluster"
    "clusterLoginUserName" = "HDIAdmin"
    "clusterLoginPassword" = "Devoteam752018!"
    "sshUserName"          = "HDISSHUSer"
    "sshPassword"          = "Devoteam752018!"
    "existingVNETName"     = "${module.SampleArchi_vNet.Name}"
    "existingVNETId"       = "${module.SampleArchi_vNet.Id}"
    "headNodeSubnet"       = "${module.BE_Subnet.Name}"

    #"headNodeSubnetId"     = "${module.BE_Subnet.Id}"

    #"headNodeSubnetAddressPrefix"      = "${module.BE_Subnet.AddressPrefix}"
    "workerNodeSubnet" = "${module.BE_Subnet.Name}"

    #"workerNodeSubnetId" = "${module.BE_Subnet.Id}"

    #"workerNodeSubnetAddressPrefix"    = "${module.BE_Subnet.AddressPrefix}"
    "zooKeeperNodeSubnet" = "${module.BE_Subnet.Name}"

    #"zooKeeperNodeSubnetId" = "${module.BE_Subnet.Id}"

    #"zooKeeperNodeSubnetAddressPrefix" = "${module.BE_Subnet.AddressPrefix}"
    "hdistorageaccountname" = "${module.HDIStorageAccount.Id}"
    "hdistoragecontainer"   = "${module.HDIStorageContainer.Id}"
    "hdistoragekey"         = "${module.HDIStorageAccount.PrimaryAccessKey}"
    "zooKeeperNodeVMSize"   = "${lookup(var.VMSize,6)}"
    "headNodeVMSize"        = "${lookup(var.VMSize,6)}"
    "workerNodeVMSize"      = "${lookup(var.VMSize,6)}"
  }

  deployment_mode = "Incremental"
}
