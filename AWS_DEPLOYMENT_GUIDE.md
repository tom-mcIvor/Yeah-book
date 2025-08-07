# AWS Deployment Guide for Yeah-book

This guide will help you deploy your Yeah-book application to AWS using Elastic Beanstalk.

## Prerequisites

1. **AWS Account**: Create an AWS account if you don't have one
2. **AWS CLI**: Install and configure AWS CLI

   ```bash
   # Install AWS CLI
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install

   # Configure AWS CLI
   aws configure
   ```

3. **EB CLI**: Install Elastic Beanstalk CLI
   
   **APT** stands for "Advanced Package Tool" - it's the package manager for Ubuntu/Debian Linux systems.
   
   **Method A: Using pipx (Recommended)**
   ```bash
   # Install pipx using apt (Advanced Package Tool)
   sudo apt install pipx
   pipx install awsebcli
   
   # Add pipx binaries to PATH (add to ~/.bashrc or ~/.zshrc)
   export PATH="$HOME/.local/bin:$PATH"
   source ~/.bashrc  # or ~/.zshrc
   ```
   
   **Method B: Using virtual environment**
   ```bash
   # Create virtual environment
   python3 -m venv ~/eb-cli-venv
   source ~/eb-cli-venv/bin/activate
   pip install awsebcli
   
   # To use EB CLI later, always activate the virtual environment first:
   # source ~/eb-cli-venv/bin/activate
   ```
   
   **Method C: Using apt directly**
   ```bash
   # Install from Ubuntu/Debian repositories (may be older version)
   sudo apt update
   sudo apt install awsebcli
   ```

## Deployment Options

### Option 1: Automated Deployment (Recommended)

Run the automated deployment script:

```bash
./deploy-auto.sh
```

This script will:

- Build your application
- Initialize Elastic Beanstalk
- Create the environment
- Deploy your application

### Option 2: Manual Deployment

1. **Build the application**:

   ```bash
   npm install
   npm run build
   ```

2. **Initialize Elastic Beanstalk**:

   ```bash
   eb init yeahbook --platform "Node.js 18 running on 64bit Amazon Linux 2" --region us-east-1
   ```

3. **Create environment**:

   ```bash
   eb create yeahbook-production --instance-types t3.micro
   ```

4. **Deploy**:
   ```bash
   eb deploy
   ```

## Database Setup

### Option A: PostgreSQL on AWS RDS (Recommended for Production)

1. **Create RDS Instance**:

   - Go to AWS RDS Console
   - Create PostgreSQL database
   - Choose appropriate instance size (db.t3.micro for testing)
   - Note the endpoint, username, and password

2. **Update Environment Variables**:

   ```bash
   eb setenv DB_HOST=your-rds-endpoint.region.rds.amazonaws.com \
            DB_PORT=5432 \
            DB_USER=postgres \
            DB_PASSWORD=your-password \
            DB_NAME=yeahbook_prod
   ```

3. **Run Migrations**:
   ```bash
   eb ssh
   cd /var/app/current
   npm run migrate
   npm run seed
   ```

### Option B: SQLite (Simple but not recommended for production)

The application will use SQLite by default. Change the knexfile.js to use `production_sqlite` configuration.

## Environment Variables Configuration

Set the following environment variables in your Elastic Beanstalk environment:

```bash
eb setenv NODE_ENV=production \
         PORT=8081 \
         AUTH0_DOMAIN=your-auth0-domain.auth0.com \
         AUTH0_CLIENT_ID=your-auth0-client-id \
         AUTH0_CLIENT_SECRET=your-auth0-client-secret \
         JWT_SECRET=your-jwt-secret \
         SECRET_API_KEY=your-secret-api-key
```

## Auth0 Configuration

1. **Create Auth0 Application**:

   - Go to Auth0 Dashboard
   - Create a new Single Page Application
   - Note the Domain, Client ID, and Client Secret

2. **Configure Callback URLs**:

   - Add your Elastic Beanstalk URL to allowed callback URLs
   - Format: `https://your-app-name.region.elasticbeanstalk.com/callback`

3. **Configure Logout URLs**:
   - Add your Elastic Beanstalk URL to allowed logout URLs
   - Format: `https://your-app-name.region.elasticbeanstalk.com`

## File Upload Configuration

### Option A: Local Storage (Default)

Files are stored in the `/var/app/current/storage/images` directory.

### Option B: AWS S3 (Recommended for Production)

1. **Create S3 Bucket**:

   ```bash
   aws s3 mb s3://your-yeahbook-uploads-bucket
   ```

2. **Set Environment Variables**:

   ```bash
   eb setenv AWS_S3_BUCKET=your-yeahbook-uploads-bucket \
            AWS_REGION=us-east-1
   ```

