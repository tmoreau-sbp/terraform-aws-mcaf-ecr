locals {
  ecr_policies = merge(local.readonly_ecr_policy, var.additional_ecr_policy_statements)

  policy_rule_untagged_image = [{
    rulePriority = 1
    description  = "Remove untagged images"
    selection = {
      tagStatus   = "untagged"
      countType   = "imageCountMoreThan"
      countNumber = 1
    }
    action = {
      type = "expire"
    }
  }]

  readonly_ecr_policy = length(var.principals_readonly_access) > 0 ? {
    "ReadonlyAccess" = {
      effect = "Allow"
      principal = {
        type        = "AWS"
        identifiers = [for k in var.principals_readonly_access : "arn:aws:iam::${k}:root"]
      }
      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:DescribeImageScanFindings",
        "ecr:DescribeRepositories",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetRepositoryPolicy",
        "ecr:ListImages",
        "ecr:ListTagsForResource"
      ]
    }
  } : null
}

resource "aws_ecr_repository" "default" {
  for_each             = toset(var.repository_names)
  name                 = each.value
  image_tag_mutability = var.image_tag_mutability
  tags                 = var.tags

  encryption_configuration {
    kms_key         = var.kms_key_arn
    encryption_type = var.kms_key_arn != null ? "KMS" : "AES256"
  }

  image_scanning_configuration {
    scan_on_push = var.scan_images_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "default" {
  for_each   = toset(var.enable_lifecycle_policy ? var.repository_names : [])
  repository = aws_ecr_repository.default[each.value].name

  policy = jsonencode({
    rules = local.policy_rule_untagged_image
  })
}

data "aws_iam_policy_document" "default" {
  count = local.ecr_policies != null ? 1 : 0

  dynamic "statement" {
    for_each = local.ecr_policies
    content {
      sid = statement.key
      principals {
        type        = title(statement.value.principal.type)
        identifiers = statement.value.principal.identifiers
      }
      actions = statement.value.actions
      effect  = title(statement.value.effect)
    }
  }
}

resource "aws_ecr_repository_policy" "default" {
  for_each   = toset(local.ecr_policies != null ? var.repository_names : [])
  repository = aws_ecr_repository.default[each.value].name
  policy     = join("", data.aws_iam_policy_document.default.*.json)
}
