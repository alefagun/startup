variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "home_public_vcn_cidr" {
    description = "Default CIDR block for public hub VCN"
    default = "10.15.0.0/24"
}
variable "home_public_subnet_cidr" {
    description = "Default CIDR block for public subnet"
    default = "10.15.0.0/26"
}
variable "home_private_vcn_cidr" {
    description = "Default CIDR block for public spoke VCN"
    default = "10.15.1.0/24"
}
variable "home_private_subnet_cidr" {
       description = "Default CIDR block for private subnet"
    default = "10.15.1.0/26" 
}

variable "remote_public_vcn_cidr" {
    description = "Default CIDR block for public hub VCN"
    default = "192.168.0.0/24"
}
variable "remote_public_subnet_cidr" {
    description = "Default CIDR block for public subnet"
    default = "192.168.0.0/26"
}
variable "remote_private_vcn_cidr" {
    description = "Default CIDR block for public spoke VCN"
    default = "192.168.1.0/24"
}
variable "remote_private_subnet_cidr" {
       description = "Default CIDR block for private subnet"
    default = "192.168.1.0/26" 
}

variable "remote_region" {}
variable "instance_shape" {
    description = "Default size for VM creation and used for DB VM size"
    default = "VM.Standard2.1"
}
variable "operating_system" {
    description = "Operating system for compute instances"
    default     = "Oracle Autonomous Linux"   
}
variable "operating_system_version" {
    description = "Operating system version for all Linux instances"
    default     = "7.8"
}
variable "ssh_key" {}
variable "db_home_database_admin_password" {}
variable "database_edition" {
    description = "Default database edition"
    default = "ENTERPRISE_EDITION"
}
variable "db_version" {
    description = "Default database version"
    default = "19.0.0.0"
}
variable "data_storage_size_in_gb" {
    description = "Default initial database storage size"
    default = "256"
}
variable "node_count" {
    description = "Default number of VMs for Database creation"
    default = "1"
}

variable "license_model" {
    description = "Default License model being used"
    default = "BRING_YOUR_OWN_LICENSE"
}
# LICENSE_INCLUDED






