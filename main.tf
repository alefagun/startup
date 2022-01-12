provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
provider "oci" {
  alias            = "remote"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.remote_region
}

module "Home"{
    source = "./home"
    compartment_ocid                  = var.compartment_ocid
    instance_shape                    = var.instance_shape
    ssh_key                           = var.ssh_key
    db_home_database_admin_password   = var.db_home_database_admin_password
    database_edition                  = var.database_edition
    db_version                        = var.db_version
    remote_region                     = var.remote_region
    operating_system                  = var.operating_system
    operating_system_version          = var.operating_system_version
    home_public_vcn_cidr              = var.home_public_vcn_cidr
    home_private_vcn_cidr             = var.home_private_vcn_cidr
    home_public_subnet_cidr           = var.home_public_subnet_cidr
    home_private_subnet_cidr          = var.home_private_subnet_cidr
    # Details about remote region to setup data guard association
    remote_private_subnet_id          = module.Remote.RemotePrivatSubnetId
    remote_availability_domain        = module.Remote.RemoteAvilabilityDoman
    data_storage_size_in_gb           = var.data_storage_size_in_gb
    node_count                        = var.node_count
    license_model                     = var.license_model

}

module "Remote"{
    source                              = "./remote"
    providers                           = {oci=oci.remote}
    compartment_ocid                    = var.compartment_ocid
    instance_shape                      = var.instance_shape
    ssh_key                             = var.ssh_key
    db_home_database_admin_password     = var.db_home_database_admin_password
    database_edition                    = var.database_edition
    db_version                          = var.db_version
    remote_region                       = var.remote_region
    operating_system                    = var.operating_system
    operating_system_version            = var.operating_system_version
    remote_public_vcn_cidr              = var.remote_public_vcn_cidr
    remote_private_vcn_cidr             = var.remote_private_vcn_cidr
    remote_public_subnet_cidr           = var.remote_public_subnet_cidr
    remote_private_subnet_cidr          = var.remote_private_subnet_cidr

    home_region                         = var.region
    # variable from home region used to stablish remote peering connection between 2 hub VCNs
    home_remote_peering_connection_ocid = module.Home.RemotePeeringGatewayOCID
    # variable from home region used to stablish remote peering connection and setup data guard
    db_remote_peering_connection_ocid   = module.Home.DBPeeringGatewayOCID
}

# Home Region Instance Information
# TRANSIT INSTANCE DETAILS
output "HomeTransitInstance" {
    value = module.Home.TransitInstance
}
output "HomeTransitPublicIp" {
    value = module.Home.TransitPublicIp
}
output "HomeTransitPrivateIp" {
    value = module.Home.TransitPrivateIp
}

# PRIVATE INSTANCE DETAILS
# Private Instance Details commented as they are only required in case you want to test connectivity before creating the database
# output "HomePrivateInstance" {
#     value = module.Home.PrivateInstance
# }

# output "HomePrivatePrivateIp" {
#     value = module.Home.PrivatePrivateIp
# }

# output "HomeRemotePeeringGatewayOCID" {
#     value = module.Home.RemotePeeringGatewayOCID
# }

# Remote Region Instance Information
# TRANSIT INSTANCE DETAILS
output "RemoteTransitInstance" {
    value = module.Remote.TransitInstance
}
output "RemoteTransitPublicIp" {
    value = module.Remote.TransitPublicIp
}
output "RemoteTransitPrivateIp" {
    value = module.Remote.TransitPrivateIp
}

# PRIVATE INSTANCE DETAILS
# Private Instance Details commented as they are only required in case you want to test connectivity before creating the database
# output "RemotePrivateInstance" {
#     value = module.Remote.PrivateInstance
# }

# output "RemotePrivatePrivateIp" {
#     value = module.Remote.PrivatePrivateIp
# }

# output "RemoteRemotePeeringGatewayOCID" {
#     value = module.Remote.RemotePeeringGatewayOCID
# }