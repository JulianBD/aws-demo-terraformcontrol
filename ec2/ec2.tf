module "demo_security_group_ssh" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//modules/ssh?ref=v4.12.0"

  name        = "demo-sg-ssh"
  description = "Demonstration security group allowing port 22"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = [var.ingress_cidr_block]

  tags = {
    Environment = var.environment
    Contact     = var.contact
  }
}

module "demo_security_group_http" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//modules/http-80?ref=v4.12.0"

  name        = "demo-sg-http"
  description = "Demonstration security group allowing port 80"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = [var.ingress_cidr_block]

  tags = {
    Environment = var.environment
    Contact     = var.contact
  }

}

module "demo_keypair" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-key-pair.git?ref=v2.0.0"

  key_name   = "demo-keypair"
  public_key = var.keypair

  tags = {
    Environment = var.environment
    Contact     = var.contact
  }
}
