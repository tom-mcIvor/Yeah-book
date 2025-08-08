# 🔧 Configure Build - Step 2

## 📍 **Current Page: Configure Build**
You're on Step 2 and I can see the build configuration options.

## ✅ **What to Click/Change:**

### **1. Configuration File (IMPORTANT)**
**Click "Use a configuration file"** (the right option) instead of "Configure all settings here"

**Why?** We created an `apprunner.yaml` file that has all the correct build settings for your app.

### **2. Fix the Port**
I can see the port is set to `8080` - **change this to `3000`**
- **Click in the Port field**
- **Delete `8080`**
- **Type `3000`**

## 🎯 **Correct Settings Should Be:**
- ✅ **Configuration file**: "Use a configuration file" (right option)
- ✅ **Port**: `3000` (not 8080)

## 🚀 **After Making Changes:**
**Click the orange "Next" button** to continue to Step 3.

## 📋 **Why These Settings:**
- **Configuration file**: Our `apprunner.yaml` contains the correct build commands (`npm ci && npm run build:client`)
- **Port 3000**: Your Node.js app runs on port 3000 (as defined in your code)

---

## 👆 **Actions to Take:**
1. **Click "Use a configuration file"** (right option)
2. **Change port from 8080 to 3000**
3. **Click "Next"**