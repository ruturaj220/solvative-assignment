output "s3_static_website_url" {
  value = aws_s3_bucket.static_website.website_endpoint
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "dynamodb_table" {
  value = aws_dynamodb_table.users.name
}
