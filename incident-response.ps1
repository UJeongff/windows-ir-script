<# 
    Incident Response 초기 수집 스크립트
#>

# 결과 저장 디렉토리 생성
$OutDir = "C:\IR_Collection\$(Get-Date -Format 'yyyyMMdd_HHmmss')"
if (-not (Test-Path $OutDir)) {
    New-Item -ItemType Directory -Path $OutDir | Out-Null
}

# 1. 시스템 정보
systeminfo | Out-File "$OutDir\systeminfo.txt"
Get-HotFix | Out-File "$OutDir\hotfix.txt"

# 2. 실행 중인 프로세스
Get-Process | Sort-Object CPU -Descending | Out-File "$OutDir\processes.txt"

# 3. 네트워크 연결 정보
netstat -ano | Out-File "$OutDir\netstat.txt"
Get-NetTCPConnection | Out-File "$OutDir\tcpconnections.txt"

# 4. 사용자 계정 및 세션
net user | Out-File "$OutDir\net_user.txt"
query user | Out-File "$OutDir\loggedon_users.txt"

# 5. 예약 작업 확인
schtasks /query /fo LIST /v | Out-File "$OutDir\schtasks.txt"

# 6. 서비스 상태
Get-Service | Out-File "$OutDir\services.txt"

# 7. Autoruns (Sysinternals 설치되어 있을 경우)
$autoruns = "C:\Tools\Autoruns64.exe"
if (Test-Path $autoruns) {
    & $autoruns /accepteula /silent /export "$OutDir\autoruns.csv"
}

# 8. 이벤트 로그 (최근 1일)
Get-WinEvent -LogName Security -MaxEvents 2000 | Export-Clixml "$OutDir\security_log.xml"
Get-WinEvent -LogName System -MaxEvents 2000 | Export-Clixml "$OutDir\system_log.xml"

Write-Output "수집 완료: $OutDir 에 저장되었습니다."
