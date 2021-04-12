# terraform-aws-mcaf-ecr
Terraform module to setup and manage AWS Elastic Container Registry (ECR) repositories.

Example:

```hcl
module "ecr" {
  source           = "git@github.com:schubergphilis/terraform-aws-mcaf-ecr.git"
  repository_names = ["image-x", "namespace/image-y"]
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repository\_names | list of repository names, names can include namespaces: prefixes ending with a slash (/) | `list(string)` | n/a | yes |
| enable\_lifecycle\_policy | Set to false to prevent the module from adding any lifecycle policies to any repositories | `bool` | `true` | no |
| image\_tag\_mutability | The tag mutability setting for the repository. Must be: `MUTABLE` or `IMMUTABLE` | `string` | `"IMMUTABLE"` | no |
| max\_image\_days | Expire images older than the given number of days | `number` | `365` | no |
| principals\_readonly\_access | Principal ARNs to provide with readonly access to the ECR | `list(string)` | `[]` | no |
| scan\_images\_on\_push | Indicates if images are automatically scanned after being pushed to the repository | `bool` | `true` | no |
| tags | Mapping of tags | `map(string)` | `{}` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->
