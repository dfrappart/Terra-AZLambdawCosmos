######################################################################
# Creation HDInsight Spark
######################################################################

resource "azurerm_template_deployment" "Template-LambdaSpark" {
  name                = "terraclustersparktemplate"
  resource_group_name = "${module.ResourceGroup.Name}"

  template_body = <<DEPLOY
{
   "$schema":"https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
   "contentVersion":"1.0.0.0",
   "parameters":{
      "resourceGroupName":{
        "type":"string",
        "metadata":{
          "description":"The Name of the target Resource Group"
        }
      },
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
    "existingVNETName": {
      "type": "string",
      "metadata": {
        "description": "Name of the target VNET "
      }
    },
    "existingVNETId": {
      "type": "string",
      "metadata": {
        "description": "Id of the target VNET "
      }
    },
    "zooKeeperSubnet": {
      "type": "string",
      "metadata": {
        "description": "Name of the subnet for zooKeeper"
      }
    },
    "zooKeeperSubnetId": {
      "type": "string",
      "metadata": {
        "description": "Id of the subnet for zooKeeper"
      }
    },
    "zooKeeperSubnetIdAddressPrefix": {
      "type": "string",
      "metadata": {
        "description": "Address space of subnet for zooKeeper"
      }
    }
    "workerNodeSubnet": {
      "type": "string",
      "metadata": {
        "description": "Name of the subnet for workerNode"
      }
    },
    "workerNodeSubnetId": {
      "type": "string",
      "metadata": {
        "description": "Id of the subnet for workerNode"
      }
    },
    "workerNodeSubnetIdAddressPrefix": {
      "type": "string",
      "metadata": {
        "description": "Address space of subnet for workerNode"
      }
    }
    "headNodeSubnet": {
      "type": "string",
      "metadata": {
        "description": "Name of the subnet for headNode"
      }
    },
    "headNodeSubnetId": {
      "type": "string",
      "metadata": {
        "description": "Id of the subnet for headNode"
      }
    },
    "headNodeSubnetIdAddressPrefix": {
      "type": "string",
      "metadata": {
        "description": "Address space of subnet for headNode"
      }
    }
    "hdistorageaccount":{
      "type":"string"
      "metadata": {
        "description":"Target Storage Account"
      }
    }
    "clusVersion":{
      "type":"string",
      "defaultValue":"3.6",
      "metadata":{
        "description":"The HDI Cluster Version"
      }
    }
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
         "dependsOn":[
            "[parameters('hdistorageaccount')]"
           
            
         ],
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
                     "name":"[replace(replace(concat(reference(concat('Microsoft.Storage/storageAccounts/', variables('defaultStorageAccount').name), '2016-01-01').primaryEndpoints.blob),'https:',''),'/','')]",
                     "isDefault":true,
                     "container":"[parameters('clusterName')]",
                     "key":"[listKeys(resourceId('Microsoft.Storage/storageAccounts', variables('defaultStorageAccount').name), '2016-01-01').keys[0].value]"
                  }
               ]
            },
            "computeProfile":{
               "roles":[
                  {
                     "name":"headnode",
                     "targetInstanceCount":[parameters('headNodeNumber')],
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
                          "subnet": "[parameters('headNodeSubnetName')]"
                        }
                  },
                  {
                     "name":"workernode",
                     "targetInstanceCount":[parameters('workerNodeNumber')],
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
                          "subnet": "[parameters('workerNodeSubnetName')]"
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
                        "subnet": "[parameters('zooKeperNodeSubnetName')]"
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
    "resourceGroupName"                = ""
    "location"                         = ""
    "clusterName"                      = ""
    "clusterLoginUserName"             = ""
    "clusterLoginPassword"             = ""
    "sshUserName"                      = ""
    "sshPassword"                      = ""
    "existingVNETName"                 = ""
    "existingVNETId"                   = ""
    "headNodeSubnetName"               = ""
    "headNodeSubnetId"                 = ""
    "headNodeSubnetAddressPrefix"      = ""
    "workerNodeSubnetName"             = ""
    "workerNodeSubnetId"               = ""
    "workerNodeSubnetAddressPrefix"    = ""
    "zooKeeperNodeSubnetName"          = ""
    "zooKeeperNodeSubnetId"            = ""
    "zooKeeperNodeSubnetAddressPrefix" = ""
    "hdistorageaccount"                = ""
  }

  deployment_mode = "Incremental"
}
