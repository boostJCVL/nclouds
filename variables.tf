variable "vpc_cidr" {
    type = string
    description = "set the value for the CIDR for your VPC here"
}

variable "privSN1_cidr" {
    type = string
    description = "set the CIDR value for privSN1 here"
}

variable "privSN2_cidr" {
    type = string
    description = "set the CIDR value for privSN2 here"
}

variable "privSN3_cidr" {
    type = string
    description = "set the CIDR value for privSN3 here" 
}

variable "pubSN1_cidr" {
    type = string
    description = "set the CIDR value for pubSN1 here"
}

variable "pubSN2_cidr" {
    type = string
    description = "set the CIDR value for pubSN2 here"
}

variable "pubSN3_cidr" {
    type = string
    description = "set the CIDR value for pubSN3 here"
}

variable "env" {
    type = string
    description = "set the environment name here"
}