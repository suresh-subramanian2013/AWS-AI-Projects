# AWS Troubleshooting Guide

## Common AWS Issues and Solutions

### EC2 Instance Issues

#### Instance Won't Start
**Symptoms:** Instance stuck in "pending" state or fails to start

**Common Causes & Solutions:**
1. **Insufficient Instance Capacity**
   - Error: "InsufficientInstanceCapacity"
   - Solution: Try a different availability zone or instance type
   - Command: `aws ec2 run-instances --availability-zone us-east-1b`

2. **Instance Limit Reached**
   - Error: "InstanceLimitExceeded"
   - Solution: Request limit increase via AWS Support Console
   - Or terminate unused instances

3. **Invalid AMI**
   - Error: "InvalidAMIID.NotFound"
   - Solution: Verify AMI ID is correct and available in your region
   - AMIs are region-specific

#### Cannot Connect to EC2 Instance
**Troubleshooting Steps:**

1. **Check Security Group Rules**
   - Ensure port 22 (SSH) or 3389 (RDP) is open
   - Verify source IP is allowed (0.0.0.0/0 for testing, specific IP for production)
   - Command: `aws ec2 describe-security-groups --group-ids sg-xxxxx`

2. **Verify Network ACLs**
   - Check subnet's Network ACL allows inbound/outbound traffic
   - Default ACL allows all traffic

3. **Check Instance Status**
   - Both System Status and Instance Status should be "passed"
   - Command: `aws ec2 describe-instance-status --instance-ids i-xxxxx`

4. **Verify Key Pair**
   - Ensure you're using the correct .pem file
   - Check file permissions: `chmod 400 your-key.pem`
   - SSH command: `ssh -i your-key.pem ec2-user@<public-ip>`

### S3 Access Issues

#### Access Denied Errors
**Error:** "Access Denied" when accessing S3 bucket

**Solutions:**
1. **Check Bucket Policy**
   - Verify your IAM user/role has permissions
   - Check bucket policy doesn't explicitly deny access
   
2. **Verify IAM Permissions**
   - Required permissions: `s3:GetObject`, `s3:PutObject`, `s3:ListBucket`
   - Check both user policy and bucket policy

3. **Block Public Access Settings**
   - If accessing publicly, ensure "Block all public access" is OFF
   - Check account-level and bucket-level settings

4. **Encryption Issues**
   - If using SSE-KMS, verify KMS key permissions
   - Ensure your IAM role has `kms:Decrypt` permission

#### Slow S3 Performance
**Solutions:**
- Use S3 Transfer Acceleration for large files
- Implement multipart upload for files >100MB
- Use CloudFront CDN for frequently accessed content
- Consider S3 Intelligent-Tiering for cost optimization

### Lambda Function Issues

#### Function Timeout
**Error:** "Task timed out after X seconds"

**Solutions:**
1. Increase timeout in function configuration (max 15 minutes)
2. Optimize code for better performance
3. Consider using Step Functions for long-running workflows
4. Check if function is waiting on external API calls

#### Permission Denied
**Error:** "User is not authorized to perform: [action]"

**Solutions:**
1. **Update IAM Role**
   - Add required permissions to Lambda execution role
   - Common permissions: `logs:CreateLogGroup`, `logs:PutLogEvents`
   
2. **Resource-Based Policies**
   - If accessing other AWS services, ensure Lambda role has permissions
   - Example: S3 bucket policy must allow Lambda role

#### Cold Start Issues
**Symptoms:** First invocation is slow

**Solutions:**
- Increase memory allocation (also increases CPU)
- Use Provisioned Concurrency for critical functions
- Minimize deployment package size
- Use Lambda layers for dependencies

### IAM Permission Issues

#### Access Denied for AWS Service
**Troubleshooting Steps:**

1. **Check IAM Policy**
   ```bash
   aws iam get-user-policy --user-name YOUR_USERNAME --policy-name YOUR_POLICY
   ```

2. **Verify Attached Policies**
   ```bash
   aws iam list-attached-user-policies --user-name YOUR_USERNAME
   ```

3. **Check Service Control Policies (SCPs)**
   - If using AWS Organizations, SCPs may restrict access
   - Contact your AWS administrator

4. **Session Duration**
   - Temporary credentials may have expired
   - Re-authenticate or request new credentials

### VPC and Networking Issues

#### Cannot Access Internet from Private Subnet
**Solutions:**
1. Create NAT Gateway in public subnet
2. Update route table for private subnet to point to NAT Gateway
3. Verify security groups allow outbound traffic

#### VPC Peering Not Working
**Checklist:**
- [ ] Peering connection is in "active" state
- [ ] Route tables updated on both sides
- [ ] Security groups allow traffic from peer VPC CIDR
- [ ] Network ACLs allow traffic
- [ ] No overlapping CIDR blocks

### CloudWatch and Monitoring

#### Logs Not Appearing
**Solutions:**
1. Verify IAM role has CloudWatch Logs permissions
2. Check log group and stream exist
3. Ensure application is writing to stdout/stderr (for Lambda)
4. Check CloudWatch Logs retention settings

#### Metrics Not Showing
**Solutions:**
- Wait 5-15 minutes for metrics to appear (not real-time)
- Verify detailed monitoring is enabled (for EC2)
- Check metric namespace and dimensions are correct

## AWS CLI Troubleshooting

### Common CLI Errors

**"Unable to locate credentials"**
- Run: `aws configure`
- Or set environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`

**"Region not specified"**
- Add `--region us-east-1` to command
- Or set default: `aws configure set region us-east-1`

**"An error occurred (InvalidClientTokenId)"**
- Access key is invalid or deactivated
- Generate new access key in IAM Console

## Best Practices

1. **Always check CloudWatch Logs first** - Most issues leave traces in logs
2. **Use AWS CloudTrail** - Review API calls for permission issues
3. **Enable detailed monitoring** - Helps identify performance issues
4. **Tag resources** - Makes troubleshooting and cost tracking easier
5. **Use AWS Trusted Advisor** - Identifies common issues automatically

## Getting Help

**Internal Resources:**
- AWS Documentation: https://docs.aws.amazon.com
- Internal Wiki: https://wiki.company.com/aws
- Slack Channel: #aws-support

**Escalation:**
- Level 1: Post in #aws-support Slack channel
- Level 2: Email aws-team@company.com
- Level 3: Create ticket in Jira (Project: AWS-SUPPORT)
- Critical Production Issues: Page on-call via PagerDuty

## Useful AWS CLI Commands

```bash
# Check your identity
aws sts get-caller-identity

# List all EC2 instances
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]' --output table

# List S3 buckets
aws s3 ls

# Check Lambda function configuration
aws lambda get-function-configuration --function-name YOUR_FUNCTION

# View CloudWatch logs
aws logs tail /aws/lambda/YOUR_FUNCTION --follow

# Check IAM user permissions
aws iam simulate-principal-policy --policy-source-arn arn:aws:iam::ACCOUNT:user/USERNAME --action-names s3:GetObject
```
