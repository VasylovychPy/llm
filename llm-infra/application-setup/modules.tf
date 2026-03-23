module "dns" {
  source = "./modules/dns"

  env         = var.env
  domain_name = var.domain_name
  common_tags = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  env              = var.env
  common_tags      = local.common_tags
  vpc_id           = data.aws_vpc.existing.id
  public_subnet_ids = data.aws_subnets.public.ids

  certificate_arn  = module.dns.certificate_arn
  health_check_path = "/"
}

module "bastion" {
  source = "./modules/bastion"

  env         = var.env
  common_tags = local.common_tags
  vpc_id      = data.aws_vpc.existing.id

  public_subnet_id = data.aws_subnets.public.ids[0]
  key_name = aws_key_pair.tech_task.key_name

  ami_id        = var.bastion_ami_id
  instance_type = var.bastion_instance_type
  my_ip_cidr    = var.my_ip_cidr
}

module "asg" {
  source = "./modules/asg"

  env         = var.env
  common_tags = local.common_tags

  vpc_id                 = data.aws_vpc.existing.id
  private_asg_subnet_ids = data.aws_subnets.private_asg.ids

  bastion_security_group_id = module.bastion.bastion_security_group_id
  alb_security_group_id     = module.alb.alb_security_group_id
  target_group_arns         = [module.alb.target_group_arn]

  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  key_name                  = aws_key_pair.tech_task.key_name
  user_data                 = file("${path.module}/user_data.sh")

  desired_capacity = var.asg_desired_capacity
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
}

module "rds" {
  source = "./modules/rds"

  env                    = var.env
  vpc_id                 = data.aws_vpc.existing.id
  private_rds_subnet_ids = data.aws_subnets.private_rds.ids
  asg_security_group_id  = module.asg.asg_security_group_id

  db_username = var.db_username
  db_name     = var.db_name
  common_tags = local.common_tags
}