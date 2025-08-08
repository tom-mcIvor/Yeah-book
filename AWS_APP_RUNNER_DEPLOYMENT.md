# AWS App Runner Deployment Guide

This guide will help you deploy the Yeah-book application to AWS App Runner.

## Prerequisites

1. AWS CLI installed and configured
2. AWS account with appropriate permissions
3. GitHub repository with the code

## Deployment Options

### Option 1: Direct GitHub Integration (Recommended)

AWS App Runner can automatically deploy from your GitHub repository.

#### Steps:

1. **Push this branch to GitHub:**
   ```bash
   git add .
   git commit -m "Add AWS App Runner configuration"
   git push origin aws-app-runner
   ```

2. **Create App Runner Service via AWS Console:**
   - Go to AWS App Runner console
   - Click "Create service"
   - Choose "Source code repository"
   - Connect to GitHub and select your repository
   - Choose branch: `aws-app-runner`
   - Configure build settings:
     - Runtime: Node.js 18
     - Build command: `npm ci && npm run build:client`
     - Start command: `npm start`
     - Port: 3000

3. **Environment Variables:**
   Set these in the App Runner console:
   ```
   NODE_ENV=production
   PORT=3000
   ```

### Option 2: Container Image Deployment

Use the provided Dockerfile for more control.

#### Steps:

1. **Build and push to ECR:**
   ```bash
   # Create ECR repository
   aws ecr create-repository --repository-name yeah-book

   # Get login token
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

   # Build image
   docker build -t yeah-book .

   # Tag image
   docker tag yeah-book:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/yeah-book:latest

   # Push image
   docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/yeah-book:latest
   ```

2. **Create App Runner service:**
   - Choose "Container image"
   - Select your ECR image
   - Configure port: 3000

## Configuration Files

### apprunner.yaml
- Defines build and runtime configuration
- Used for source code deployments

### Dockerfile
- Container configuration
- Used for container image deployments

### .dockerignore
- Optimizes Docker build by excluding unnecessary files

## Database Considerations

### Current Setup (SQLite)
- SQLite files are ephemeral in App Runner
- Data will be lost on each deployment
- Suitable only for development/testing

### Production Recommendations
1. **Migrate to RDS PostgreSQL:**
   ```javascript
   // Update knexfile.js production config
   production: {
     client: 'postgresql',
     connection: {
       host: process.env.RDS_HOSTNAME,
       database: process.env.RDS_DB_NAME,
       user: process.env.RDS_USERNAME,
       password: process.env.RDS_PASSWORD,
       port: process.env.RDS_PORT || 5432,
     }
   }
   ```

2. **Add environment variables in App Runner:**
   ```
   RDS_HOSTNAME=your-rds-endpoint
   RDS_DB_NAME=yeahbook
   RDS_USERNAME=your-username
   RDS_PASSWORD=your-password
   RDS_PORT=5432
   ```

## File Storage

### Current Setup (Local Storage)
- Files stored in `/storage/images` are ephemeral
- Will be lost on deployment

### Production Recommendations
1. **Migrate to S3:**
   - Update file upload logic to use AWS SDK
   - Store files in S3 bucket
   - Use CloudFront for CDN

2. **Environment variables:**
   ```
   AWS_S3_BUCKET=your-bucket-name
   AWS_REGION=us-east-1
   ```

## Auto-Deployment Setup

App Runner can automatically deploy when you push to the connected branch:

1. **Enable automatic deployments** in App Runner console
2. **Push changes** to the `aws-app-runner` branch
3. **App Runner will automatically build and deploy**

## Monitoring and Logs

- **Logs:** Available in App Runner console and CloudWatch
- **Metrics:** CPU, memory, and request metrics in CloudWatch
- **Health checks:** Automatic health monitoring

## Cost Estimation

- **App Runner:** ~$25-50/month for small applications
- **RDS (if used):** ~$15-20/month for db.t3.micro
- **S3 + CloudFront:** ~$1-5/month

## Troubleshooting

### Common Issues:

1. **Build failures:**
   - Check build logs in App Runner console
   - Ensure all dependencies are in package.json

2. **Application not starting:**
   - Verify start command: `npm start`
   - Check that port 3000 is exposed

3. **Database connection issues:**
   - Verify RDS security groups allow App Runner access
   - Check environment variables

### Useful Commands:

```bash
# Test Docker build locally
docker build -t yeah-book .
docker run -p 3000:3000 yeah-book

# Check App Runner service status
aws apprunner describe-service --service-arn <service-arn>

# View logs
aws logs describe-log-groups --log-group-name-prefix "/aws/apprunner"
```

## Next Steps

1. Deploy using Option 1 (GitHub integration)
2. Test the application
3. Plan database migration to RDS
4. Implement S3 file storage
5. Set up custom domain (optional)

For production use, consider migrating the database and file storage as outlined above.