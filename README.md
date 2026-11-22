# PBS TF Lambda Permission Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-lambda-permission-module?ref=x.y.z
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

Grants a Lambda function to be invoked by a specific service.

The module refuses grants that would let an unintended caller invoke the function; the `principal` and `source_account` validations hold the rules:

- `principal` must not contain a wildcard, so the module cannot grant public invoke access (Security Hub Lambda.1).
- A service principal (`*.amazonaws.com`) must name the account that owns its source, through `source_account` or a `source_arn` with an account ID in it. An S3 bucket ARN has no account ID, so an S3 grant also needs `source_account`. See [the confused deputy problem](https://docs.aws.amazon.com/IAM/latest/UserGuide/confused-deputy.html).
- The module never sets `function_url_auth_type`, so it cannot grant `NONE` (a public function URL).

Integrate this module like so:

```hcl
module "lambda_permission" {
  source = "github.com/pbs/terraform-aws-lambda-permission-module?ref=x.y.z"

  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.name
  principal     = "sns.amazonaws.com"
  source_arn    = module.topic.arn
}
```

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`x.y.z`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.71.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lambda_permission.lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action"></a> [action](#input\_action) | Action for the Lambda Permission | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Function Name for the Lambda Permission | `string` | n/a | yes |
| <a name="input_principal"></a> [principal](#input\_principal) | Principal for the Lambda Permission: an AWS service (e.g. sns.amazonaws.com), an AWS account ID or an IAM principal ARN. Wildcards are refused, and a service principal must name the account that owns its source (see the validations). | `string` | n/a | yes |
| <a name="input_source_arn"></a> [source\_arn](#input\_source\_arn) | Source ARN for the Lambda Permission | `string` | n/a | yes |
| <a name="input_statement_id"></a> [statement\_id](#input\_statement\_id) | Statement ID for the Lambda Permission | `string` | n/a | yes |
| <a name="input_source_account"></a> [source\_account](#input\_source\_account) | (optional) ID of the AWS account that owns the source resource. Required for a service principal whose source\_arn names no account, such as an S3 bucket. | `string` | `null` | no |

## Outputs

No outputs.
