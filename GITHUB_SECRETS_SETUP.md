# 🔐 GitHub Secrets Setup for AWS App Runner Deployment

The GitHub Actions workflow failed because AWS credentials are not configured. Here's how to fix it:

## 🚨 **Issue Identified:**
```
Error: Credentials could not be loaded, please check your action inputs: Could not load credentials from any providers
```

## ✅ **Solution: Add GitHub Secrets**

### Step 1: Get Your AWS Credentials
You already have AWS CLI configured. Get your credentials:

```bash
# View your current AWS configuration
aws configure list

# Get your access key ID (already visible in your setup)
# Account: 122881847754
# User: yeahbook-deploy
```

### Step 2: Add Secrets to GitHub Repository

1. **Go to your GitHub repository:**
   - https://github.com/tom-mcIvor/Yeah-book

2. **Navigate to Settings:**
   - Click **"Settings"** tab
   - Click **"Secrets and variables"** → **"Actions"**

3. **Add these Repository Secrets:**

   **Secret 1: AWS_ACCESS_KEY_ID**
   - Click **"New repository secret"**
   - Name: `AWS_ACCESS_KEY_ID`
   - Value: Your AWS Access Key ID

   **Secret 2: AWS_SECRET_ACCESS_KEY**
   - Click **"New repository secret"**
   - Name: `AWS_SECRET_ACCESS_KEY`
   - Value: Your AWS Secret Access Key

   **Secret 3: ROLE_ARN (Optional for advanced deployment)**
   - Name: `ROLE_ARN`
   - Value: `arn:aws:iam::122881847754:role/AppRunnerECRAccessRole`
   - (This will be created automatically by App Runner)

### Step 3: Find Your AWS Credentials

If you need to find your credentials:

```bash
# Check your AWS credentials file
cat ~/.aws/credentials

# Or check your environment variables
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
```

### Step 4: Test the Deployment

After adding the secrets:

1. **Make a small change and push:**
   ```bash
   # Make a small change to trigger deployment
   echo "# Deployment test" >> README-AWS-APP-RUNNER.md
   git add .
   git commit -m "Test deployment with GitHub Actions"
   git push origin aws-app-runner
   ```

2. **Monitor the deployment:**
   - Go to: https://github.com/tom-mcIvor/Yeah-book/actions
   - Watch the workflow run

## 🎯 **Alternative: Deploy via AWS Console (Simpler)**

If you prefer to skip GitHub Actions for now:

1. **Go directly to AWS App Runner Console:**
   - https://console.aws.amazon.com/apprunner/

2. **Create service manually:**
   - Source: GitHub repository
   - Repository: `tom-mcIvor/Yeah-book`
   - Branch: `aws-app-runner`
   - Configuration: Use configuration file (`apprunner.yaml`)

3. **This bypasses GitHub Actions** and uses App Runner's built-in GitHub integration

## 🔍 **Security Note:**

- Never commit AWS credentials to your repository
- Use GitHub Secrets for sensitive information
- The `yeahbook-deploy` user should have minimal required permissions:
  - `AWSAppRunnerFullAccess`
  - `AmazonEC2ContainerRegistryFullAccess`

## 📋 **Quick Checklist:**

- [ ] Add `AWS_ACCESS_KEY_ID` to GitHub Secrets
- [ ] Add `AWS_SECRET_ACCESS_KEY` to GitHub Secrets
- [ ] Push a test commit to trigger deployment
- [ ] Monitor GitHub Actions workflow
- [ ] Check App Runner console for service creation

## 🚀 **Expected Result:**

After adding secrets and pushing:
- ✅ GitHub Actions workflow completes successfully
- ✅ Docker image builds and pushes to ECR
- ✅ App Runner service deploys automatically
- ✅ You get a live application URL

Choose your preferred method and your app will be deployed!