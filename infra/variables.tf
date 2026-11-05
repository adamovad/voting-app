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

variable "vpc_cidr" {
  description = "Address range of the VPC, for example 10.10.0.0/16"
  type        = string
}

variable "image_tag" {
  description = "Tag of the images to run, for example v1 or a git commit"
  type        = string
}

variable "desired_count" {
  description = "Number of tasks per service"
  type        = number
}

variable "option_a" {
  description = "First option on the vote page"
  type        = string
  default     = "ביבי"
}

variable "option_b" {
  description = "Second option on the vote page"
  type        = string
  default     = "אייזנקוט"
}