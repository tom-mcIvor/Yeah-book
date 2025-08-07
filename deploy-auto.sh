#!/bin/bash

# Automated AWS Elastic Beanstalk Deployment Script
# This script will initialize and deploy your application automatically

set -e

echo "🚀 Automated AWS Elastic Beanstalk Deployment for Yeah-book"
echo "============================================================"

# Configuration
APP_NAME="yeahbook"
ENVIRONMENT_NAME="yeahbook-production"
REGION="us-east-1"
PLATFORM="Node.js 18 running on 64bit Amazon Linux 2"

# Check prerequisites
echo "🔍 Checking prerequisites..."

if ! command -v eb &> /dev/null; then
    echo "❌ EB CLI is not installed. Installing..."
    pip install awsebcli
fi

if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first:"
    echo "https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    exit 1
fi

if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS CLI is not configured. Please run 'aws configure' first."
    exit 1
fi

# Build application
echo "📦 Building application..."
npm install
npm run build

# Initialize EB application if not already done
if [ ! -f .elasticbeanstalk/config.yml ]; then
    echo "🔧 Initializing Elastic Beanstalk application..."
    eb init $APP_NAME --platform "$PLATFORM" --region $REGION
else
    echo "✅ Elastic Beanstalk already initialized"
fi

# Check if environment exists
if ! eb list | grep -q $ENVIRONMENT_NAME; then
    echo "🌍 Creating Elastic Beanstalk environment..."
    eb create $ENVIRONMENT_NAME --instance-types t3.micro --envvars NODE_ENV=production
else
    echo "✅ Environment $ENVIRONMENT_NAME already exists"
fi

# Deploy application
echo "🚀 Deploying to Elastic Beanstalk..."
eb deploy $ENVIRONMENT_NAME

# Show status
echo "📊 Deployment status:"
eb status $ENVIRONMENT_NAME

echo ""
echo "✅ Deployment completed!"
echo "🌐 Your application should be available at:"
eb open $ENVIRONMENT_NAME --no-browser | grep "http"

echo ""
echo "📝 Next steps:"
echo "1. Set up your RDS database (if using PostgreSQL)"
echo "2. Configure environment variables in EB console"
echo "3. Set up your Auth0 application"
echo "4. Configure your domain (optional)"