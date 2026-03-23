module "vpc" {
    source = "./modules/vpc"
    common_tags = local.common_tags
}
