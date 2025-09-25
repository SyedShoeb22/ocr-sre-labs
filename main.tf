provider "oci" {
  region = "ap-mumbai-1"
}

resource "oci_core_vcn" "vcn1" {
  cidr_block     = "10.0.0.0/16"
  display_name   = "sre-vcn"
  compartment_id = var.compartment_ocid
}

resource "oci_core_subnet" "subnet1" {
  vcn_id         = oci_core_vcn.vcn1.id
  cidr_block     = "10.0.1.0/24"
  compartment_id = var.compartment_ocid
}

resource "oci_core_instance" "sre_instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.E2.1.Micro"
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux.id
  }
  create_vnic_details {
    subnet_id = oci_core_subnet.subnet1.id
  }
  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
  }
}
