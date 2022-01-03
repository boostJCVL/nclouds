variable "vpc_cidr" {
    type = string
    description = "set the value for the CIDR for your VPC here"
}


variable "env" {
    type = string
    description = "set the environment name here"
}


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