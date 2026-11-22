variable "statement_id" {
  description = "Statement ID for the Lambda Permission"
  type        = string
}

variable "action" {
  description = "Action for the Lambda Permission"
  type        = string
}

variable "function_name" {
  description = "Function Name for the Lambda Permission"
  type        = string
}

variable "principal" {
  description = "Principal for the Lambda Permission: an AWS service (e.g. sns.amazonaws.com), an AWS account ID or an IAM principal ARN. Wildcards are refused, and a service principal must name the account that owns its source (see the validations)."
  type        = string

  validation {
    condition     = !can(regex("[*?]", var.principal))
    error_message = "No public principal: principal must not contain a wildcard (* or ?), because a wildcard principal lets anyone invoke the function (Security Hub Lambda.1)."
  }

  validation {
    condition     = !endswith(lower(var.principal), ".amazonaws.com") || var.source_account != null || can(regex("^arn:[^:]+:[^:]+:[^:]*:[0-9]{12}:", var.source_arn))
    error_message = "No confused deputy: a service principal (*.amazonaws.com) needs source_account, or a source_arn whose account field is a 12-digit account ID, so that no other account's resource can invoke the function through that service."
  }
}

variable "source_arn" {
  description = "Source ARN for the Lambda Permission"
  type        = string
}
