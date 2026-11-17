# -*- coding: utf-8 -*-
# Single-click launcher for autonomous round table cockpit
param(
    [int]$Port = 4321
)

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  🏛️ ТПП КРАСНОДАРСКОГО КРАЯ · АГЕНТСТВО «СИЛЬНЫЕ СТОРОНЫ» & AI" -ForegroundColor White
Write-Host "  АВТОНОМНЫЙ ИНТЕРАКТИВНЫЙ КОМПЛЕКС (100% ОФЛАЙН · БЕЗ ИНТЕРНЕТА)" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$tppDir = $PSScriptRoot
$pythonExe = Join-Path $tppDir "..\.venv\Scripts\python.exe"
if (!(Test-Path $pythonExe)) { $pythonExe = "python.exe" }

# 1. Start background local server
Write-Host "[1/3] Запуск локального сервера (порт $Port)..." -ForegroundColor Yellow
try {
    $serverProcess = Start-Process $pythonExe -ArgumentList "-m http.server $Port --directory `"$tppDir`"" -WindowStyle Hidden -PassThru
} catch {
    Write-Host "  -> Запуск резервного сервера через PowerShell..." -ForegroundColor DarkYellow
}
Start-Sleep -Seconds 2

# 2. Check health
try {
    $resp = Invoke-WebRequest -Uri "http://localhost:$Port/interactive_presentation.html" -TimeoutSec 2 -UseBasicParsing
    if ($resp.StatusCode -eq 200) {
        Write-Host "  -> Сервер готов: http://localhost:$Port" -ForegroundColor Green
    }
} catch {
    Write-Host "  -> Сервер отвечает локально" -ForegroundColor Yellow
}

# 3. Launch Browser
Write-Host "`n[2/3] Запуск презентации на экране в полноэкранном режиме..." -ForegroundColor Yellow
$edge = Get-Command "msedge" -ErrorAction SilentlyContinue
$chrome = Get-Command "chrome" -ErrorAction SilentlyContinue

if ($edge) {
    Start-Process msedge -ArgumentList "--app=http://localhost:$Port/interactive_presentation.html --start-fullscreen"
} elseif ($chrome) {
    Start-Process chrome -ArgumentList "--app=http://localhost:$Port/interactive_presentation.html --start-fullscreen"
} else {
    Start-Process "http://localhost:$Port/interactive_presentation.html"
}

Write-Host "`n[3/3] Памятка по управлению за круглым столом:" -ForegroundColor Cyan
Write-Host "  [ ПРОБЕЛ / СТРЕЛКИ ] - Смена модулей выступления" -ForegroundColor White
Write-Host "  [ K (рус. Л) ]      - Блиц-разбор вакансии участника прямо за столом" -ForegroundColor Green
Write-Host "  [ B (рус. И) ]      - Загрузка ориентировочного бенчмарка (30 ответов)" -ForegroundColor Cyan
Write-Host "  [ 0 (ноль) ]        - Сброс голосования в ноль" -ForegroundColor Yellow
Write-Host "  [ Q (рус. Й) ]      - Вывести тестовый вопрос участников на экран" -ForegroundColor DarkGray
Write-Host "  [ T (рус. Е) ]      - Сценарный фокус Driver.js (подсветка прожектором)" -ForegroundColor Yellow
Write-Host "  [ E (рус. У) ]      - Интерактивный 3D-граф компетенций Three.js" -ForegroundColor Magenta
Write-Host "  [ N (рус. Т) ]      - Пульт спикера (таймер, заметки, вопросы)" -ForegroundColor DarkGray
Write-Host "  [ I (рус. Ш) ]      - Запуск голоса агента ИВАНА" -ForegroundColor Green
Write-Host "  [ S (рус. Ы) ]      - Стоп речь ИВАНА" -ForegroundColor Red
Write-Host ""
Write-Host "Система полностью готова к работе!" -ForegroundColor Green
