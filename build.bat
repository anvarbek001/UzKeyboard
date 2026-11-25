@echo off
chcp 65001 >nul
title O'zbek klaviatura - build
cd /d "%~dp0"

echo [1/3] Kerakli kutubxonalar o'rnatilmoqda...
python -m pip install --upgrade keyboard pyinstaller
if errorlevel 1 (
    echo Xatolik: Python yoki pip topilmadi.
    pause
    exit /b 1
)

echo [2/3] UzKeyboard.exe yasalmoqda...
copy /Y uzbek_keyboard.pyw uzbek_keyboard_app.py >nul
python -m PyInstaller --noconsole --onefile --name UzKeyboard uzbek_keyboard_app.py
if errorlevel 1 (
    echo Xatolik: PyInstaller ishlamadi.
    pause
    exit /b 1
)
echo dist\UzKeyboard.exe tayyor.

echo [3/3] O'rnatish fayli yasalmoqda...
set "ISCC=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
if not exist "%ISCC%" set "ISCC=%ProgramFiles%\Inno Setup 6\ISCC.exe"
if exist "%ISCC%" (
    "%ISCC%" setup.iss
    echo.
    echo Tayyor: output\UzKeyboard-Setup.exe
) else (
    echo Inno Setup topilmadi. https://jrsoftware.org/isdl.php dan o'rnating va skriptni qayta ishga tushiring.
    echo Hozircha faqat dist\UzKeyboard.exe fayldan foydalanishingiz mumkin.
)
echo.
pause
