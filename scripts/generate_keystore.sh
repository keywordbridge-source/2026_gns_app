#!/bin/bash
# keystore 생성 스크립트
# Windows에서는 Git Bash나 WSL에서 실행

KEYSTORE_NAME="gns_app_2026.keystore"
KEYSTORE_PATH="android/app/$KEYSTORE_NAME"
KEY_ALIAS="gns_app_2026"
KEY_PASSWORD="your_password_here"  # 실제 비밀번호로 변경 필요
STORE_PASSWORD="your_password_here"  # 실제 비밀번호로 변경 필요

keytool -genkey -v -keystore "$KEYSTORE_PATH" \
  -alias "$KEY_ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storepass "$STORE_PASSWORD" \
  -keypass "$KEY_PASSWORD" \
  -dname "CN=GNS App, OU=Development, O=GetnShow, L=Seoul, ST=Seoul, C=KR"

echo "Keystore created at: $KEYSTORE_PATH"
echo "IMPORTANT: Add this file to .gitignore and never commit it!"
