module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    privSN1_cidr = var.privSN1_cidr
    privSN2_cidr = var.privSN2_cidr
    privSN3_cidr = var.privSN3_cidr
    pubSN1_cidr = var.pubSN1_cidr
    pubSN2_cidr = var.pubSN2_cidr
    pubSN3_cidr = var.pubSN3_cidr
    env = var.env
}