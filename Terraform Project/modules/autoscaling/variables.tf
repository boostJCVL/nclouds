variable "min" {
  type = number
  description = "set a minimum number for the auto scaling group here"
}

variable "max" {
  type = number
  description = "set the maximum number for the auto scaling group here"
}

variable "desired" {
  type = number
  description = "set the desired number for the auto scaling group here"
}

variable "vpc" {
  type = string
}

variable "subnets" {
    type = list(string)
}

variable "target_group" {
    type = string
}

variable "elb" {
    type = string
}

variable "efs_dns" {
    type = string
}