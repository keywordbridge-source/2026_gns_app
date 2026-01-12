@echo off
REM keystore 생성 스크립트 (Windows)
REM keytool이 PATH에 있어야 함

set KEYSTORE_NAME=gns_app_2026.keystore
set KEYSTORE_PATH=android\app\%KEYSTORE_NAME%
set KEY_ALIAS=gns_app_2026
set KEY_PASSWORD=your_password_here
set STORE_PASSWORD=your_password_here

keytool -genkey -v -keystore "%KEYSTORE_PATH%" ^
  -alias "%KEY_ALIAS%" ^
  -keyalg RSA ^
  -keysize 2048 ^
  -validity 10000 ^
  -storepass "%STORE_PASSWORD%" ^
  -keypass "%KEY_PASSWORD%" ^
  -dname "CN=GNS App, OU=Development, O=GetnShow, L=Seoul, ST=Seoul, C=KR"

echo Keystore created at: %KEYSTORE_PATH%
echo IMPORTANT: Add this file to .gitignore and never commit it!
pause
