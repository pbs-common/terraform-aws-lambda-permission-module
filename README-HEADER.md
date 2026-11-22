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
