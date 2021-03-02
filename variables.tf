variable "subscription_id" {
  default = "SUBSCRIPTIONID"
  type = string
  description = "Subscription ID of your Azure Account"
}
variable "tenant_id" {
  default = "TENANTID"
  type = string
  description = "Tenant ID of your Azure AD"
}
variable "resource_group_name" {
  default = "appyhighcosmosdb-rg"
  type = string
  description = "Name of Resource group where you logically group all your resources"
}
variable "resource_group_location" {
  default = "australiaeast"
  type = string
  description = "Your primary DB location where all writes occur"
}
variable "cosmos_db_account_name" {
  default = "appyhighcosmosdb"
  type = string
  description = "Name of your database account"
}
variable "failover_location" {
  default = "australiasoutheast"
  type = string
  description = "failover location of your CosmosDB"
}