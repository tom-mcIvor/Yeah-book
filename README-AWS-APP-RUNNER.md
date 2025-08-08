# AWS App Runner Deployment Branch

This branch contains all the necessary configuration files and documentation for deploying the Yeah-book application to AWS App Runner.

## 🚀 Quick Start

### Option 1: GitHub Integration (Recommended)
1. Push this branch to GitHub
2. Go to AWS App Runner console
3. Create service with GitHub source
4. Select `aws-app-runner` branch
5. Deploy automatically

### Option 2: Container Deployment
1. Run the setup script: `./scripts/setup-apprunner.sh`
2. Follow the prompts to build and push to ECR
3. Create App Runner service with container image

## 📁 Files Added

| File | Purpose |
|------|---------|
| [`apprunner.yaml`](apprunner.yaml) | App Runner build configuration |
| [`Dockerfile`](Dockerfile) | Container configuration |
| [`.dockerignore`](.dockerignore) | Docker build optimization |
| [`AWS_APP_RUNNER_DEPLOYMENT.md`](AWS_APP_RUNNER_DEPLOYMENT.md) | Complete deployment guide |
| [`.github/workflows/aws-app-runner.yml`](.github/workflows/aws-app-runner.yml) | CI/CD pipeline |
| [`.env.apprunner`](.env.apprunner) | Environment variables template |
| [`scripts/setup-apprunner.sh`](scripts/setup-apprunner.sh) | Automated setup script |

## 🔧 Configuration

### Environment Variables
Copy variables from [`.env.apprunner`](.env.apprunner) to your App Runner service:
- `NODE_ENV=production`
- `PORT=3000`
- Add Auth0 and database credentials as needed

### Database Migration
- **Current**: SQLite (ephemeral in App Runner)
- **Recommended**: Migrate to RDS PostgreSQL for production

### File Storage Migration
- **Current**: Local file system (ephemeral)
- **Recommended**: Migrate to S3 + CloudFront

## 💰 Estimated Costs
- **App Runner**: ~$25-50/month
- **RDS (optional)**: ~$15-20/month
- **S3 + CloudFront (optional)**: ~$1-5/month

## 📖 Documentation

Read the complete deployment guide: [`AWS_APP_RUNNER_DEPLOYMENT.md`](AWS_APP_RUNNER_DEPLOYMENT.md)

## 🔄 CI/CD

The GitHub Actions workflow automatically:
1. Runs tests on push/PR
2. Builds and pushes Docker image to ECR
3. Deploys to App Runner on push to `aws-app-runner` branch

## ⚡ Why App Runner?

- **Simple**: Minimal configuration required
- **Automatic**: Built-in CI/CD with GitHub integration
- **Scalable**: Auto-scaling based on traffic
- **Managed**: No infrastructure management needed

## 🆚 vs Other AWS Services

| Feature | App Runner | Elastic Beanstalk | ECS Fargate |
|---------|------------|-------------------|-------------|
| Simplicity | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| CI/CD | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Control | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Cost | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |

App Runner is perfect for your requirement of "simple deployment with CI/CD integration"!