resource "aws_cognito_identity_pool" "pool" {
  identity_pool_name               = var.name
  allow_unauthenticated_identities = false

  dynamic "cognito_identity_providers" {
    for_each = { for p in var.clients : p.client_id => p }
    iterator = client

    content {
      client_id               = client.value.client_id
      provider_name           = client.value.name
      server_side_token_check = false
    }
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "client_identity" {
  identity_pool_id = aws_cognito_identity_pool.pool.id

  roles = {
    "authenticated"   = aws_iam_role.authenticated.arn
    "unauthenticated" = aws_iam_role.unauthenticated.arn
  }

  depends_on = [
    aws_iam_role_policy.unauthenticated,
    aws_iam_role_policy.authenticated
  ]
}
