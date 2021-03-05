resource "aws_secretsmanager_secret" "sendgrid_api_key" {
  name                    = "/${var.tags.Service}/${var.tags.Environment}/SENDGRID_API_KEY"
  description             = "SENDGRID_API_KEY to send emails"
  recovery_window_in_days = 0 // change to 30 when development is finished 
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "sendgrid_api_key" {
  secret_id     = aws_secretsmanager_secret.sendgrid_api_key.id
  secret_string = <<EOF
{
  "sendgrid_api_key": "pendding to add the key"
}
EOF
}

