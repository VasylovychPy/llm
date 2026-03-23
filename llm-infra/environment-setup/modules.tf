module "vpc_config" {
  source = "./modules/vpc"

  vpc_id      = data.aws_vpc.existing.id
  env         = var.env
  common_tags = local.common_tags
  subnets     = var.subnets
}
