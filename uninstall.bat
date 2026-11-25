@echo off
chcp 65001 >nul
title O'zbek klaviatura - o'chirish

echo Dastur to'xtatilmoqda...
taskkill /f /im UzKeyboard.exe >nul 2>nul
powershell -NoProfile -Command "Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*uzbek_keyboard*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }" >nul 2>nul
timeout /t 2 /nobreak >nul

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v UzbekKeyboard /f >nul 2>nul

set "DEST=%LOCALAPPDATA%\UzKeyboard"
if exist "%DEST%" rmdir /s /q "%DEST%"
if exist "%DEST%" (
    echo Ogohlantirish: %DEST% papkasini to'liq o'chirib bo'lmadi. Kompyuterni qayta ishga tushirib, qayta urinib ko'ring.
) else (
    echo O'chirish tugadi.
)
pause
