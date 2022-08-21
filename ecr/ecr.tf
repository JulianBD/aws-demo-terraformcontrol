module "test_repositories" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecr.git?ref=v1.4.0"

  count = var.num_repositories

  repository_name = "testimage${count.index + 1}"

  attach_repository_policy = false
  create_lifecycle_policy  = false
  create_registry_policy   = false

  tags = {
    Environment = var.environment
    Contact     = var.contact
  }
}
