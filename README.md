# oci-hub-spoke-data-guard

The **Oracle Cloud Infrastructure (OCI) Hub Spoke Data Guard**(repo URL) is targeted to deploy Oracle Database Services in a Hub-Spoke network model across two regions, leveraging the Data Guard association and terraform resources available.

The oci-hub-spoke-data-guard repository contains the template to deploy a simple single node VM instance in each region, but it can be modified to deploy RAC, only increase the number of node_count variable.

Most values can be overwritten at variables level, otherwise they will all use the defaults in the main variables file.

The regions are divided in modules, home and remote, both modules being called by the main.tf in the root directory.

## Prerequisites

- OCI Tenancy with:
  - Compartment to host the components being created
  - Group/User with the right level of access and IAM policies to create the resources, details can be found [here](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Concepts/policygetstarted.htm)
  - API Keys deployed, details can be found [here](https://docs.cloud.oracle.com/en-us/iaas/Content/Functions/Tasks/functionssetupapikey.htm) 

- Terraform v0.12.24 or earlier 

## Build

Download the content of this repository and edit the terraform.tfvars file and:
  - Fill all variables under the **Identity** section
  - Specify the **ssh_key** variable with the public portion of the SSH key that will be used to connect into the compute instance and database hosts
  - Specify the **db_home_database_admin_password** variable with the SYS password that will be used for the database creation
All other variables are commented and using defaults from the variable file, but they can be uncommented and specified to ovewrite the default
You terraform.tfvars file would look like this:
```bash
    # Identity
    tenancy_ocid = "ocid1.tenancy.oc1....."
    user_ocid = "ocid1.user.oc1....."
    fingerprint = "22:7f:70:eb:3b:ef:bf:6f...."
    private_key_path = "/home/oci_api_key.pem"
    region = "ap-sydney-1"
    remote_region = "ap-melbourne-1"
    compartment_ocid = "ocid1.compartment.oc1..."

    # Network
    # Using default values, it can be uncommented if you want to specify values
    # home_public_vcn_cidr = 
    # home_private_vcn_cidr = 
    # home_public_subnet_cidr = 
    # home_private_subnet_cidr = 

    # remote_public_vcn_cidr = 
    # remote_private_vcn_cidr = 
    # remote_public_subnet_cidr = 
    # remote_private_subnet_cidr = 


    # Compute Instances
    # Using default values, it can be uncommented if you want to specify values
    # instance_shape = "VM.Standard2.1"
    # operating_system = "Oracle Autonomous Linux"
    # operating_system_version = "7.8"
    ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSg+aeG+..."


    # Database
    db_home_database_admin_password = "HomeDbPssword2020##"
    # Using default values, it can be uncommented if you want to specify values
    # database_edition = "ENTERPRISE_EDITION"
    # db_version = "19.0.0.0"
    # data_storage_size_in_gb = "256"
    # node_count = "1"
```

At first time, you are required to initialize the terraform modules used by the template with  `terraform init` command:

```bash
$ terraform init
$ terraform init
Initializing modules...
- Home in home
- Remote in remote

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "oci" (hashicorp/oci) 3.78.0...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.oci: version = "~> 3.78"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```
```bash
$ terraform apply

Plan: 47 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```
The creation process can take around **two and a half hours**. 

After the creation, you can remove the dedicated DB-DRGs that were created to use DBCS automation to deploys Data Guard association, all the redo logs will follow the right network path and the databases will remain in sync.

You can run:
```bash
$ terraform destroy -target=module.Home.oci_core_remote_peering_connection.db_remote_peering_connection -target=module.Home.oci_core_drg.db_drg -target=module.Home.oci_core_drg_attachment.db_drg_attachment -target=module.Remote.oci_core_remote_peering_connection.db_remote_peering_connection -target=module.Remote.oci_core_drg.db_drg -target=module.Remote.oci_core_drg_attachment.db_drg_attachment
```
to delete all 6 resources:
DRG x 2
DRG Attachment x 2
Remote Peering Connection x 2


> Identity

|          VARIABLE          |           DESCRIPTION                                                 |
|----------------------------|-----------------------------------------------------------------------|
|tenancy_ocid         | OCID of the tenancy where the resources will be build |
|user_ocid               | OCID of the user that will build the resources|
|fingerprint          | The fingerprint of the SSH Key deployed in OCI|
|private_key_path               | Path to the local private API key that pairs with the key deployed in your profile |
|region            | Home region of the resources being build, i.e. ap-sydney-1|
|remote_region         | Remote region whete the Data Guard will be deployed, i.e. ap-melbourne-1|
|compartment_ocid       | OCID of the compartment where the resources will  be deployed|

> Network

All network variables are using default values, but they can be uncommented and uses to override the default values

|          VARIABLE          |           DESCRIPTION                                                 |
|----------------------------|-----------------------------------------------------------------------|
|home_public_vcn_cidr         | CIDR Block for the `Home` Public `VCN`|
|home_private_vcn_cidr        | CIDR Block for the `Home` Private `VCN`|
|home_public_subnet_cidr      | CIDR Block for the `Home` Public `Subnet` 
|home_private_subnet_cidr     | CIDR Block for the `Home` Private `Subnet`  
|remote_public_vcn_cidr       | CIDR Block for the `Remote` Public `VCN` 
|remote_private_vcn_cidr      | CIDR Block for the `Remote` Private `VCN`
|remote_public_subnet_cidr    | CIDR Block for the `Remote` Public `Subnet` 
|remote_private_subnet_cidr   |  CIDR Block for the `Remote` Private `Subnet` 

> Compute Instances

All compute variables with the exception of `ssh_key` are using default values, but they can be uncommented and uses to override the default values

|          VARIABLE          |           DESCRIPTION                                                 |
|----------------------------|-----------------------------------------------------------------------|
|instance_shape                   | Size of the Compute Instances that will be created, i.e `VM.Standard2.1` <br> Details can be found [here](https://docs.cloud.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm)|
|operating_system                  | The type of Operating System i.e. `Oracle Autonomous Linux`|
|operating_system_version    | The version of the operating system i.e. `7.8`
|ssh_key                      | The public portion of the SSH key that will be used to login into the compute instances. <br>This is different from the API Key

> Database

The only variable you need to fill is db_home_database_admin_password, all others are using default values, you can override by uncommenting and assigning values to the variables.

|          VARIABLE          |           DESCRIPTION                                                 |
|----------------------------|-----------------------------------------------------------------------|
|db_home_database_admin_password                 | Password used to login inside the database |
|database_edition                        | The database version thats is going to be provisioned i.e. `ENTERPRISE_EDITION`<br> **Reminder** that Data Guard is only enabled with Enterprise Edition|
|db_version                   | The version of the database bring created i.e. `19.0.0.0`|
|data_storage_size_in_gb                  | Initial disk space allocated for the database creation|
|node_count| Number of compute nodes used by the database.<br> **Reminder** RAC is only available at VM or Exadata Cloud Services for now|

## Destroy
This setup can be destroyed using `terraform destroy`
```bash

$ terraform destroy

Plan: 0 to add, 0 to change, 47 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```
The first terraform destroy will delete the majority of the resources but it will failed with an error message similar to this:
```bash
$ module.Home.oci_database_data_guard_association.home_data_guard_association: Destroying... [id=ocid1.dgassociation.oc1.ap-sydney-1.abzxsljrn7ntxsxhjl3u45tn5lhfzwjy4xyeq3gu5bsf25jotddivwpzmtxq]

Error: could not delete standby DB System to delete the data guard association: Service error:InvalidParameter. Expected region ap-sydney-1 but found region ap-melbourne-1. http status code: 400. Opc request id: 8d78dd65ba450aa75a7cf0936523d41a/14A9E44C53A78F93269E83A4B7B0D767/72AD0F2BC582BA455E7F491D8BB96B76

```
This is due to terraform not being able to delete a database provisioned in the VM mode. You will have to login in the console or use the CLI to delete the DB System in the remote region. After successful deletion you can run ``terraform destroy`` again to delete the remaining 14 resources.


## Resources

For all the standard values and details of the terraform resources being used you can refer to: https://www.terraform.io/docs/providers/oci/index.html - official OCI Terraform Provider documentation

