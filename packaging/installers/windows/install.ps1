$ErrorActionPreference = 'Stop'
$target = Join-Path $env:USERPROFILE '.nellie-code\\bin'
New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item -Force '.\\nellie-code.exe' (Join-Path $target 'nellie-code.exe')
Write-Host "Installed Nellie Code to $target"
