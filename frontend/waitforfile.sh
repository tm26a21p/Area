#!/bin/sh

if test -f $1; then
    echo "$1 exists."
fi

until test -f $1; do
  echo "$1 is unavailable"
  sleep 20
done
echo "$1 EXISTS"
echo "Copying APK to FrontWeb public folder..."
cp /frontend/area/build/app/outputs/flutter-apk/app-release.apk /app/public/
echo "renaming APK..."
mv /app/public/app-release.apk /app/public/app.apk
echo "Launching FrontWeb..."
npm run serve