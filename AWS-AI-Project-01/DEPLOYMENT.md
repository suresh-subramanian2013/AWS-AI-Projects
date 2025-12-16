# Deployment Guide - AWS Bedrock IT Support Chatbot

This guide provides step-by-step instructions for deploying the IT Support Chatbot to AWS.

## Prerequisites Checklist

Before starting, ensure you have:

- [ ] AWS Account with administrator access
- [ ] AWS CLI installed and configured
- [ ] Terraform >= 1.0 installed
- [ ] Python 3.11+ installed
- [ ] Git installed
- [ ] Bedrock model access enabled (see below)

## Step 1: Enable Amazon Bedrock Access

### 1.1 Request Model Access

1. Log into AWS Console
2. Navigate to **Amazon Bedrock** service
3. Select your region (e.g., us-east-1)
4. Click **Model access** in left sidebar
5. Click **Enable specific models**
6. Select **Anthropic Claude 3 Sonnet**
7. Click **Request model access**
8. Wait for approval (usually instant)

### 1.2 Verify Access

```bash
aws bedrock list-foundation-models --region us-east-1 \
  --query 'modelSummaries[?contains(modelId, `claude-3-sonnet`)].modelId'
```

Expected output:
```json
[
    "anthropic.claude-3-sonnet-20240229-v1:0"
]
```

## Step 2: Configure AWS Credentials

### 2.1 Using AWS CLI

```bash
aws configure
```

Enter:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., us-east-1)
- Default output format (json)

### 2.2 Verify Configuration

```bash
aws sts get-caller-identity
```

## Step 3: Clone and Prepare Project

```bash
# Navigate to your projects directory
cd d:/learning/cncf/

# If not already cloned, the project should be at:
cd aws-ai-project-1

# Verify project structure
ls -la
```

## Step 4: Deploy with Terraform

### 4.1 Initialize Terraform

```bash
cd terraform
terraform init
```

Expected output:
```
Terraform has been successfully initialized!
```

### 4.2 Review Configuration (Optional)

Edit `variables.tf` to customize:

```hcl
variable "aws_region" {
  default = "us-east-1"  # Change if needed
}

variable "bedrock_model_id" {
  default = "anthropic.claude-3-sonnet-20240229-v1:0"
}

variable "lambda_timeout" {
  default = 60  # Increase if needed
}
```

### 4.3 Plan Deployment

```bash
terraform plan
```

Review the resources that will be created:
- S3 bucket for knowledge base
- Lambda function
- API Gateway REST API
- IAM roles and policies
- CloudWatch log groups
- CloudWatch alarms

### 4.4 Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

Deployment takes ~2-3 minutes.

### 4.5 Save Outputs

```bash
# Save API endpoint
terraform output api_endpoint > ../api-endpoint.txt

# Display all outputs
terraform output
```

Expected outputs:
```
api_endpoint = "https://abc123xyz.execute-api.us-east-1.amazonaws.com/dev/chat"
knowledge_base_bucket = "it-support-chatbot-knowledge-base-123456789"
lambda_function_name = "it-support-chatbot-chatbot"
```

## Step 5: Verify Deployment

### 5.1 Check Lambda Function

```bash
aws lambda get-function --function-name it-support-chatbot-chatbot
```

### 5.2 Check S3 Bucket

```bash
# Get bucket name from Terraform output
BUCKET_NAME=$(terraform output -raw knowledge_base_bucket)

# List uploaded files
aws s3 ls s3://$BUCKET_NAME/
```

Expected output:
```
2024-12-16 12:00:00       1234 aws-troubleshooting.md
2024-12-16 12:00:00       5678 onboarding-faqs.md
2024-12-16 12:00:00       3456 password-reset.md
```

### 5.3 Check API Gateway

```bash
aws apigateway get-rest-apis --query 'items[?name==`it-support-chatbot-api`]'
```

## Step 6: Test the Chatbot

### 6.1 Quick Test with curl

```bash
# Get API endpoint
API_ENDPOINT=$(terraform output -raw api_endpoint)

# Test password reset query
curl -X POST $API_ENDPOINT \
  -H "Content-Type: application/json" \
  -d '{"query": "How do I reset my password?"}'
```

### 6.2 Run Automated Tests

```bash
cd ../scripts

# Make script executable (Linux/Mac)
chmod +x test-chatbot.sh

# Run tests
./test-chatbot.sh $(cd ../terraform && terraform output -raw api_endpoint)
```

### 6.3 Test All Sample Queries

```bash
# Test each query from examples
cd ../examples

for query in $(jq -r '.[].query' test-queries.json); do
  echo "Testing: $query"
  curl -X POST $API_ENDPOINT \
    -H "Content-Type: application/json" \
    -d "{\"query\": \"$query\"}" | jq -r '.response' | head -c 200
  echo -e "\n---\n"
done
```

