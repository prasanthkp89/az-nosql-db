# Declare/Specify the required tf version for azure
# Mandatory Values - subscription & tenant_id [ref Azure AD for the same]
# DO NOT Hard Code variables/values anywhere in the project. Its always a good practice to pass the values run_time or using variables file. 
# Values will be referenced from variables.tf during runtime
provider "azurerm" {
  version         = "~> 2.19.0"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}

# Create Resource Group which will be used to group all the resources that we are going to create ex: cosmosdb, vpc, vm's, asg, nsg etc.,
# Values will be referenced from variables.tf during runtime
# Create the tags for each resource which will enable us to identify the purpose of each service as for other devops activities.
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags = {
    purpose   = "appyhigh_poc"
    createdBy = "prasanth"
  }
}

# Create CosmosDB service with the necessary input options/varibales as per the standards.
# Mandatory Fields - name, resource_group,location,offer_type,consistency_policy,geo_location,
# consistency_levels - BoundedStaleness, Eventual, Session, Strong or ConsistentPrefix
# virtual_network_rule -- Configures the virtual network subnets allowed to access this Cosmos DB account (if required)
# Values will be referenced from variables.tf during runtime
resource "azurerm_cosmosdb_account" "cosmosacc" {
  name                = var.cosmos_db_account_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    purpose = "appyhigh-poc"
  }
  offer_type                = "Standard"
  kind                      = "MongoDB"
  enable_automatic_failover = true

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  consistency_policy {
    consistency_level       = "Strong"
  }
  # Priority 0 indicates a WRITE region 
  geo_location {
    location          = var.failover_location
    failover_priority = 0
  }
  # Anything other than 0 represents Failover Location. Max value of Failover should be 'Total No.of Regions -1'
  geo_location {
    location          = var.resource_group_location
    failover_priority = 1
  }
}

# Creating an Mongo API Database in the CosmosDb called 'mobilepro'
# Vertical Scaling - Database will be set an initial throughput of 400 RU's. [This is shared across all containers/collection in the DB]
# We can even set the throughput independently at each container/collection level as well
# Throughput and storage limits for autoscale as follows
# Azure Cosmos DB scales the throughput T such 0.1*Tmax <= T <= Tmax [Tmax=4000]
# For Tmax, the database or container can store a total of 0.01 * Tmax GB. After this amount of storage is reached, the maximum RU/s will be automatically increased based on the new storage value.
resource "azurerm_cosmosdb_mongo_database" "mobiledb" {
  name                = "mobilepro"
  resource_group_name = azurerm_cosmosdb_account.cosmosacc.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosacc.name

  throughput          = 400

 #autoscale_settings {
 #   max_throughput = 4000
 # }
}


# Creating a DB collection called 'mobilecollection' and associating the same to RG aswell as the CosmosDB Account and API Database
# Specify the partition key which will be used to query the DB ()
resource "azurerm_cosmosdb_mongo_collection" "mobilecollection" {
  name                = "brands"
  resource_group_name = azurerm_cosmosdb_account.cosmosacc.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosacc.name
  database_name       = azurerm_cosmosdb_mongo_database.mobiledb.name

  default_ttl_seconds = "600"
  shard_key           = "uniqueKey"
}