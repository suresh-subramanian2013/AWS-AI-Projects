# Password Reset Procedures

## Self-Service Password Reset

### For Windows/Active Directory Passwords

1. **Using the Self-Service Portal**
   - Navigate to: https://password.company.com
   - Click "Forgot Password"
   - Enter your employee ID or email address
   - Answer your security questions
   - Follow the prompts to create a new password

2. **Password Requirements**
   - Minimum 12 characters
   - Must include: uppercase, lowercase, number, and special character
   - Cannot reuse last 5 passwords
   - Expires every 90 days

### For AWS Console Passwords

1. **If you have MFA enabled:**
   - Go to AWS Console login page
   - Click "Forgot your password?"
   - Enter your IAM username
   - Check your registered email for reset link
   - Use your MFA device to authenticate
   - Set new password

2. **If you don't have MFA or cannot access it:**
   - Contact IT Support at: it-support@company.com
   - Or call: +1-555-IT-HELP (555-484-4357)
   - Provide your employee ID and manager's name for verification

### For Application-Specific Passwords

**Jira/Confluence:**
- Use the same Active Directory credentials
- If locked out, reset your AD password (see above)

**Slack:**
- Click "Forgot Password" on Slack login
- Check your company email for reset link

**VPN:**
- Uses Active Directory credentials
- If issues persist after AD password reset, contact IT Support

## Common Password Issues

### Account Locked Out
**Symptom:** "Account is locked" message
**Solution:**
- Wait 30 minutes for automatic unlock, OR
- Contact IT Support for immediate unlock
- After 3 failed attempts, account locks for 30 minutes

### Password Expired
**Symptom:** "Password has expired" message
**Solution:**
- Press Ctrl+Alt+Del on Windows machine
- Select "Change Password"
- Enter old password and new password twice
- New password must meet complexity requirements

### MFA Device Lost or Broken
**Solution:**
1. Contact IT Support immediately
2. Provide: Employee ID, Manager name, Last successful login date
3. IT will verify your identity and reset MFA
4. You'll receive a new MFA device or setup instructions

## Security Best Practices

- **Never share your password** with anyone, including IT staff
- **Use unique passwords** for different systems
- **Enable MFA** wherever possible
- **Use a password manager** (company-approved: 1Password)
- **Report suspicious emails** asking for password to security@company.com

## Emergency Access

If you cannot access any systems and need immediate help:
- **During business hours (9 AM - 6 PM EST):** Call IT Support at +1-555-484-4357
- **After hours:** Email it-emergency@company.com
- **Critical production issues:** Page on-call engineer via PagerDuty

## FAQ

**Q: How often should I change my password?**
A: Active Directory passwords expire every 90 days. You'll receive email reminders 14 days before expiration.

**Q: Can I use the same password for AWS and Active Directory?**
A: No, these are separate systems. However, we recommend using a password manager to handle multiple credentials securely.

**Q: What if I forget my security questions?**
A: Contact IT Support with your employee ID and manager's name. They will verify your identity and reset your security questions.

**Q: Is there a mobile app for password reset?**
A: Yes, download "Company Self-Service" from your app store. Use your employee ID to register.
