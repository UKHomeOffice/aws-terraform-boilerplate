/*
Every role has two types of policy.  A trust relationship which is the assume role
and a set of permisions the role has.
*/

// Lambda role

resource "aws_iam_role" "lambda-role" {
  assume_role_policy   = data.aws_iam_policy_document.lambda-assume-role-policy.json
  max_session_duration = 3600
  name                 = "${var.environment}-ho-lambda-role"
  path                 = "/"
}

data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    actions = [
    "sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
      "lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "lambda-role-policy" {
  name   = "${var.environment}-ho-lambda-role-policy"
  policy = data.aws_iam_policy_document.lambda-role-policy.json
  role   = aws_iam_role.lambda-role.id
}

data "aws_iam_policy_document" "lambda-role-policy" {
  statement {
    actions = [
      "logs:*",
      "sqs:*",
      "s3:*",
      "sns:*",
      "dynamodb:*",
      "iam:*",
      "lambda:*"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}


data "aws_iam_policy_document" "r-assume-role-policy" {
  statement {
    actions = [
    "sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
      "r.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "r-role-policy" {
  name   = "${var.environment}-ho-role-policy"
  policy = data.aws_iam_policy_document.aaa-role-policy.json
  role   = aws_iam_role.r-role.id
}

data "aws_iam_policy_document" "r-role-policy" {
  statement {
    actions = [
      "sqs:*",
      "sns:*"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = [
    "sns:Publish"]
    resources = [aws_sns_topic.search-ready.arn]
    effect    = "Allow"
  }
}

// Cognito roles

resource "aws_iam_role" "cognito-authenticated" {
  assume_role_policy   = data.aws_iam_policy_document.cognito-authenticated-assume-role-policy.json
  max_session_duration = 3600
  name                 = "${var.environment}-ho-pods-pr-cognito-auth-role"
  path                 = "/"
}

data "aws_iam_policy_document" "cognito-authenticated-assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    condition {
      test     = "ForAnyValue:StringLike"
      values   = ["authenticated"]
      variable = "cognito-identity.amazonaws.com:amr"
    }
    condition {
      test     = "StringEquals"
      values   = [aws_cognito_identity_pool.anon.id]
      variable = "cognito-identity.amazonaws.com:aud"
    }
    effect = "Allow"
    principals {
      identifiers = ["cognito-identity.amazonaws.com"]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role_policy" "cognito-authenticated-role-policy" {
  name   = "${var.environment}-ho-pods-pr-cognito-auth-role-policy"
  policy = data.aws_iam_policy_document.cognito-authenticated-role-policy.json
  role   = aws_iam_role.cognito-authenticated.id
}

data "aws_iam_policy_document" "cognito-authenticated-role-policy" {
  statement {
    actions = [
    "s3:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role" "cognito-unauthenticated" {
  assume_role_policy   = data.aws_iam_policy_document.cognito-unauthenticated-assume-role-policy.json
  max_session_duration = 3600
  name                 = "${var.environment}-ho-pods-pr-cognito-unauth-role"
  path                 = "/"
}

data "aws_iam_policy_document" "cognito-unauthenticated-assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    condition {
      test     = "ForAnyValue:StringLike"
      values   = ["unauthenticated"]
      variable = "cognito-identity.amazonaws.com:amr"
    }
    condition {
      test     = "StringEquals"
      values   = [aws_cognito_identity_pool.anon_search.id]
      variable = "cognito-identity.amazonaws.com:aud"
    }
    effect = "Allow"
    principals {
      identifiers = ["cognito-identity.amazonaws.com"]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role_policy" "cognito-unauthenticated-role-policy" {
  name   = "${var.environment}-ho-pods-pr-cognito-unauth-role-policy"
  policy = data.aws_iam_policy_document.cognito-unauthenticated-role-policy.json
  role   = aws_iam_role.cognito-unauthenticated.id
}

data "aws_iam_policy_document" "cognito-unauthenticated-role-policy" {
  statement {
    actions = [
      "s3:*",
      "apigateway:*",
      "cognito-sync:*"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}
