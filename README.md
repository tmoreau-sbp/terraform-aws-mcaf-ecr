# terraform-aws-mcaf-ecr

Terraform module to setup and manage AWS Elastic Container Registry (ECR) repositories.

## Usage

```hcl
module "ecr" {
  source           = "github.com/schubergphilis/terraform-aws-mcaf-ecr"
  repository_names = ["image-x", "namespace/image-y"]
}
```

```hcl
module "ecr" {
  source           = "github.com/schubergphilis/terraform-aws-mcaf-ecr"
  repository_names = ["image-x", "namespace/image-y"]

  additional_ecr_policy_statements = {
    lambda = {
      effect = "Allow"

      principal = { 
        type        = "service"
        identifiers = ["lambda.amazonaws.com"]
      }

      actions = [
        "ecr:BatchGetImage",
        "ecr:DeleteRepositoryPolicy",
        "ecr:GetDownloadUrlForLayerecr:GetRepositoryPolicy",
        "ecr:SetRepositoryPolicy"
      ]
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_repository_names"></a> [repository\_names](#input\_repository\_names) | list of repository names, names can include namespaces: prefixes ending with a slash (/) | `list(string)` | n/a | yes |
| <a name="input_additional_ecr_policy_statements"></a> [additional\_ecr\_policy\_statements](#input\_additional\_ecr\_policy\_statements) | Map of additional ecr repository policy statements | <pre>map(object({<br>    effect = string<br>    principal = object({<br>      type        = string<br>      identifiers = list(string)<br>    })<br>    actions = list(string)<br>  }))</pre> | `null` | no |
| <a name="input_enable_lifecycle_policy"></a> [enable\_lifecycle\_policy](#input\_enable\_lifecycle\_policy) | Set to false to prevent the module from adding any lifecycle policies to any repositories | `bool` | `true` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | The tag mutability setting for the repository. Must be: `MUTABLE` or `IMMUTABLE` | `string` | `"IMMUTABLE"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The KMS key ARN used for the repository encryption | `string` | `null` | no |
| <a name="input_principals_readonly_access"></a> [principals\_readonly\_access](#input\_principals\_readonly\_access) | Principal ARNs to provide with readonly access to the ECR | `list(string)` | `[]` | no |
| <a name="input_repository_tags"></a> [repository\_tags](#input\_repository\_tags) | Mapping of tags for a repository using repository name as key | `map(map(string))` | `{}` | no |
| <a name="input_scan_images_on_push"></a> [scan\_images\_on\_push](#input\_scan\_images\_on\_push) | Indicates if images are automatically scanned after being pushed to the repository | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Mapping of tags | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
