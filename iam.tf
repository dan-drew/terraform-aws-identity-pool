data "aws_iam_policy_document" "assume_role_authenticated" {
  statement {
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.pool.id]
      test     = "StringEquals"
    }
    condition {
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
      test     = "ForAnyValue:StringLike"
    }
  }
}

data "aws_iam_policy_document" "assume_role_unauthenticated" {
  statement {
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.pool.id]
      test     = "StringEquals"
    }
    condition {
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["unauthenticated"]
      test     = "ForAnyValue:StringLike"
    }
  }
}

data "aws_iam_policy_document" "unauthenticated" {
  source_policy_documents = [var.unauthenticated_policy.json]

  statement {
    sid = "identityPool"
    actions = [
      "cognito-sync:*",
      "cognito-identity:*"
    ]
    resources = [aws_cognito_identity_pool.pool.arn]
  }
}

data "aws_iam_policy_document" "authenticated" {
  source_policy_documents = [var.authenticated_policy.json]

  statement {
    sid = "identityPool"
    actions = [
      "cognito-sync:*",
      "cognito-identity:*"
    ]
    resources = [aws_cognito_identity_pool.pool.arn]
  }
}

resource "aws_iam_role" "unauthenticated" {
  name               = "${var.name}-unauthenticated"
  assume_role_policy = data.aws_iam_policy_document.assume_role_unauthenticated.json
}

resource "aws_iam_role_policy" "unauthenticated" {
  role   = aws_iam_role.unauthenticated.name
  name   = aws_iam_role.unauthenticated.name
  policy = data.aws_iam_policy_document.unauthenticated.json
}

resource "aws_iam_role" "authenticated" {
  name               = "${var.name}-authenticated"
  assume_role_policy = data.aws_iam_policy_document.assume_role_authenticated.json
}

resource "aws_iam_role_policy" "authenticated" {
  role   = aws_iam_role.authenticated.name
  name   = aws_iam_role.authenticated.name
  policy = data.aws_iam_policy_document.authenticated.json
}

