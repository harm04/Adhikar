#!/bin/bash

# Build and Deploy Legal Pages Script
# This script builds the Flutter web app and deploys to Firebase Hosting

echo "🔧 Building Flutter web app..."
flutter build web

echo "📄 Copying legal pages to build directory..."
cp public/privacy-policy.html build/web/
cp public/terms-of-service.html build/web/

echo "🚀 Deploying to Firebase Hosting..."
firebase deploy --only hosting

echo "✅ Deployment complete!"
echo "🌐 Privacy Policy URL: https://adhikarnotification.web.app/privacy-policy"
echo "🌐 Terms of Service URL: https://adhikarnotification.web.app/terms-of-service"
