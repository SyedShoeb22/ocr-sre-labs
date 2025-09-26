provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# Fetch availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Fetch Oracle Linux 9 images (primary)
data "oci_core_images" "oracle_linux_9" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# Fetch Oracle Linux 8 images (fallback)
data "oci_core_images" "oracle_linux_8" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# Safe local variable to pick the first available image
locals {
  image_id = length(data.oci_core_images.oracle_linux_9.images) > 0 ?
             data.oci_core_images.oracle_linux_9.images[0].id :
             length(data.oci_core_images.oracle_linux_8.images) > 0 ?
             data.oci_core_images.oracle_linux_8.images[0].id :
             ""  # fail-safe empty string if none exists
}

# VCN + Subnet
resource "oci_core_vcn" "sre_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "sre-vcn"
}

resource "oci_core_subnet" "sre_subnet" {
  cidr_block     = "10.0.1.0/24"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.sre_vcn.id
  display_name   = "sre-subnet"
}

# Compute instance
resource "oci_core_instance" "sre_instance" {
  count               = local.image_id != "" ? 1 : 0   # only create if image exists
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id = oci_core_subnet.sre_subnet.id
  }

  source_details {
    source_type = "image"
    source_id   = local.image_id
  }

  display_name = "sre-instance"
}

output "instance_public_ip" {
  value = oci_core_instance.sre_instance[0].public_ip
  description = "Public IP of the SRE instance"
  condition   = length(oci_core_instance.sre_instance) > 0
}
