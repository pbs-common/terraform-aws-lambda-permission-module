# Native tests: plan-only against a mocked provider, so they need no AWS
# credentials. The terratest suite beside this file deploys examples/ to AWS.

mock_provider "aws" {}

variables {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "example-function"
  principal     = "sns.amazonaws.com"
  source_arn    = "arn:aws:sns:us-east-1:123456789012:example-topic"
}

run "accepts_a_service_principal_with_a_source_arn" {
  command = plan

  assert {
    condition     = aws_lambda_permission.lambda_permission.principal == "sns.amazonaws.com"
    error_message = "The service principal was not passed to aws_lambda_permission."
  }

  assert {
    condition     = aws_lambda_permission.lambda_permission.source_arn == var.source_arn
    error_message = "source_arn was not passed to aws_lambda_permission."
  }
}

run "accepts_a_service_principal_with_only_a_source_account" {
  command = plan

  variables {
    principal      = "s3.amazonaws.com"
    source_arn     = null
    source_account = "123456789012"
  }

  assert {
    condition     = aws_lambda_permission.lambda_permission.source_account == "123456789012"
    error_message = "source_account was not passed to aws_lambda_permission."
  }
}

run "accepts_an_account_principal_without_a_source" {
  command = plan

  variables {
    principal  = "123456789012"
    source_arn = null
  }

  assert {
    condition     = aws_lambda_permission.lambda_permission.principal == "123456789012"
    error_message = "The account principal was not passed to aws_lambda_permission."
  }
}

run "refuses_the_public_principal" {
  command = plan

  variables {
    principal = "*"
  }

  expect_failures = [var.principal]
}

run "refuses_a_star_wildcard_inside_a_principal" {
  command = plan

  variables {
    principal = "arn:aws:iam::123456789012:role/*"
  }

  expect_failures = [var.principal]
}

run "refuses_a_question_mark_wildcard_inside_a_principal" {
  command = plan

  variables {
    principal = "arn:aws:iam::123456789012:role/app?"
  }

  expect_failures = [var.principal]
}

run "refuses_a_service_principal_with_no_source" {
  command = plan

  variables {
    source_arn = null
  }

  expect_failures = [var.principal]
}

run "refuses_a_service_principal_with_an_empty_source_arn" {
  command = plan

  variables {
    source_arn = ""
  }

  expect_failures = [var.principal]
}

run "refuses_an_upper_case_service_principal_with_no_source" {
  command = plan

  variables {
    principal  = "SNS.AMAZONAWS.COM"
    source_arn = null
  }

  expect_failures = [var.principal]
}

run "refuses_a_service_principal_whose_source_arn_names_no_account" {
  command = plan

  variables {
    principal  = "s3.amazonaws.com"
    source_arn = "arn:aws:s3:::example-bucket"
  }

  expect_failures = [var.principal]
}

run "accepts_a_service_principal_whose_account_less_source_arn_has_a_source_account" {
  command = plan

  variables {
    principal      = "s3.amazonaws.com"
    source_arn     = "arn:aws:s3:::example-bucket"
    source_account = "123456789012"
  }

  assert {
    condition     = aws_lambda_permission.lambda_permission.source_arn == "arn:aws:s3:::example-bucket"
    error_message = "source_arn was not passed to aws_lambda_permission."
  }
}

run "never_sets_a_function_url_auth_type" {
  command = plan

  assert {
    condition     = aws_lambda_permission.lambda_permission.function_url_auth_type == null
    error_message = "The module set function_url_auth_type; NONE makes a function URL public, so the module must not pass one."
  }
}

run "refuses_a_source_account_that_is_not_an_account_id" {
  command = plan

  variables {
    source_account = "12345"
  }

  expect_failures = [var.source_account]
}
