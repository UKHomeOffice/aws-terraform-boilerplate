resource "aws_cognito_identity_pool" "anon" {
  allow_unauthenticated_identities = true
  identity_pool_name               = "${var.environment}Anon"
}

resource "aws_cognito_identity_pool_roles_attachment" "anon-roles" {
  identity_pool_id = aws_cognito_identity_pool.anon.id
  roles = {
    "authenticated"   = aws_iam_role.cognito-authenticated.arn
    "unauthenticated" = aws_iam_role.cognito-unauthenticated.arn
  }
}