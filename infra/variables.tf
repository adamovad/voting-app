variable "env" {
  description = "Environment name: dev or prod"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "env must be dev or prod."
  }
}

variable "name_prefix" {
  description = "Prefix for every name. Lowercase letters, digits and hyphens, up to 12 characters"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,12}$", var.name_prefix))
    error_message = "name_prefix: lowercase letters, digits and hyphens, up to 12 characters."
  }
}