# -------------------------------
# OCI Provider Variables
# -------------------------------
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
  description = "Path to OCI API Private Key"
  type        = string
}

variable "region" {
  description = "OCI Region"
  type        = string
  default     = "ap-mumbai-1"
}

variable "compartment_ocid" {
  description = "OCI Compartment OCID where resources will be created"
  type        = string
}

# -------------------------------
# Networking Variables
# -------------------------------
variable "vcn_cidr" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_domain_index" {
  description = "Index of the availability domain (0,1,2)"
  type        = number
  default     = 0
}

# -------------------------------
# Compute Instance Variables
# -------------------------------
variable "instance_shape" {
  description = "OCI Compute shape"
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "instance_display_name" {
  description = "Display name for the instance"
  type        = string
  default     = "sre-lab-instance"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key for instance access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# -------------------------------
# Optional Tags
# -------------------------------
variable "defined_tags" {
  description = "Defined tags for resources"
  type        = map(string)
  default     = {}
}

variable "freeform_tags" {
  description = "Freeform tags for resources"
  type        = map(string)
  default     = {}
}
