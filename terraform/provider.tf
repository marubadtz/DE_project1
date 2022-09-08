variable "ibmcloud_api_key" {}
variable "region" {}
variable "account_id" {}

provider "ibm" {
    ibmcloud_api_key   = var.ibmcloud_api_key
    region = var.region
    }