variable "name" {
  description = "Full name of the service, for example adam-dev-vote"
  type        = string
}

variable "image" {
  description = "Full image address with tag"
  type        = string
}

variable "cluster_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "execution_role_arn" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "environment" {
  description = "Plain environment variables of the container"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secret environment variables: name => secret ARN"
  type        = map(string)
  default     = {}
}

variable "container_port" {
  description = "Port of the container. null for a service without a port, like worker"
  type        = number
  default     = null
}

variable "target_group_arn" {
  description = "Target group of the load balancer. null for a service without one"
  type        = string
  default     = null
}