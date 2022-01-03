module "vpc" {
    source = "./modules/vpc" #How to define where resources are referenced
    vpc_cidr = var.vpc_cidr
    env = var.env
}
#terraform apply -var-file=./config/vars.tfvars

module "efs" {
    source = "./modules/efs"
    subnets = module.vpc.priv_subnets
    security_group = [module.autoscaling.security_group]
}

module "autoscaling" {
    source = "./modules/autoscaling"
    depends_on = [
      module.loadbalancer
    ]
    min = var.min 
    max = var.max 
    desired = var.desired 
    vpc = module.vpc.vpc_id 
    subnets = module.vpc.priv_subnets
    target_group = module.loadbalancer.target_group_arn
    elb = module.loadbalancer.elb
    efs_dns = module.efs.efs_dns
    
}

module "loadbalancer" {
    source = "./modules/loadbalancer"
    vpc = module.vpc.vpc_id
    subnets = module.vpc.pub_subnets
}

module "route53" {
    source = "./modules/route53"
    depends_on = [
      module.loadbalancer
    ]
    elb_dns_name = module.loadbalancer.elb_dns_name
}