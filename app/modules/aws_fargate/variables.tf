variable "env" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = ""
}

variable "project_name" {
  type    = string
  default = ""
}

variable "container_port" {
  type    = number
  default = 80
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "container_vcpu" {
  type    = number
  default = 256
}

variable "container_memory" {
  type    = number
  default = 512
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_id_1" {
  type    = string
  default = ""
}

variable "subnet_id_2" {
  type    = string
  default = ""
}

variable "aws_account_id" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ecs_role_arn" {
  type    = string
  default = ""
}

variable "target_group_arn" {
  type    = string
  default = ""
}

variable "sg_alb" {
  type    = string
  default = ""
}

variable "cluster_arn" {
  type    = string
  default = ""
}

variable "host_headers" {
  type    = string
  default = ""
}

variable "alb_dns_name" {
  default = ""
}

