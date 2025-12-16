variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "it-support-chatbot"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "bedrock_model_id" {
  description = "Amazon Bedrock model ID to use"
  type        = string
  default     = "anthropic.claude-3-sonnet-20240229-v1:0"
  
  validation {
    condition = can(regex("^(anthropic\\.claude|amazon\\.titan)", var.bedrock_model_id))
    error_message = "Model ID must be a valid Bedrock model (Claude or Titan)."
  }
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 60
  
  validation {
    condition     = var.lambda_timeout >= 3 && var.lambda_timeout <= 900
    error_message = "Lambda timeout must be between 3 and 900 seconds."
  }
}

variable "lambda_memory" {
  description = "Lambda function memory in MB"
  type        = number
  default     = 512
  
  validation {
    condition     = var.lambda_memory >= 128 && var.lambda_memory <= 10240
    error_message = "Lambda memory must be between 128 and 10240 MB."
  }
}

variable "max_tokens" {
  description = "Maximum tokens for Bedrock response"
  type        = number
  default     = 2048
}

variable "temperature" {
  description = "Temperature for Bedrock model (0.0 - 1.0)"
  type        = number
  default     = 0.7
  
  validation {
    condition     = var.temperature >= 0.0 && var.temperature <= 1.0
    error_message = "Temperature must be between 0.0 and 1.0."
  }
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
  
  validation {
    condition = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "Log retention must be a valid CloudWatch retention period."
  }
}
