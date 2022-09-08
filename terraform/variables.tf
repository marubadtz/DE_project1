##############################################################################
# Account Variables
##############################################################################

variable ibmcloud_api_key {
    description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
    type        = string
}

variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed"
    type        = string
}

variable resource_group {
    description = "Name for IBM Cloud Resource Group where KMS and COS are deployed "
    type        = string
}

variable account_id {
    description = "Account ID where the COS and KMS instances are provisioned. This is required to ensure the authorization policy is created"
    type        = string
}

##############################################################################


##############################################################################
# Resource Instance Variables
##############################################################################

variable kms_name {
    description = "Name of KMS instance where the key will be uploaded"
    type        = string
}

variable cos_name {
    description = "COS instance where the bucket will be created"
    type        = string
}

##############################################################################


##############################################################################
# Key Variables
##############################################################################

variable endpoint_type {
    description = "Endpoint type for Key and COS Bucket. Can be `public` or `private`"
    type        = string
    default     = "public"
}

variable key_name {
    description = "Name of the key to be created"
    type        = string
    default      = "test-key"
}

variable key_payload {
    description = "Payload of the key to be created"
    type        = string
    default     = ""
}

variable standard_key {
    description = "Set flag true for standard key, and false for root key. Default value is false."
    type        = bool
    default     = false
}

variable force_delete {
    description = "If set to true, Key Protect forces the deletion of a root or standard key, even if this key is still in use, such as to protect an IBM Cloud Object Storage bucket. Note that the key cannot be deleted if the protected cloud resource is set up with a retention policy. Successful deletion includes the removal of any registrations that are associated with the key. Default value is false."
    type        = bool
    default     = true
}

##############################################################################


##############################################################################
# COS Bucket Variables
##############################################################################

variable bucket_name {
    description = "Name for the bucket to be created"
    type        = string
    default     = "encrypted-cos-bucket-example"
}

variable cross_region_location {
    description = "Location where the bucket will be provisioned. Currently this is only available in the US geo"
    type        = string
    default     = "us"
}

variable bucket_storage_class {
    description = "The storage class that you want to use for the bucket. Supported values are standard, vault, cold, flex, and smart."
    type        = string
    default     = "standard"
}

##############################################################################