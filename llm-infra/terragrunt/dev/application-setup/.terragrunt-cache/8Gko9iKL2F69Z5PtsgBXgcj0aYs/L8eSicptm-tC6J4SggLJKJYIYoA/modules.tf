module "web" {
  source = "./modules/web"

  env        = var.env
  vpc_id     = data.aws_vpc.existing.id
  public_subnet_id = data.aws_subnets.public.ids[0]

  monitoring_web_ami_id = var.web_ami_id
  web_instance_type = var.web_instance_type
  key_name      = aws_key_pair.tech_task.key_name
  vpc_cidr   = data.aws_vpc.existing.cidr_block

  my_ip_cidr = var.my_ip_cidr

  llm_alb_dns = module.alb.alb_dns_name

  db_endpoint = module.rds.db_endpoint
  db_port     = module.rds.db_port
  db_name     = module.rds.db_name
  db_username = module.rds.db_username
  db_password = var.db_password

  bastion_security_group_id = module.bastion.bastion_security_group_id

  common_tags = local.common_tags
}

module "dns" {
  source = "./modules/dns"

  env         = var.env
  vpc_id      = data.aws_vpc.existing.id
  domain_name = var.domain_name
  web_public_ip  = module.web.web_public_ip
  common_tags = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  env              = var.env
  common_tags      = local.common_tags
  vpc_id           = data.aws_vpc.existing.id
  private_subnet_ids = data.aws_subnets.private_asg.ids
  web_security_group_id = module.web.web_security_group_id

  health_check_path = "/api/tags"
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


  desired_capacity = var.asg_desired_capacity
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
}

module "rds" {
  source = "./modules/rds"

  env                    = var.env
  vpc_id                 = data.aws_vpc.existing.id
  private_rds_subnet_ids = data.aws_subnets.private_rds.ids
  web_security_group_id  = module.web.web_security_group_id

  db_username = var.db_username
  db_name     = var.db_name
  db_password = var.db_password
  common_tags = local.common_tags

}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  env = var.env

  rds_instance_identifier = module.rds.rds_instance_identifier
  alb_arn_suffix  = module.alb.alb_arn_suffix

  sns_email = var.sns_email

  common_tags = local.common_tags

}