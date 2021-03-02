#Azure CosmosDB (NoSQL) Database 
#================================

## Requirements / Version compatibility

| Module version | Terraform version | AzureRM version |
|----------------|-------------------| --------------- |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage
    terraform init --> Initialize the terraform engine for azure resources 
    terraform validate --> Validatethe syntax or to ensure everything is inline with the terraform specifications
    terraform plan --> Check the raw output of what is going to be created/destroyed/modified as part of changes
    terraform apply --> Deploy the changes to azure platform
    terraform destroy --> destroy the whole environment

## Special Mention
    -   "autoscale_settings" for teh cosmos is still in review mode and is not active via terraform
    -   Despite terraform has active documentation, it is still not supported.
    -   We can very well achieve the outcome by setting the same using Azure Portal (Tactical)
    -   However code has been provided.

##  Disaster recovery — Cosmos DB
    1.  Azure Cosmos DB is a fully managed multi-database service. It enables you to build highly responsive applications worldwide. As part of Cosmos DB, Gremlin, Mongo DB, Cassandra and SQL APIs are supported. See next paragraphs for disaster recovery planning.
        1.1. Regional/global disaster
            The following measurements can be taken:
                -   For reading, an application can use the secondary endpoint in the paired region.
                -   Automatic failover is supported in Azure Cosmos DB. In case the primary region is down, the database in the secondary regions becomes the primary and can be used for writing data. Data conflicts can occur and are solved depending on the consistency level of Cosmos DB.
        1.2. Customer error
            The following measurements can be taken:
                -   Azure Cosmos DB creates automatic backups. In case a database is corrupted or deleted and needs to be restored, this can be requested, see process here
                -   Azure Cosmos DB change feed provides a persistent log of records within an Azure Cosmos DB container. Items in a the change feed can be replayed in a second container up to the point before the data corruption occured and then persisted back to the original container.

## Other Info
    -   Each module has been provided with self explanation comments at every stage including the variables.
    -   Pls make sure, you replace the Subscription and Tenant ID before using the same.