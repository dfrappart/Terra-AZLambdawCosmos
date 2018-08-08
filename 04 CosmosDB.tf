######################################################
# This file deploys a CosmosDB account
######################################################

resource "random_string" "CosmosDBPrefix" {
  length  = 5
  upper   = "false"
  lower   = "true"
  number  = "true"
  special = "false"
}

module "LambdaCosmosDB" {
  #Module location
  source = "./Modules/15 CosmosDB"

  #Module variables
  CosmosDBName     = "${random_string.CosmosDBPrefix.result}lambdacosmos"
  CosmosDBLocation = "${var.AzureRegion}"
  CosmosDBRG       = "${module.ResourceGroupInfra.Name}"
}


