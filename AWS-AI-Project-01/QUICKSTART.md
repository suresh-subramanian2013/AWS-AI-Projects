# Quick Start Guide - AWS Bedrock IT Support Chatbot

## 🚀 5-Minute Quick Start

### Step 1: Enable Bedrock Access (2 minutes)

1. Go to [AWS Console → Bedrock](https://console.aws.amazon.com/bedrock)
2. Click **Model access** → **Enable specific models**
3. Select **Anthropic Claude 3 Sonnet**
4. Click **Request model access** (instant approval)

### Step 2: Deploy Infrastructure (2 minutes)

```bash
cd d:/learning/cncf/aws-ai-project-1/terraform
terraform init
terraform apply -auto-approve
```

### Step 3: Test the Chatbot (1 minute)

```bash
# Get API endpoint
API_ENDPOINT=$(terraform output -raw api_endpoint)

# Test query
curl -X POST $API_ENDPOINT \
  -H "Content-Type: application/json" \
  -d '{"query": "How do I reset my password?"}'
```

**Expected Response**:
```json
{
  "query": "How do I reset my password?",
  "response": "To reset your password, you can use the self-service portal...",
  "timestamp": "2024-12-16T06:20:15.123456",
  "model": "anthropic.claude-3-sonnet-20240229-v1:0"
}
```

## 📱 Usage Examples

### Example 1: Password Reset
```bash
curl -X POST $API_ENDPOINT \
  -H "Content-Type: application/json" \
  -d '{"query": "I forgot my password. What should I do?"}'
```

### Example 2: AWS Troubleshooting
```bash
curl -X POST $API_ENDPOINT \
  -H "Content-Type: application/json" \
  -d '{"query": "My EC2 instance won'\''t start. How do I troubleshoot this?"}'
```

### Example 3: Onboarding
```bash
curl -X POST $API_ENDPOINT \
  -H "Content-Type: application/json" \
  -d '{"query": "I'\''m a new employee. How do I get AWS access?"}'
```

### Example 4: Lambda Issues
```bash
curl -X POST $API_ENDPOINT \
  -H "Content-Type: application/json" \
  -d '{"query": "My Lambda function is timing out. What could be wrong?"}'
```

## 🧪 Run All Tests

```bash
cd scripts
chmod +x test-chatbot.sh
./test-chatbot.sh $API_ENDPOINT
```

## 📊 Monitor Logs

```bash
# Real-time logs
aws logs tail /aws/lambda/it-support-chatbot-chatbot --follow

# Last 10 minutes
aws logs tail /aws/lambda/it-support-chatbot-chatbot --since 10m
```

## 🔧 Common Commands

### View API Endpoint
```bash
cd terraform
terraform output api_endpoint
```

### View All Resources
```bash
terraform output
```

### Update Knowledge Base
```bash
# Edit files in knowledge-base/
cd ../scripts
./upload-knowledge-base.sh $(cd ../terraform && terraform output -raw knowledge_base_bucket)
```

### Destroy Everything
```bash
cd terraform
terraform destroy -auto-approve
```

## 💡 Tips

1. **Save API Endpoint**: Store it in environment variable
   ```bash
   export CHATBOT_API=$(cd terraform && terraform output -raw api_endpoint)
   curl -X POST $CHATBOT_API -H "Content-Type: application/json" -d '{"query": "test"}'
   ```

2. **Use jq for Pretty Output**:
   ```bash
   curl -X POST $API_ENDPOINT \
     -H "Content-Type: application/json" \
     -d '{"query": "How do I reset my password?"}' | jq .
   ```

3. **Check Costs**:
   ```bash
   aws ce get-cost-and-usage \
     --time-period Start=2024-12-01,End=2024-12-16 \
     --granularity MONTHLY \
     --metrics BlendedCost \
     --filter file://cost-filter.json
   ```

## 🆘 Troubleshooting

### Issue: "Access Denied" Error

**Solution**: Check Bedrock model access
```bash
aws bedrock list-foundation-models --region us-east-1 \
  --query 'modelSummaries[?contains(modelId, `claude-3-sonnet`)].modelId'
```

### Issue: Lambda Timeout

**Solution**: Increase timeout in `terraform/variables.tf`
```hcl
variable "lambda_timeout" {
  default = 120  # Increase from 60
}
```
Then run: `terraform apply`

### Issue: Knowledge Base Not Loading

**Solution**: Verify S3 files
```bash
aws s3 ls s3://$(terraform output -raw knowledge_base_bucket)/
```

## 📚 Full Documentation

- [README.md](../README.md) - Complete project overview
- [DEPLOYMENT.md](../DEPLOYMENT.md) - Detailed deployment guide
- [docs/architecture-diagram.md](../docs/architecture-diagram.md) - Architecture details

## 🎯 Next Steps

1. ✅ Deploy and test basic functionality
2. ⬜ Customize knowledge base documents
3. ⬜ Add API authentication
4. ⬜ Create web UI
5. ⬜ Integrate with Slack/Teams

---

**Ready to deploy? Run the commands above and your chatbot will be live in 5 minutes!** 🚀
