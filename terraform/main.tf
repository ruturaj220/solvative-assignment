# S3 Buckets
resource "aws_s3_bucket" "static_website" {
  bucket = "solvative-media-app-static"
  tags = {
    Name = "Static Website"
  }
}

# Allow public access by disabling default block public access settings
resource "aws_s3_bucket_public_access_block" "static_site" {
  bucket                  = aws_s3_bucket.static_website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_site_config" {
  bucket = aws_s3_bucket.static_website.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "allow_static_site" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.static_website.arn}/*"
    }]
  })
}


resource "aws_s3_bucket" "media_storage" {
  bucket = "${var.project_name}-media"
  acl    = "private"

  tags = {
    Name = "Media Storage"
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# CloudWatch
resource "aws_cloudwatch_log_group" "lambda_log" {
  name              = "/aws/lambda/${var.project_name}-handler"
  retention_in_days = 7
}

# Lambda Function
resource "aws_lambda_function" "handler" {
  function_name = "${var.project_name}-handler"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout       = 10

  filename         = "lambda.zip"  # Upload manually or generate
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      ENV = "production"
    }
  }
}

# API Gateway
resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.handler.invoke_arn
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# DynamoDB
resource "aws_dynamodb_table" "users" {
  name         = "users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}

# Aurora Serverless (RDS Cluster - basic config)
resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "${var.project_name}-aurora"
  engine                  = "aurora-mysql"
  engine_mode             = "provisioned"
  database_name           = "mediaapp"
  master_username         = "admin"
  master_password         = "MediaApp123!"
  skip_final_snapshot     = true
  backup_retention_period = 1
}

# Cognito User Pool
resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.project_name}-users"
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "${var.project_name}-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