## Step 7: Monitor and Verify

### 7.1 View Lambda Logs

```bash
# Tail logs in real-time
aws logs tail /aws/lambda/it-support-chatbot-chatbot --follow

# Or view recent logs
aws logs tail /aws/lambda/it-support-chatbot-chatbot --since 10m
```

### 7.2 Check CloudWatch Metrics

```bash
# Lambda invocations (last hour)
aws cloudwatch get-metric-statistics \
  --namespace AWS/Lambda \
  --metric-name Invocations \
  --dimensions Name=FunctionName,Value=it-support-chatbot-chatbot \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 3600 \
  --statistics Sum
```

### 7.3 Check for Errors

```bash
# Lambda errors
aws cloudwatch get-metric-statistics \
  --namespace AWS/Lambda \
  --metric-name Errors \
  --dimensions Name=FunctionName,Value=it-support-chatbot-chatbot \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 3600 \
  --statistics Sum
```

## Step 8: Update Knowledge Base (Optional)

### 8.1 Edit Knowledge Base Files

```bash
cd ../knowledge-base

# Edit any markdown file
nano password-reset.md
```

### 8.2 Upload Updated Files

```bash
cd ../scripts

# Upload all knowledge base files
./upload-knowledge-base.sh $(cd ../terraform && terraform output -raw knowledge_base_bucket)
```

### 8.3 Or Use Terraform

```bash
cd ../terraform

# Terraform will detect changes and update S3
terraform apply
```

## Troubleshooting

### Issue: "Access Denied" when invoking Bedrock

**Solution:**
1. Verify model access in Bedrock console
2. Check IAM role permissions:
   ```bash
   aws iam get-role-policy \
     --role-name it-support-chatbot-lambda-role \
     --policy-name it-support-chatbot-bedrock-policy
   ```

### Issue: Lambda timeout errors

**Solution:**
1. Increase timeout in `variables.tf`:
   ```hcl
   variable "lambda_timeout" {
     default = 120  # Increase from 60
   }
   ```
2. Re-apply:
   ```bash
   terraform apply
   ```

### Issue: Knowledge base not loading

**Solution:**
1. Verify files are in S3:
   ```bash
   aws s3 ls s3://$(terraform output -raw knowledge_base_bucket)/
   ```
2. Check Lambda has S3 permissions:
   ```bash
   aws iam get-role-policy \
     --role-name it-support-chatbot-lambda-role \
     --policy-name it-support-chatbot-s3-policy
   ```

### Issue: API returns 500 error

**Solution:**
1. Check Lambda logs:
   ```bash
   aws logs tail /aws/lambda/it-support-chatbot-chatbot --since 5m
   ```
2. Look for error messages
3. Verify environment variables:
   ```bash
   aws lambda get-function-configuration \
     --function-name it-support-chatbot-chatbot \
     --query 'Environment'
   ```

## Cleanup

To remove all resources:

```bash
cd terraform
terraform destroy
```

Type `yes` when prompted.

> [!WARNING]
> This will delete all resources including the S3 bucket and knowledge base documents.

## Production Deployment Considerations

### Security Enhancements

1. **Add API Authentication**
   - Use API Gateway API Keys
   - Implement AWS Cognito
   - Use IAM authorization

2. **VPC Deployment**
   - Deploy Lambda in private subnet
   - Use VPC endpoints for AWS services

3. **Secrets Management**
   - Use AWS Secrets Manager for sensitive data
   - Rotate credentials regularly

### Performance Optimization

1. **Provisioned Concurrency**
   ```hcl
   resource "aws_lambda_provisioned_concurrency_config" "chatbot" {
     function_name = aws_lambda_function.chatbot.function_name
     provisioned_concurrent_executions = 2
     qualifier = aws_lambda_alias.chatbot.name
   }
   ```

2. **Increase Memory**
   - Higher memory = more CPU
   - Test optimal memory size

### Cost Optimization

1. **Set up billing alerts**
2. **Use CloudWatch Logs retention**
3. **Monitor Bedrock usage**
4. **Implement caching for frequent queries**

## Next Steps

1. ✅ Deploy infrastructure
2. ✅ Test basic functionality
3. ⬜ Add authentication
4. ⬜ Create web UI
5. ⬜ Integrate with Slack/Teams
6. ⬜ Implement conversation history
7. ⬜ Add feedback mechanism

## Support

For issues:
1. Check CloudWatch logs
2. Review [README.md](README.md)
3. Consult AWS documentation
4. Open GitHub issue

---

**Deployment complete! Your chatbot is ready to use.** 🚀
