provider "aws" {
  region = "ap-south-1"
}
# Create the S3 bucket
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "rsinfotech-application-artifactstore"
  acl    = "private"
}

# Upload a file to the bucket
resource "aws_s3_bucket_object" "app-login-page.war" {
  bucket = aws_s3_bucket.rsinfotech-application-artifactstore.id
  key    = "app-login-page.war"
  source = "./app-login-page.war"
}
# Configure S3 bucket notification to trigger Lambda function on object creation
resource "aws_s3_bucket_notification" "my_s3_bucket_notification" {
  bucket = aws_s3_bucket.my_s3_bucket.id
  
  lambda_function {
    lambda_function_arn = aws_lambda_function.zip_the_python_code_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".war" # Replace with the desired file extension triggering the Lambda function
  }
}
# Create a Lambda function
resource "aws_lambda_function" "example_lambda" {
  function_name = "lambda-function"
 role          = "arn:aws:iam::640111764884:role/stsassume-role"
  handler       = "lambda-function/lambda-function.lambda_handler"
  runtime       = "python3.10"
  memory_size   = 128
  timeout       = 30

  filename = "lambda-function.zip" # Make sure the ZIP file is in the same directory as your Terraform configuration

  source_code_hash = filebase64sha256("lambda-function.zip")

    vpc_config {
    subnet_ids         = [for each_subnet in aws_subnet.private_subnet : each_subnet.id]
    security_group_ids = [aws_security_group.lambda_function.id]
  }
}


# Add Permissions to S3 Bucket to invoke Lambda
resource "aws_lambda_permission" "s3_bucket_permission" {
  statement_id  = "s3-lambda-sns"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.rsinfotech-application-artifactstore.arn
}

# Create an S3 event trigger for the Lambda function
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.rsinfotech-application-artifactstoret.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda-function.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

# Create an SNS topic
resource "aws_sns_topic" "my_topic" {
  name = "s3-lambda-sns"
}

# Add SNS publish permission to the Lambda Function
resource "aws_lambda_permission" "sns_permission" {
  statement_id  = "sns-lambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.my_topic.arn
}

# Subscribe Lambda function to the SNS topic
resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda-function.arn
}

# Publish SNS message
resource "aws_sns_topic" "message" {
  name = "s3-lambda-sns"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.message.arn
  protocol  = "email"
  endpoint  = "rahulsharan512@gmail.com"
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn    = aws_sns_topic.message.arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["sns:Publish"],
        Effect = "Allow",
        Principal = "*",
        Resource = "*",
        Condition = {
          ArnEquals = {
            "aws:SourceArn": aws_sns_topic.message.arn
          }
        }
      }
    ],
  })
}
