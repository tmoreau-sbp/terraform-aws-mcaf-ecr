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
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repository\_names | list of repository names, names can include namespaces: prefixes ending with a slash (/) | `list(string)` | n/a | yes |
| additional\_ecr\_policy\_statements | Map of additional ecr repository policy statements | <pre>map(object({<br>    effect = string<br>    principal = object({<br>      type        = string<br>      identifiers = list(string)<br>    })<br>    actions = list(string)<br>  }))</pre> | `null` | no |
| enable\_lifecycle\_policy | Set to false to prevent the module from adding any lifecycle policies to any repositories | `bool` | `true` | no |
| image\_tag\_mutability | The tag mutability setting for the repository. Must be: `MUTABLE` or `IMMUTABLE` | `string` | `"IMMUTABLE"` | no |
| kms\_key\_arn | The KMS key ARN used for the repository encryption | `string` | `null` | no |
| principals\_readonly\_access | Principal ARNs to provide with readonly access to the ECR | `list(string)` | `[]` | no |
| scan\_images\_on\_push | Indicates if images are automatically scanned after being pushed to the repository | `bool` | `true` | no |
| tags | Mapping of tags | `map(string)` | `{}` | no |

## Outputs

No output.

<!-- END_TF_DOCS -->
