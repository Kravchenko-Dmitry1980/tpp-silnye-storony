# -*- coding: utf-8 -*-
# Single-click launcher for autonomous stage cockpit
param(
    [int]$Port = 4321
)

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  🏛️ ТПП КРАСНОДАРСКОГО КРАЯ · АГЕНТСТВО «СИЛЬНЫЕ СТОРОНЫ» & AI" -ForegroundColor White
Write-Host "  АВТОНОМНЫЙ СЦЕНИЧЕСКИЙ КОМПЛЕКС (100% ОФЛАЙН · БЕЗ ИНТЕРНЕТА)" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$tppDir = $PSScriptRoot
$pythonExe = Join-Path $tppDir "..\.venv\Scripts\python.exe"
if (!(Test-Path $pythonExe)) { $pythonExe = "python.exe" }

# 1. Start background local server
Write-Host "[1/3] Запуск локального сервера (порт $Port)..." -ForegroundColor Yellow
$serverProcess = Start-Process $pythonExe -ArgumentList "-m http.server $Port --directory `"$tppDir`"" -WindowStyle Hidden -PassThru
Start-Sleep -Seconds 2

# 2. Check health
try {
    $resp = Invoke-WebRequest -Uri "http://localhost:$Port/interactive_presentation.html" -TimeoutSec 2 -UseBasicParsing
    if ($resp.StatusCode -eq 200) {
        Write-Host "  -> Сервер готов: http://localhost:$Port" -ForegroundColor Green
    }
} catch {
    Write-Host "  -> Сервер инициализирован" -ForegroundColor Yellow
}

# 3. Launch Browser
Write-Host "`n[2/3] Запуск сценического экрана в полноэкранном режиме..." -ForegroundColor Yellow
$edge = Get-Command "msedge" -ErrorAction SilentlyContinue
$chrome = Get-Command "chrome" -ErrorAction SilentlyContinue

if ($edge) {
    Start-Process msedge -ArgumentList "--app=http://localhost:$Port/interactive_presentation.html --start-fullscreen"
} elseif ($chrome) {
    Start-Process chrome -ArgumentList "--app=http://localhost:$Port/interactive_presentation.html --start-fullscreen"
} else {
    Start-Process "http://localhost:$Port/interactive_presentation.html"
}

Write-Host "`n[3/3] Памятка по сценическому управлению:" -ForegroundColor Cyan
Write-Host "  [ ПРОБЕЛ ]  - Открытие сессии / Шаг сценарного фокуса" -ForegroundColor White
Write-Host "  [ СТРЕЛКИ ] - Смена модулей (1-6)" -ForegroundColor White
Write-Host "  [ T ]       - Сценарный фокус Driver.js" -ForegroundColor Yellow
Write-Host "  [ G ]       - Включение / выключение жестов веб-камеры" -ForegroundColor Mint
Write-Host "  [ E ]       - 3D-Карта компетенций Three.js" -ForegroundColor Magenta
Write-Host "  [ I ]       - Запуск речи ИВАНА (ElevenLabs)" -ForegroundColor Green
Write-Host "  [ S ]       - Стоп речь ИВАНА" -ForegroundColor Red
Write-Host "  [ N ]       - Суфлер спикера" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Система работает полностью автономно без подключения к интернету." -ForegroundColor Green
