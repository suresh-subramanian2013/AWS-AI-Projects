output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = "${aws_api_gateway_stage.chatbot_stage.invoke_url}/chat"
}

output "api_gateway_id" {
  description = "API Gateway REST API ID"
  value       = aws_api_gateway_rest_api.chatbot_api.id
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.chatbot.function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.chatbot.arn
}

output "knowledge_base_bucket" {
  description = "S3 bucket name for knowledge base"
  value       = aws_s3_bucket.knowledge_base.id
}

output "knowledge_base_bucket_arn" {
  description = "S3 bucket ARN for knowledge base"
  value       = aws_s3_bucket.knowledge_base.arn
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group name for Lambda"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "lambda_role_arn" {
  description = "IAM role ARN for Lambda function"
  value       = aws_iam_role.lambda_role.arn
}

output "test_command" {
  description = "Example curl command to test the API"
  value       = <<-EOT
    curl -X POST ${aws_api_gateway_stage.chatbot_stage.invoke_url}/chat \
      -H "Content-Type: application/json" \
      -d '{"query": "How do I reset my password?"}'
  EOT
}
