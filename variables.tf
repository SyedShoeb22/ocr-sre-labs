variable "tenancy_ocid" {
  description = "OCI Tenancy OCID"
  type        = string
}

variable "user_ocid" {
  description = "OCI User OCID"
  type        = string
}

variable "fingerprint" {
  description = "OCI API Key Fingerprint"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private API key"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
}

variable "compartment_ocid" {
  description = "Target compartment OCID"
  type        = string
}
