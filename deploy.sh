#!/bin/bash

# Script to build and deploy Flutter web app with privacy policy

echo "Building Flutter web app..."
flutter build web

echo "Copying privacy policy to build directory..."
cp public/privacy-policy.html build/web/

echo "Deploying to Firebase Hosting..."
firebase deploy --only hosting

echo "Deployment complete!"
echo "Admin Panel: https://adhikarnotification.web.app"
echo "Privacy Policy: https://adhikarnotification.web.app/privacy-policy"
