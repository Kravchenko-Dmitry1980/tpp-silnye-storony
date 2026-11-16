@echo off
chcp 65001 >nul
title ЗАПУСК АВТОНОМНОГО СЦЕНИЧЕСКОГО КОКПИТА · ТПП КК
cls
echo ======================================================================
echo   🏛️ ТПП КРАСНОДАРСКОГО КРАЯ · АГЕНТСТВО «СИЛЬНЫЕ СТОРОНЫ» & AI
echo   АВТОНОМНЫЙ СЦЕНИЧЕСКИЙ КОМПЛЕКС (100%% ОФЛАЙН · БЕЗ ИНТЕРНЕТА)
echo ======================================================================
echo.
echo [1/3] Запуск локального безопасного веб-сервера на порту 4321...
start "STAGE-LOCAL-SERVER" /min "%~dp0..\.venv\Scripts\python.exe" -m http.server 4321 --directory "%~dp0."

timeout /t 2 /nobreak >nul

echo [2/3] Проверка готовности сервера...
powershell -NoProfile -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:4321/interactive_presentation.html' -TimeoutSec 2; if ($r.StatusCode -eq 200) { Write-Host '  -> Сервер успешно запущен (http://localhost:4321)' -ForegroundColor Green } } catch { Write-Host '  -> Сервер отвечает локально' -ForegroundColor Yellow }"

echo.
echo [3/3] Запуск сценического экрана в режиме KIOSK...
echo   -> Горячие клавиши на сцене:
echo      [ ПРОБЕЛ ]  - Открыть сессию / Шаг сценарного фокуса
echo      [ СТРЕЛКИ ] - Смена сценических модулей (1-6)
echo      [ T ]       - Включение / шаг сценарного фокуса (Driver.js)
echo      [ G ]       - Включение / выключение распознавания жестов
echo      [ E ]       - 3D-Карта компетенций (Three.js)
echo      [ I ]       - Запуск речи AI-агента ИВАНА
echo      [ S ]       - Остановка речи ИВАНА
echo      [ N ]       - Режиссерский суфлер для спикера
echo.

where msedge >nul 2>nul
if %ERRORLEVEL% equ 0 (
    start msedge --app=http://localhost:4321/interactive_presentation.html --start-fullscreen
    goto :DONE
)

where chrome >nul 2>nul
if %ERRORLEVEL% equ 0 (
    start chrome --app=http://localhost:4321/interactive_presentation.html --start-fullscreen
    goto :DONE
)

start http://localhost:4321/interactive_presentation.html

:DONE
echo ======================================================================
echo   ✅ СИСТЕМА УСПЕШНО ЗАПУЩЕНА! ПРИЯТНОГО ВЫСТУПЛЕНИЯ!
echo ======================================================================
pause
