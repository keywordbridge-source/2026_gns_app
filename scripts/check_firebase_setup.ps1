# Firebase 설정 확인 스크립트

Write-Host "Firebase 설정 확인 중..." -ForegroundColor Cyan

# 1. google-services.json 확인
$googleServicesPath = "android\app\google-services.json"
if (Test-Path $googleServicesPath) {
    Write-Host "✓ google-services.json 파일 존재" -ForegroundColor Green
} else {
    Write-Host "✗ google-services.json 파일 없음" -ForegroundColor Red
    Write-Host "  Firebase Console에서 다운로드하여 android/app/ 디렉토리에 배치하세요" -ForegroundColor Yellow
}

# 2. firebase_options.dart 확인
$firebaseOptionsPath = "lib\firebase_options.dart"
$firebaseOptionsContent = if (Test-Path $firebaseOptionsPath) { Get-Content $firebaseOptionsPath -Raw } else { "" }

if ($firebaseOptionsContent -match "DefaultFirebaseOptions" -and $firebaseOptionsContent -notmatch "YOUR_API_KEY") {
    Write-Host "✓ firebase_options.dart 파일 존재 및 설정됨" -ForegroundColor Green
} elseif (Test-Path $firebaseOptionsPath) {
    Write-Host "⚠ firebase_options.dart 파일 존재하지만 설정이 완료되지 않음" -ForegroundColor Yellow
    Write-Host "  flutterfire configure 실행 필요" -ForegroundColor Yellow
} else {
    Write-Host "✗ firebase_options.dart 파일 없음" -ForegroundColor Red
    Write-Host "  flutterfire configure 실행 필요" -ForegroundColor Yellow
}

# 3. Firebase CLI 확인
$firebaseCmd = Get-Command firebase -ErrorAction SilentlyContinue
if ($firebaseCmd) {
    Write-Host "✓ Firebase CLI 설치됨" -ForegroundColor Green
} else {
    Write-Host "✗ Firebase CLI 미설치" -ForegroundColor Red
    Write-Host "  npm install -g firebase-tools 실행 필요" -ForegroundColor Yellow
}

# 4. FlutterFire CLI 확인
$flutterfireCmd = Get-Command flutterfire -ErrorAction SilentlyContinue
if ($flutterfireCmd) {
    Write-Host "✓ FlutterFire CLI 설치됨" -ForegroundColor Green
} else {
    Write-Host "⚠ FlutterFire CLI 확인 불가 (PATH 문제일 수 있음)" -ForegroundColor Yellow
}

Write-Host "`n확인 완료!" -ForegroundColor Cyan
