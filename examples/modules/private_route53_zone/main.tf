locals {
  description = "Private zone for ${var.name}"
  managed_by  = "terraform"
}

resource "aws_route53_zone" "main" {
  name = var.name

  vpc {
    vpc_id = var.main_vpc
  }

  comment       = local.description
  force_destroy = var.force_destroy

  tags = {
    "Name"          = var.name
    "Environment"   = var.environment
    "Description"   = local.description
    "ManagedBy"     = local.managed_by
  }

  lifecycle {
    ignore_changes = [vpc]
  }

}

resource "aws_route53_zone_association" "secondary" {
  count   = length(var.secondary_vpcs)
  zone_id = aws_route53_zone.main.zone_id
  vpc_id  = var.secondary_vpcs[count.index]
}