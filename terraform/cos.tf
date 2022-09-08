##############################################################################
# Get COS Resource Data
##############################################################################

data ibm_resource_instance cos {
    name              = var.cos_name
    resource_group_id = data.ibm_resource_group.resource_group.id
}


##############################################################################


############################################################################
# Create Bucket
############################################################################

resource ibm_cos_bucket bucket {
    bucket_name           = var.bucket_name
    cross_region_location = var.cross_region_location
    endpoint_type         = var.endpoint_type
    force_delete          = true
    key_protect           = ibm_kms_key.key.id
    resource_instance_id  = data.ibm_resource_instance.cos.id
    storage_class         = var.bucket_storage_class
    
    # Policy must be created before the bucket will provision
    depends_on = [ ibm_iam_authorization_policy.cos_policy ]
}

##############################################################################