3. **Update IAM Role**: Ensure your EB instance role has S3 permissions.

## Monitoring and Logs

1. **View Application Logs**:

   ```bash
   eb logs
   ```

2. **Monitor Application**:

   ```bash
   eb health
   eb status
   ```

3. **SSH into Instance**:
   ```bash
   eb ssh
   ```

## Custom Domain (Optional)

1. **Purchase Domain**: Use Route 53 or external provider
2. **Create SSL Certificate**: Use AWS Certificate Manager
3. **Configure Load Balancer**: Add HTTPS listener with SSL certificate
4. **Update DNS**: Point domain to EB environment

## Scaling and Performance

1. **Auto Scaling**:

   ```bash
   eb config
   # Edit auto scaling settings in the configuration file
   ```

2. **Instance Types**:
   - Development: t3.micro
   - Production: t3.small or larger

## Troubleshooting

### Common Issues:

1. **Build Failures**:

   - Check that all dependencies are in `dependencies` not `devDependencies`
   - Ensure Node.js version compatibility

2. **Database Connection Issues**:

   - Verify RDS security group allows connections from EB
   - Check environment variables are set correctly

3. **File Upload Issues**:

   - Ensure storage directories have correct permissions
   - Check if using S3, verify IAM permissions

4. **Auth0 Issues**:
   - Verify callback URLs match exactly
   - Check environment variables are set

### Useful Commands:

```bash
# View environment info
eb status

# View recent logs
eb logs

# Open application in browser
eb open

# Terminate environment (careful!)
eb terminate

# List all environments
eb list
```

## AWS Deployment Costs

### Free Tier Eligible (First 12 months)
If you're within your first 12 months of AWS, you can deploy for **FREE** using:

- **EC2 t3.micro**: 750 hours/month (enough for 1 instance running 24/7)
- **RDS db.t3.micro**: 750 hours/month + 20GB storage
- **Application Load Balancer**: 750 hours/month
- **S3**: 5GB storage + 20,000 GET requests + 2,000 PUT requests

### Estimated Monthly Costs (After Free Tier)

**Minimal Setup (Recommended for testing):**
- **Elastic Beanstalk**: Free (you only pay for underlying resources)
- **EC2 t3.micro**: ~$8.50/month
- **Application Load Balancer**: ~$16/month
- **RDS db.t3.micro**: ~$12/month
- **S3 storage**: ~$1/month (for 10GB)
- **Data transfer**: ~$1-5/month
- **Total**: ~$38-42/month

**Production Setup:**
- **EC2 t3.small** (2 instances): ~$34/month
- **Application Load Balancer**: ~$16/month
- **RDS db.t3.small**: ~$25/month
- **S3 storage**: ~$2-5/month
- **CloudFront CDN**: ~$1-10/month
- **Total**: ~$78-90/month

### Cost Optimization Tips

1. **Start with t3.micro** instances (free tier eligible)
2. **Use SQLite instead of RDS** for development (saves ~$12/month)
3. **Set up auto-scaling** to scale down during low usage
4. **Use spot instances** for non-critical workloads (up to 90% savings)
5. **Monitor costs** in AWS Cost Explorer
6. **Set up billing alerts** to avoid surprises
7. **Use S3 Intelligent Tiering** for file storage
8. **Enable CloudWatch detailed monitoring** only when needed

### Alternative: Cheaper Options

**AWS Lightsail** (Simpler, fixed pricing):
- **$3.50/month**: 512MB RAM, 1 vCPU, 20GB SSD
- **$5/month**: 1GB RAM, 1 vCPU, 40GB SSD
- **$10/month**: 2GB RAM, 1 vCPU, 60GB SSD

**Other Platforms** (Consider these alternatives):
- **Heroku**: $7/month (Hobby tier)
- **Railway**: $5/month
- **Render**: $7/month
- **DigitalOcean App Platform**: $5/month
- **Vercel + PlanetScale**: $0-20/month

## Security Best Practices

1. **Use HTTPS** (configure SSL certificate)
2. **Secure environment variables** (never commit secrets)
3. **Regular security updates** (keep dependencies updated)
4. **Database security** (use strong passwords, restrict access)
5. **IAM roles** (principle of least privilege)

## Backup Strategy

1. **Database Backups**: Enable automated RDS backups
2. **Application Code**: Use Git for version control
3. **User Uploads**: If using S3, enable versioning

---

## Quick Start Commands

```bash
# 1. Install dependencies
npm install

# 2. Configure AWS
aws configure

# 3. Deploy automatically
./deploy-auto.sh

# 4. Set environment variables
eb setenv NODE_ENV=production AUTH0_DOMAIN=your-domain.auth0.com

# 5. Open your application
eb open
```

For support, check the AWS Elastic Beanstalk documentation or create an issue in the project repository.
