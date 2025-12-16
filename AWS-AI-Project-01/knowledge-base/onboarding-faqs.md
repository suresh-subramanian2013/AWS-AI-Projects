# New Employee Onboarding FAQs

## Welcome to the Team! 🎉

This guide will help you get started with all the tools and systems you'll need.

## First Day Checklist

### Account Setup
- [ ] Receive company laptop and equipment
- [ ] Set up Active Directory account (IT will create this)
- [ ] Set up email (firstname.lastname@company.com)
- [ ] Configure MFA for all accounts
- [ ] Join company Slack workspace
- [ ] Set up VPN access

### Required Training
- [ ] Information Security Training (complete within first week)
- [ ] AWS Fundamentals (if working with cloud resources)
- [ ] Company Code of Conduct
- [ ] Diversity & Inclusion Training

## Essential Tools & Access

### Communication Tools

**Slack**
- Primary communication platform
- Join channels: #general, #engineering, #random, your team channel
- Download desktop and mobile apps
- Set up notifications preferences

**Email**
- Outlook/Gmail access: mail.company.com
- Set up email signature (template in welcome email)
- Configure calendar sharing with your team

**Zoom**
- Video conferencing for meetings
- Download desktop client
- Test audio/video before first meeting
- Company meeting room: https://zoom.us/j/company-room

### Development Tools

**GitHub**
- Request access via: github-access@company.com
- Provide your GitHub username
- You'll be added to company organization
- Enable 2FA on your GitHub account

**Jira**
- Project management and issue tracking
- Access: jira.company.com
- Your manager will assign you to relevant projects
- Complete Jira tutorial: https://wiki.company.com/jira-101

**Confluence**
- Company wiki and documentation
- Access: confluence.company.com
- Bookmark important pages for your role
- Create your user profile page

### AWS Access

**Getting AWS Access:**
1. Submit request via IT Service Portal
2. Specify which AWS accounts you need (dev/staging/prod)
3. Manager approval required
4. Access granted within 24 hours

**AWS Account Types:**
- **Development:** Full access for testing and development
- **Staging:** Limited access, requires approval for changes
- **Production:** Read-only by default, write access requires approval

**AWS Best Practices:**
- Always use MFA for AWS Console access
- Use IAM roles, not root account
- Tag all resources with your name and project
- Stop/terminate unused resources to save costs
- Never commit AWS credentials to Git

### VPN Setup

**Why VPN?**
- Required for accessing internal resources remotely
- Encrypts your connection for security
- Mandatory when working from home or traveling

**Setup Instructions:**
1. Download Cisco AnyConnect from: vpn.company.com
2. Install and restart your computer
3. Connect using your AD credentials
4. Enter MFA code when prompted

**VPN Troubleshooting:**
- If connection fails, verify your AD password is correct
- Ensure MFA device is working
- Try disconnecting and reconnecting
- Contact IT if issues persist: it-support@company.com

## Common Questions

### General

**Q: Who is my IT point of contact?**
A: Your manager will introduce you to your team's IT liaison. For general issues, contact it-support@company.com or Slack #it-help.

**Q: How do I request new software?**
A: Submit request via IT Service Portal. Include business justification and manager approval. Standard tools approved within 2 days.

**Q: What are the working hours?**
A: Core hours are 10 AM - 4 PM local time. Flexible schedule outside core hours. Discuss with your manager.

**Q: How do I book meeting rooms?**
A: Use Outlook/Google Calendar room booking. Meeting rooms appear as resources. Book at least 30 minutes in advance.

**Q: Where can I find company policies?**
A: All policies are on Confluence: https://confluence.company.com/policies

### Technical

**Q: How do I get access to production systems?**
A: Production access requires:
1. Completion of security training
2. Manager approval
3. Documented business need
4. Approval from security team
Process takes 3-5 business days.

**Q: What's the code review process?**
A: 
1. Create feature branch from main
2. Make changes and commit
3. Push to GitHub and create Pull Request
4. Request review from 2 team members
5. Address feedback and get approvals
6. Merge to main (squash commits)

**Q: How do I deploy to production?**
A: 
- Deployments happen during deployment windows (Tue/Thu 2-4 PM EST)
- Requires approval from tech lead
- Follow deployment runbook in Confluence
- Never deploy on Fridays or before holidays

