# 🎯 Complete App Runner Configuration Settings

Perfect! I can see you have Node.js 18 selected. Here are the exact values to enter in each field:

## 📋 **Required Changes:**

### **1. Build Command** ⚠️ **CHANGE THIS**
**Current:** `npm install`
**Change to:** `npm ci && npm run build:client`

**Why change?**
- `npm ci` is faster and more reliable for production
- `npm run build:client` builds your React frontend with Webpack
- Your app needs the frontend built before it can serve pages

### **2. Start Command** ⚠️ **CHANGE THIS**
**Current:** `node server.js`
**Change to:** `npm start`

**Why change?**
- Your [`package.json`](package.json:11) defines `"start": "node server"`
- This matches your app's actual structure (server/index.js)

### **3. Port** ✅ **ADD THIS**
**Enter:** `3000`

**Why?**
- Your Express server runs on port 3000
- App Runner needs to know which port to route traffic to

## 🔧 **Summary of All Settings:**

```
✅ Runtime: Nodejs 18 (already selected)
⚠️ Build command: npm ci && npm run build:client
⚠️ Start command: npm start  
⚠️ Port: 3000
```

## 🚀 **After Making These Changes:**
1. Click **Save**
2. App Runner will start a new deployment
3. This time it should build and start successfully!

---

## 🎯 **Quick Action: Update the Build Command, Start Command, and Port fields!**