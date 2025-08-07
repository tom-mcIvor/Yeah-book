#!/bin/bash

# AWS Elastic Beanstalk Deployment Script for Yeah-book
# Make sure you have AWS CLI and EB CLI installed

set -e

echo "🚀 Starting deployment to AWS Elastic Beanstalk..."

# Check if EB CLI is installed
if ! command -v eb &> /dev/null; then
    echo "❌ EB CLI is not installed. Please install it first:"
    echo "pip install awsebcli"
    exit 1
fi

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS CLI is not configured. Please run 'aws configure' first."
    exit 1
fi

# Build the application
echo "📦 Building application..."
npm install
npm run build

# Create application bundle
echo "📁 Creating deployment bundle..."
zip -r yeahbook-$(date +%Y%m%d-%H%M%S).zip . \
    -x "node_modules/*" \
    -x ".git/*" \
    -x "*.log" \
    -x ".env" \
    -x "client/node_modules/*" \
    -x "*.test.js" \
    -x "__tests__/*"

echo "✅ Deployment bundle created successfully!"
echo ""
echo "Next steps:"
echo "1. Initialize EB application: eb init"
echo "2. Create environment: eb create production"
echo "3. Deploy: eb deploy"
echo ""
echo "Or run the automated deployment:"
echo "./deploy-auto.sh"