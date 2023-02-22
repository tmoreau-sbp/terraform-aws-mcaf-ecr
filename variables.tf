variable "additional_ecr_policy_statements" {
  type = map(object({
    effect = string
    principal = object({
      type        = string
      identifiers = list(string)
    })
    actions = list(string)
  }))
  description = "Map of additional ecr repository policy statements"
  default     = null
}

variable "enable_lifecycle_policy" {
  type        = bool
  description = "Set to false to prevent the module from adding any lifecycle policies to any repositories"
  default     = true
}

variable "image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "The tag mutability setting for the repository. Must be: `MUTABLE` or `IMMUTABLE`"
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "The KMS key ARN used for the repository encryption"
}

variable "principals_readonly_access" {
  type        = list(string)
  default     = []
  description = "Principal ARNs to provide with readonly access to the ECR"
}

variable "repository_names" {
  type        = list(string)
  description = "list of repository names, names can include namespaces: prefixes ending with a slash (/)"
}

variable "repository_tags" {
  type        = map(map(string))
  default     = {}
  description = "Mapping of tags for a repository using repository name as key"
}

variable "scan_images_on_push" {
  type        = bool
  default     = true
  description = "Indicates if images are automatically scanned after being pushed to the repository"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Mapping of tags"
}
