module "vpc" {
    source = "./modules/vpc" #How to define where resources are referenced
    vpc_cidr = var.vpc_cidr
    env = var.env
}
#terraform apply -var-file=./config/vars.tfvars