**Q: What monitoring tools do we use?**
A: 
- **CloudWatch:** AWS resource monitoring
- **Datadog:** Application performance monitoring
- **PagerDuty:** On-call and incident management
- **Sentry:** Error tracking and debugging

**Q: How do I access databases?**
A: 
- Development databases: Direct access via VPN
- Production databases: Read-only access via bastion host
- Write access requires change ticket and approval
- Use provided connection strings (never hardcode credentials)

### AWS Specific

**Q: Which AWS region should I use?**
A: 
- Primary: us-east-1 (N. Virginia)
- DR/Backup: us-west-2 (Oregon)
- Europe: eu-west-1 (Ireland)
Check with your team for project-specific requirements.

**Q: How do I manage AWS costs?**
A: 
- Use cost allocation tags
- Set up billing alerts in CloudWatch
- Review AWS Cost Explorer monthly
- Shut down dev resources when not in use
- Use spot instances for non-critical workloads

**Q: What's our infrastructure as code tool?**
A: We use Terraform for infrastructure. All infrastructure changes must be:
- Defined in Terraform code
- Reviewed via Pull Request
- Applied via CI/CD pipeline
- Never make manual changes in AWS Console

**Q: How do I get help with AWS?**
A: 
1. Check internal AWS wiki: https://wiki.company.com/aws
2. Ask in Slack #aws-support
3. Email aws-team@company.com
4. For urgent issues, page on-call engineer

### Security

**Q: What should I do if I accidentally commit credentials?**
A: 
1. **IMMEDIATELY** rotate the credentials in AWS Console
2. Notify security team: security@company.com
3. Remove credentials from Git history
4. File incident report
5. Complete security remediation training

**Q: How do I report a security issue?**
A: 
- Email: security@company.com
- Slack: DM @security-team
- For vulnerabilities: Use HackerOne portal
- Never discuss security issues in public channels

**Q: What's the password policy?**
A: 
- Minimum 12 characters
- Must include: uppercase, lowercase, number, special character
- Expires every 90 days
- Cannot reuse last 5 passwords
- Use password manager (1Password provided)

## Important Links

### Daily Use
- **Email:** mail.company.com
- **Slack:** company.slack.com
- **VPN:** vpn.company.com
- **IT Service Portal:** servicedesk.company.com

### Development
- **GitHub:** github.com/company
- **Jira:** jira.company.com
- **Confluence:** confluence.company.com
- **AWS Console:** company.signin.aws.amazon.com/console

### Resources
- **Employee Handbook:** https://handbook.company.com
- **Engineering Wiki:** https://wiki.company.com
- **API Documentation:** https://api-docs.company.com
- **Architecture Diagrams:** https://confluence.company.com/architecture

## Getting Help

**IT Support:**
- Email: it-support@company.com
- Slack: #it-help
- Phone: +1-555-484-4357
- Hours: Monday-Friday, 9 AM - 6 PM EST

**HR Questions:**
- Email: hr@company.com
- Slack: #people-ops
- Your HR Business Partner (introduced in welcome email)

**Manager:**
- Schedule 1:1 meetings weekly
- Ask questions anytime - no question is too small!
- Discuss career goals and development

**Buddy Program:**
- You'll be assigned an onboarding buddy
- Meet regularly during first month
- Ask them anything about company culture, processes, etc.

## Tips for Success

1. **Ask Questions** - Everyone was new once. Don't hesitate to ask!
2. **Take Notes** - Lots of information in first few weeks
3. **Meet People** - Schedule coffee chats with team members
4. **Read Documentation** - Familiarize yourself with team wikis
5. **Set Up Your Environment** - Get your dev environment working ASAP
6. **Join Channels** - Slack channels are great for learning
7. **Attend Meetings** - Even if optional, helps you learn faster
8. **Give Feedback** - Help us improve onboarding for future hires

## 30-60-90 Day Goals

### First 30 Days
- Complete all required training
- Set up development environment
- Deploy your first change to production
- Meet with all team members
- Understand team's current projects

### 60 Days
- Take ownership of small features
- Participate in on-call rotation (with buddy)
- Contribute to documentation
- Understand system architecture

### 90 Days
- Lead a small project
- Mentor newer team members
- Identify improvement opportunities
- Full participation in team processes

---

**Welcome aboard! We're excited to have you on the team! 🚀**

If you have questions not covered here, reach out to your manager or post in #new-hires Slack channel.
