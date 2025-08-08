# 📋 Your Current AWS App Runner Deployment Setup

## 🏗️ **Application Architecture:**

### **Frontend:**
- **Framework**: React 17.0.1
- **Build Tool**: Webpack 5.75.0
- **Styling**: SCSS, Material-UI, Mantine
- **State Management**: Redux with Redux Thunk

### **Backend:**
- **Runtime**: Node.js/Express.js
- **Authentication**: Auth0 integration
- **File Uploads**: Multer middleware
- **API**: RESTful endpoints for books, profiles, comments

### **Database:**
- **Current**: SQLite with Knex.js ORM
- **Location**: Local file system (`/app/storage/dev.sqlite3`)
- **Issue**: Ephemeral in App Runner (data lost on redeploy)

### **File Storage:**
- **Current**: Local file system (`/storage/images`, `/server/public/images`)
- **Issue**: Ephemeral in App Runner (files lost on redeploy)

## 🚀 **AWS App Runner Configuration:**

### **Service Details:**
- **Service Name**: `yeah-book-app`
- **Region**: us-east-1
- **Account**: 122881847754
- **User**: yeahbook-deploy

### **GitHub Integration:**
- **Repository**: `tom-/Yeah-book`
- **Branch**: `aws-app-runner`
- **Connection**: `yeah-book-github` (Available)
- **Auto-deployment**: Enabled

### **Current Configuration File (`apprunner.yaml`):**
```yaml
version: 1.0
runtime: nodejs16
build:
  commands:
    build:
      - npm ci
      - npm run build:client
run:
  command: npm start
  network:
    port: 3000
```

### **Build Process:**
1. **Install dependencies**: `npm ci`
2. **Build React app**: `npm run build:client` (creates bundle.js)
3. **Start server**: `npm start` (Express server on port 3000)

## 🔧 **Infrastructure Setup:**

### **AWS Resources Created:**
- ✅ **ECR Repository**: `yeah-book` (122881847754.dkr.ecr.us-east-1.amazonaws.com/yeah-book)
- ✅ **GitHub Connection**: `yeah-book-github`
- ✅ **App Runner Service**: `yeah-book-app`

### **Compute Resources:**
- **CPU**: 1 vCPU
- **Memory**: 2 GB
- **Auto-scaling**: Enabled
- **Health checks**: Automatic

### **Networking:**
- **Port**: 3000
- **Protocol**: HTTP
- **Load Balancer**: Automatic (provided by App Runner)
- **SSL/TLS**: Automatic HTTPS

## 📁 **Project Structure:**
```
Yeah-book/
├── client/                 # React frontend
│   ├── components/        # React components
│   ├── actions/          # Redux actions
│   ├── reducers/         # Redux reducers
│   ├── styles/           # SCSS styles
│   └── webpack.config.js # Build configuration
├── server/               # Express backend
│   ├── routes/          # API routes
│   ├── db/              # Database & migrations
│   ├── public/          # Static files
│   └── index.js         # Server entry point
├── storage/             # File uploads (ephemeral)
├── apprunner.yaml       # App Runner configuration
└── package.json         # Dependencies & scripts
```

## 🔄 **Deployment Pipeline:**

### **Current Flow:**
1. **Code changes** pushed to `aws-app-runner` branch
2. **App Runner detects** changes via GitHub webhook
3. **Downloads source** from GitHub
4. **Reads** `apprunner.yaml` configuration
5. **Builds application** using specified commands
6. **Starts server** and performs health checks
7. **Routes traffic** to new deployment

### **Current Issue:**
- **Runtime version error**: "The specified runtime version is not supported"
- **Multiple attempts**: nodejs18 → nodejs16 → nodejs14 → minimal config
- **Status**: Still troubleshooting

## 🌐 **Access Points:**

### **AWS Console:**
- **App Runner**: https://console.aws.amazon.com/apprunner/home?region=us-east-1#/services
- **Service URL**: Will be `https://[random-id].us-east-1.awsapprunner.com` when working

### **GitHub:**
- **Repository**: https://github.com/tom-mcIvor/Yeah-book
- **Branch**: https://github.com/tom-mcIvor/Yeah-book/tree/aws-app-runner

## ⚠️ **Current Limitations:**

### **Data Persistence:**
- **SQLite database**: Lost on each deployment
- **Uploaded files**: Lost on each deployment
- **Solution needed**: Migrate to RDS + S3

### **Environment Variables:**
- **Currently**: Hardcoded in apprunner.yaml
- **Missing**: Auth0 credentials, database URLs

## 🎯 **Next Steps:**
1. **Resolve runtime issue** (in progress)
2. **Get basic deployment working**
3. **Migrate to RDS** for persistent data
4. **Migrate to S3** for file storage
5. **Add environment variables** for configuration