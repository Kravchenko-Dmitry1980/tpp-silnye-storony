@echo off
chcp 65001 >nul
title ЗАПУСК АВТОНОМНОГО СЦЕНИЧЕСКОГО КОМПЛЕКСА · ТПП КК
cls
echo ======================================================================
echo   🏛️ ТПП КРАСНОДАРСКОГО КРАЯ · АГЕНТСТВО «СИЛЬНЫЕ СТОРОНЫ» & AI
echo   АВТОНОМНЫЙ ИНТЕРАКТИВНЫЙ КОМПЛЕКС (100%% ОФЛАЙН · БЕЗ ИНТЕРНЕТА)
echo ======================================================================
echo.

set "PORT=4321"
set "PYTHON_EXE="

if exist "%~dp0..\.venv\Scripts\python.exe" (
    set "PYTHON_EXE=%~dp0..\.venv\Scripts\python.exe"
) else (
    where python >nul 2>nul
    if %ERRORLEVEL% equ 0 (
        set "PYTHON_EXE=python"
    )
)

if not "%PYTHON_EXE%"=="" (
    echo [1/3] Запуск локального безопасного веб-сервера на порту %PORT%...
    start "ROUNDTABLE-LOCAL-SERVER" /min "%PYTHON_EXE%" -m http.server %PORT% --directory "%~dp0."
    timeout /t 2 /nobreak >nul
) else (
    echo [1/3] Запуск через встроенный сервис PowerShell...
    start "ROUNDTABLE-LOCAL-SERVER" /min powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-Location '%~dp0'; $l=New-Object System.Net.HttpListener; $l.Prefixes.Add('http://+:%PORT%/'); try{$l.Start()}catch{$l.Prefixes.Clear(); $l.Prefixes.Add('http://localhost:%PORT%/'); $l.Start()}; while($l.IsListening){ $c=$l.GetContext(); $r=$c.Request; $res=$c.Response; $p=Join-Path (Get-Location) ($r.Url.LocalPath.TrimStart('/')); if(-not (Test-Path $p -PathType Leaf)){$p=Join-Path (Get-Location) 'interactive_presentation.html'}; $b=[System.IO.File]::ReadAllBytes($p); $res.ContentLength64=$b.Length; $res.OutputStream.Write($b,0,$b.Length); $res.OutputStream.Close() }"
    timeout /t 2 /nobreak >nul
)

echo.
echo [2/3] Памятка управления за круглым столом:
echo   [ ПРОБЕЛ / СТРЕЛКИ ] - Смена модулей выступления
echo   [ K (рус. Л) ]      - Блиц-разбор вакансии участника прямо за столом
echo   [ B (рус. И) ]      - Загрузка ориентировочного бенчмарка (30 ответов)
echo   [ 0 (ноль) ]        - Сброс голосования в ноль
echo   [ Q (рус. Й) ]      - Вывести тестовый вопрос участников на экран
echo   [ T (рус. Е) ]      - Сценарный фокус (подсветка прожектором)
echo   [ E (рус. У) ]      - Интерактивный 3D-граф компетенций (Three.js)
echo   [ N (рус. Т) ]      - Пульт спикера (таймер регламента, заметки, вопросы)
echo   [ I (рус. Ш) ]      - Запуск голоса агента ИВАНА
echo   [ S (рус. Ы) ]      - Остановка речи ИВАНА
echo   [ F (рус. А) ]      - Полный экран (Fullscreen)
echo.

echo [3/3] Запуск презентации на экране в режиме KIOSK...
where msedge >nul 2>nul
if %ERRORLEVEL% equ 0 (
    start msedge --app=http://localhost:%PORT%/interactive_presentation.html --start-fullscreen
    goto :DONE
)

where chrome >nul 2>nul
if %ERRORLEVEL% equ 0 (
    start chrome --app=http://localhost:%PORT%/interactive_presentation.html --start-fullscreen
    goto :DONE
)

start http://localhost:%PORT%/interactive_presentation.html

:DONE
echo ======================================================================
echo   ✅ КОМПЛЕКС ГОТОВ К РАБОТЕ! УДАЧНОГО ПРОВЕДЕНИЯ КРУГЛОГО СТОЛА!
echo ======================================================================
pause
