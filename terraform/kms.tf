##############################################################################
# Get Key Protect Resource Data
##############################################################################

data ibm_resource_instance kms {
    name              = var.kms_name
    resource_group_id = data.ibm_resource_group.resource_group.id
}

##############################################################################


##############################################################################
# Access Policy for KMS to read COS
##############################################################################

resource ibm_iam_authorization_policy cos_policy {  
  source_service_name         = "cloud-object-storage"
  source_resource_instance_id = data.ibm_resource_instance.cos.guid
  source_service_account      = var.account_id
  target_service_name         = "kms"
  target_resource_instance_id = data.ibm_resource_instance.kms.guid
  roles                       = ["Reader"]
}

############################################################################


############################################################################
# Create Key
############################################################################

resource ibm_kms_key key {
    instance_id   = data.ibm_resource_instance.kms.guid
    force_delete  = var.force_delete 
    key_name      = var.key_name
    payload       = var.key_payload == "" ? null : var.key_payload
    standard_key  = var.standard_key
    endpoint_type = var.endpoint_type
}

############################################################################