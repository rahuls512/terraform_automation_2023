resource "aws_lambda_function" "my_lambda_function" {
  filename         = "lambda_function"
  function_name    = "deploy_artifact"
  role             = "arn:aws:iam::640111764884:role/stsassume-role"
  handler          = "lambda_function.handler"
  runtime          = "python3.10"
  timeout          = 10

  vpc_config {
    subnet_ids         = [for each_subnet in aws_subnet.public_subnet : each_subnet.id]
    security_group_ids = [aws_security_group.lambda_function.id]
  }
}
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "rsinfotech-application-artifactstore"  # Replace with your desired S3 bucket name
}

resource "aws_lambda_permission" "s3_trigger_permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.arn
  principal     = "s3.amazonaws.com"
  
  source_arn = aws_s3_bucket.my_s3_bucket.arn
}

resource "aws_s3_bucket_notification" "my_s3_bucket_notification" {
  bucket = aws_s3_bucket.my_s3_bucket.id
  
  lambda_function {
    lambda_function_arn = aws_lambda_function.my_lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".war"  # Replace with the desired file extension triggering the Lambda function
  }
}
