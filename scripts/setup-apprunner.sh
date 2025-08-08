#!/bin/bash

# AWS App Runner Setup Script
# This script helps set up the necessary AWS resources for App Runner deployment

set -e

echo "🚀 AWS App Runner Setup Script"
echo "================================"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if AWS credentials are configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS credentials not configured. Please run 'aws configure' first."
    exit 1
fi

# Variables
REGION=${AWS_REGION:-us-east-1}
ECR_REPO_NAME="yeah-book"
APP_RUNNER_SERVICE_NAME="yeah-book-service"

echo "📍 Using AWS Region: $REGION"

# Create ECR repository
echo "🏗️  Creating ECR repository..."
if aws ecr describe-repositories --repository-names $ECR_REPO_NAME --region $REGION &> /dev/null; then
    echo "✅ ECR repository '$ECR_REPO_NAME' already exists"
else
    aws ecr create-repository --repository-name $ECR_REPO_NAME --region $REGION
    echo "✅ ECR repository '$ECR_REPO_NAME' created"
fi

# Get ECR login command
echo "🔐 Getting ECR login token..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.$REGION.amazonaws.com

# Build and push Docker image
echo "🐳 Building Docker image..."
docker build -t $ECR_REPO_NAME .

echo "📤 Pushing image to ECR..."
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URI="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO_NAME"

docker tag $ECR_REPO_NAME:latest $ECR_URI:latest
docker push $ECR_URI:latest

echo "✅ Image pushed to: $ECR_URI:latest"

# Create App Runner service (optional - can also be done via console)
read -p "🤔 Do you want to create the App Runner service now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🏃 Creating App Runner service..."
    
    # Create service configuration
    cat > apprunner-service.json << EOF
{
    "ServiceName": "$APP_RUNNER_SERVICE_NAME",
    "SourceConfiguration": {
        "ImageRepository": {
            "ImageIdentifier": "$ECR_URI:latest",
            "ImageConfiguration": {
                "Port": "3000",
                "RuntimeEnvironmentVariables": {
                    "NODE_ENV": "production",
                    "PORT": "3000"
                }
            },
            "ImageRepositoryType": "ECR"
        },
        "AutoDeploymentsEnabled": false
    },
    "InstanceConfiguration": {
        "Cpu": "1 vCPU",
        "Memory": "2 GB"
    }
}
EOF

    # Note: This requires additional IAM permissions and role setup
    echo "⚠️  Service configuration created in apprunner-service.json"
    echo "   Please create the service manually via AWS Console or CLI with proper IAM roles"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Go to AWS App Runner console"
echo "2. Create a new service"
echo "3. Choose 'Container image' as source"
echo "4. Use image: $ECR_URI:latest"
echo "5. Configure port: 3000"
echo "6. Add environment variables from .env.apprunner"
echo ""
echo "Or use GitHub integration:"
echo "1. Push this branch to GitHub"
echo "2. Create App Runner service with GitHub source"
echo "3. Select the 'aws-app-runner' branch"
echo ""