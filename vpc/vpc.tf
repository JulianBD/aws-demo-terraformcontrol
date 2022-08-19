module "demo-vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v3.14.2"

  name = var.vpc_name # "julianbd-demo-vpc"
  cidr = var.vpc_cidr # "10.0.0.0/24"

  azs            = ["${var.region}a", "${var.region}b"]
  public_subnets = var.public_subnets

  tags = {
    Environment = var.environment
    Contact     = var.contact
  }

  vpc_tags = {
    Name = var.vpc_name
  }
}
