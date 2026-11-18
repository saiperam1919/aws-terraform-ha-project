module "vpc" {
  source = "./modules/vpc"
}
module "security_groups" {

  source = "./modules/security-groups"

  vpc_id = module.vpc.vpc_id
}
module "bastion" {

  source = "./modules/bastion"

  public_subnet_id = module.vpc.public_subnet1_id

  bastion_sg_id = module.security_groups.bastion_sg_id
}
module "asg" {

  source = "./modules/asg"

  private_subnet1_id = module.vpc.private_subnet1_id
  private_subnet2_id = module.vpc.private_subnet2_id

  app_sg_id = module.security_groups.app_sg_id

  target_group_arn = module.alb.target_group_arn
}
module "alb" {

  source = "./modules/alb"

  vpc_id = module.vpc.vpc_id

  public_subnet1_id = module.vpc.public_subnet1_id
  public_subnet2_id = module.vpc.public_subnet2_id

  alb_sg_id = module.security_groups.alb_sg_id
}