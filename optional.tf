variable "source_account" {
  description = "(optional) ID of the AWS account that owns the source resource. Required for a service principal whose source_arn names no account, such as an S3 bucket."
  default     = null
  type        = string

  validation {
    condition     = var.source_account == null || can(regex("^[0-9]{12}$", var.source_account))
    error_message = "source_account must be null or a 12-digit AWS account ID."
  }
}
