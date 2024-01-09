variable "alb" {
  default = true
}

variable "alb_http_listener" {
  default = true
}

variable "alb_sg_allow_test_listener" {
  default = true
}

variable "alb_sg_allow_egress_https_world" {
  default = true
}

variable "alb_only" {
  default = false
}

variable "alb_ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
  type    = string
}

variable "alb_internal_ssl_policy" {
  default = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  type    = string
}

variable "alb_drop_invalid_header_fields" {
  default = true
  type    = bool
}

variable "lb_access_logs_bucket" {
  type    = string
  default = ""
}

variable "lb_access_logs_prefix" {
  type    = string
  default = ""
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

variable "project_name" {
  type    = string
  default = ""
}

variable "env" {
  type    = string
  default = ""
}

variable "alb_internal" {
  type    = bool
  default = false
}

variable "certificate_arn" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "priority_listener_rule" {
}

variable "domain_name" {
}