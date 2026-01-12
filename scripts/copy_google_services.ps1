# google-services.json 파일을 자동으로 복사하는 스크립트
# 사용법: 이 파일을 우클릭 → "PowerShell로 실행"

Write-Host "`n=== google-services.json 파일 복사 도우미 ===" -ForegroundColor Cyan
Write-Host ""

# 다운로드 폴더 경로
$downloadsPath = "$env:USERPROFILE\Downloads"
$targetPath = "$PSScriptRoot\..\android\app\google-services.json"
$sourceFile = Join-Path $downloadsPath "google-services.json"

Write-Host "1. 다운로드 폴더에서 파일 찾는 중..." -ForegroundColor Yellow

if (Test-Path $sourceFile) {
    Write-Host "   ✓ 파일을 찾았습니다: $sourceFile" -ForegroundColor Green
    
    Write-Host "`n2. 앱 폴더로 복사 중..." -ForegroundColor Yellow
    
    # 대상 폴더가 없으면 생성
    $targetDir = Split-Path $targetPath -Parent
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    
    # 파일 복사
    Copy-Item -Path $sourceFile -Destination $targetPath -Force
    
    if (Test-Path $targetPath) {
        Write-Host "   ✓ 복사 완료!" -ForegroundColor Green
        Write-Host "   파일 위치: $targetPath" -ForegroundColor Cyan
    } else {
        Write-Host "   ✗ 복사 실패" -ForegroundColor Red
    }
} else {
    Write-Host "   ✗ 다운로드 폴더에서 파일을 찾을 수 없습니다." -ForegroundColor Red
    Write-Host "`n다음 단계:" -ForegroundColor Yellow
    Write-Host "1. Firebase Console에서 google-services.json 다운로드" -ForegroundColor White
    Write-Host "2. 다운로드 폴더에 파일이 있는지 확인" -ForegroundColor White
    Write-Host "3. 이 스크립트를 다시 실행" -ForegroundColor White
    Write-Host "`n또는 수동으로:" -ForegroundColor Yellow
    Write-Host "다운로드한 파일을 다음 위치로 복사하세요:" -ForegroundColor White
    Write-Host $targetPath -ForegroundColor Cyan
}

Write-Host "`n완료!" -ForegroundColor Green
Write-Host "아무 키나 누르면 종료됩니다..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
