@echo off
chcp 65001 >nul
title O'zbek klaviatura - o'rnatish

set "DEST=%LOCALAPPDATA%\UzKeyboard"

echo ==============================================================
echo  O'zbek klaviatura - o'rnatish
echo ==============================================================
echo  Bu dastur:
echo    - klaviatura tugmalarini kuzatadi (o', g', sh, ch uchun);
echo    - kompyuter yonganda avtomatik ishga tushadi;
echo    - %DEST% papkasiga o'rnatiladi.
echo  O'chirish: uninstall.bat yoki Ctrl+Alt+U bilan o'chirib yoqish.
echo ==============================================================
echo.
choice /c YN /m "Davom etasizmi"
if errorlevel 2 (
    echo Bekor qilindi.
    pause
    exit /b 0
)
echo.

if exist "%DEST%\uzbek_keyboard.pyw" (
    echo Dastur allaqachon o'rnatilgan: %DEST%
    echo Qayta o'rnatish uchun avval uninstall.bat ni ishga tushiring.
    pause
    exit /b 0
)

where pythonw >nul 2>nul
if errorlevel 1 (
    echo Python topilmadi.
    echo https://www.python.org/downloads/ dan o'rnating va "Add python.exe to PATH" ni belgilang.
    pause
    exit /b 1
)

for /f "delims=" %%i in ('where pythonw') do (
    set "PYW=%%i"
    goto :found
)
:found

echo Kutubxona o'rnatilmoqda...
python -m pip install --upgrade keyboard
if errorlevel 1 (
    echo Kutubxonani o'rnatib bo'lmadi.
    pause
    exit /b 1
)

echo Fayllar nusxalanmoqda...
mkdir "%DEST%"
copy /Y "%~dp0uzbek_keyboard.pyw" "%DEST%\uzbek_keyboard.pyw" >nul

echo Avtomatik ishga tushirish sozlanmoqda...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v UzbekKeyboard /t REG_SZ /d "\"%PYW%\" \"%DEST%\uzbek_keyboard.pyw\"" /f >nul

echo Dastur ishga tushirilmoqda...
start "" "%PYW%" "%DEST%\uzbek_keyboard.pyw"

echo.
echo O'rnatish tugadi!
echo  o+'  -> Ö     g+'  -> Ğ
echo  s+h  -> Ş     c+h  -> Ç
echo Yoqish/o'chirish: Ctrl+Alt+U
echo.
pause
