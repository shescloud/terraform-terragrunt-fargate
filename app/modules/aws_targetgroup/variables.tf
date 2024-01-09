variable "project_name" {
}

variable "env" {
}

variable "certificate_arn" {
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
}

variable "subnet_id_1" {
}

variable "subnet_id_2" {
}

variable "listener_ssl_arn" {
}

variable "priority_listener_rule" {
}

variable "host_headers" {
}

variable "health_check_path" {
}

variable "container_port" {
}