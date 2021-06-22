locals {
  ecr_need_policy = length(var.principals_readonly_access) > 0 ? true : false
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
  count = local.ecr_need_policy ? 1 : 0

  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.principals_readonly_access
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
}

resource "aws_ecr_repository_policy" "default" {
  for_each   = toset(local.ecr_need_policy ? var.repository_names : [])
  repository = aws_ecr_repository.default[each.value].name
  policy     = join("", data.aws_iam_policy_document.default.*.json)
}
