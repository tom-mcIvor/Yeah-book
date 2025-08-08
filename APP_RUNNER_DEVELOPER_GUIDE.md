# 📖 AWS App Runner Developer Guide - Runtime Versions

## 🔗 **App Runner Developer Guide Location:**
**Official AWS Documentation**: https://docs.aws.amazon.com/apprunner/latest/dg/

## 📋 **Supported Runtime Versions (Node.js):**
According to AWS App Runner documentation, the supported Node.js versions are:

### **Currently Supported:**
- **Node.js 14**: `nodejs14`
- **Node.js 16**: `nodejs16` 
- **Node.js 18**: `nodejs18` (newer regions/updates)

## 🚨 **The Real Issue:**
Even though we removed the runtime specification, App Runner is still detecting a runtime version issue. This suggests:

1. **Auto-detection might be failing**
2. **Our apprunner.yaml format might be incorrect**
3. **We need to specify a known supported version**

## 🔧 **Let's Try a Different Approach:**

### **Option 1: Use Explicit Node.js 16**
```yaml
version: 1.0
runtime: nodejs16
build:
  commands:
    build:
      - npm ci
      - npm run build:client
run:
  runtime-version: 16
  command: npm start
  network:
    port: 3000
    env: PORT
  env:
    - name: NODE_ENV
      value: "production"
    - name: PORT
      value: "3000"
```

### **Option 2: Use Node.js 14 (Most Stable)**
```yaml
version: 1.0
runtime: nodejs14
build:
  commands:
    build:
      - npm ci
      - npm run build:client
run:
  runtime-version: 14
  command: npm start
  network:
    port: 3000
    env: PORT
  env:
    - name: NODE_ENV
      value: "production"
    - name: PORT
      value: "3000"
```

### **Option 3: Minimal Configuration**
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

## 📚 **Key Documentation Links:**

### **Runtime Versions:**
https://docs.aws.amazon.com/apprunner/latest/dg/service-source-code-runtime.html

### **Configuration File Reference:**
https://docs.aws.amazon.com/apprunner/latest/dg/config-file.html

### **Node.js Runtime Guide:**
https://docs.aws.amazon.com/apprunner/latest/dg/service-source-code-nodejs.html

## 🎯 **Recommended Next Step:**
Let's try **Option 2 (Node.js 14)** as it's the most stable and widely supported version in App Runner.

## 🔍 **Why Auto-Detection Failed:**
- App Runner might not be able to determine Node.js version from package.json
- The configuration file format might require explicit runtime specification
- Some regions might have different supported versions

---

## 📖 **Full Developer Guide:**
For complete documentation: https://docs.aws.amazon.com/apprunner/latest/dg/