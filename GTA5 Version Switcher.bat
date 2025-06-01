@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: Define script directory path variable
set "SCRIPT_DIR=%~dp0"

:: Check if config.txt exists
if not exist "%SCRIPT_DIR%config.txt" (
    echo [ERROR] config.txt not found in the script directory.
    echo Please make sure config.txt exists in: %SCRIPT_DIR%
    echo.
    echo Example config.txt structure:
    echo -------------------------------
    echo [PATHS]
    echo GTAV_DIR=D:\SteamLibrary\steamapps\common\Grand Theft Auto V
    echo ALT_VERSION_DIR=D:\My Games\GTAV_Mods
    echo PRIMARY_VERSION_DIR=D:\My Games\Mods\Grand Theft Auto\GTA V VR
    echo SETTINGS_DIR=D:\Documents\Rockstar Games\GTA V
    echo -------------------------------
    pause
    exit 1
)

:: Load configuration from config.txt
set "section="
for /f "usebackq tokens=1* delims==" %%A in ("%SCRIPT_DIR%config.txt") do (
    if "%%A"=="[PATHS]" set "section=PATHS"

    if defined section (
        if "!section!"=="PATHS" (
            set "%%A=%%B"
    )
  )
)

:: Verify each directory
set "missingDir=0"

for %%D in ("!GTAV_DIR!" "!ALT_VERSION_DIR!" "!PRIMARY_VERSION_DIR!") do (
    if not exist %%D (
        echo.
        echo Directory not found: %%D
        set /a missingDir+=1
    )
)

if %missingDir% gtr 0 (
    echo.
    echo Change directory paths in config.txt
    echo.
    echo Primary [Paths]
    echo ---------------
    echo.
    echo GTA V Game Directory Path
    echo %GTAV_DIR%
    echo.
    echo Alt Version Directory Path
    echo %ALT_VERSION_DIR%
    echo.
    echo Primary Version Directory Path
    echo %PRIMARY_VERSION_DIR%
    echo.
    echo Settings Directory Path
    echo %SETTINGS_DIR%
    echo.
    Pause
    goto Exit
)

:: Default files directory
set DEFAULT_FILES=%GTAV_DIR%\Default_Files_Backup

:: Check Version State
REG QUERY "HKCU\Software\GTAV_ALT" /v "installed" >nul 2>&1

if %ERRORLEVEL%==0 (
    goto INSTALL_OPTIONS
) else (
    goto INSTALL 
)

:INSTALL
echo.
echo ██ ████   ██  ██████ ██████ ██████ ██     ██      
echo ██ ██ █   ██ ███   █   ██   ██  ██ ██     ██
echo ██ ██ ██  ██ ██        ██   ██  ██ ██     ██
echo ██ ██  █  ██  █████    ██   ██████ ██     ██      
echo ██ ██  ██ ██      ██   ██   ██  ██ ██     ██      
echo ██ ██   █ ██ █   ███   ██   ██  ██ ██     ██      
echo ██ ██   ████ ██████    ██   ██  ██ ██████ ██████
echo.  
timeout /t 5 
goto ALTINSTALL

:INSTALL_OPTIONS
echo.
echo ████ ████  ██ ██   ██  █     █ ████
echo █  █ █    █ ███ █ █  █ █     █ █
echo ████ ███  █  █  █ █  █  █   █  ███ 
echo █ █  █    █     █ █  █   █ █   █ 
echo █ ██ ████ █     █  ██     █    ████ 
echo [1] Remove GTAV Alternate Version
echo.
echo ████ ████ █ ███  █  ████ ███ ████ █   █      
echo █  █ █    █ █ █  █ █      █  █  █ █   █
echo ████ ███  █ █ ██ █  ████  █  ████ █   █
echo █ █  █    █ █  █ █      █ █  █  █ █   █     
echo █ ██ ████ █ █  ███  ████  █  █  █ ███ ███  
echo [2] ReInstall GTAV Alternate Version
echo.
set /p choice="Enter 1 or 2: "

if /i "%choice%"=="1" (
    goto ALTREMOVE
) else if /i "%choice%"=="2" (
    goto ALTINSTALL
) else (
    cls
    echo.
    echo Invalid choice. Try again
    timeout /t 2 >nul
    echo.
    goto INSTALL_OPTIONS
)

:ALTINSTALL
:: Ensure directories exist
mkdir "%DEFAULT_FILES%\update" 2>nul

:: Move primary files if missing in DEFAULT_FILES
for %%F in (bink2w64.dll GTA5.exe GTAVLanguageSelect.exe GTAVLauncher.exe PlayGTAV.exe) do (
    if not exist "%DEFAULT_FILES%\%%F" move "%GTAV_DIR%\%%F" "%DEFAULT_FILES%" >nul
)
for %%F in (update.rpf update2.rpf) do (
    if not exist "%DEFAULT_FILES%\update\%%F" move "%GTAV_DIR%\update\%%F" "%DEFAULT_FILES%\update" >nul
)

:: Generate Alt Version file list
set "AltOutputFile=%SCRIPT_DIR%AltVersionList.txt"
type nul > "%AltOutputFile%"

pushd "%ALT_VERSION_DIR%"
for /r %%F in (*) do (
    set "AltFilePath=%%F"
    set "AltFilePath=!AltFilePath:%ALT_VERSION_DIR%=!"
    echo !GTAV_DIR!\!AltFilePath:~1!>> "%AltOutputFile%"
)
popd

:: Generate Primary Version file list
set "CurOutputFile=%SCRIPT_DIR%PrimaryVersionList.txt"
type nul > "%CurOutputFile%"

pushd "%PRIMARY_VERSION_DIR%"
for /r %%F in (*) do (
    set "CurFilePath=%%F"
    set "CurFilePath=!CurFilePath:%PRIMARY_VERSION_DIR%=!"
    echo !GTAV_DIR!\!CurFilePath:~1!>> "%CurOutputFile%"
)
popd

:: Define the correct path to the AltVersionList.txt
set "PRIMARY_VERSION_LIST=%SCRIPT_DIR%PrimaryVersionList.txt"

:: Delete Primary Version parsed from AltVersionList.txt
if exist "%PRIMARY_VERSION_LIST%" (
    for /f "usebackq delims=" %%F in ("%PRIMARY_VERSION_LIST%") do (
        if exist "%%F" (
            del /f /q "%%F"
            echo Deleted: %%F
        ) else (
            echo File not found: %%F
        )
    )
) else (
    echo *** PrimaryVersionList.txt NOT FOUND. ABORTING ***
    goto EXIT
)

:: Copy Alt Version files to game directory
xcopy "%ALT_VERSION_DIR%\*.*" "%GTAV_DIR%" /s /f /i /y

:: Use Alt Version settings.xml
del "%SETTINGS_DIR%\settings.xml" /f
xcopy "%SCRIPT_DIR%Settings\AltVersion\*.*" "%SETTINGS_DIR%" /s /f /i /y

:: Confirm Alt files are installed
set "AltFilesPresent=true"
for /f "usebackq delims=" %%F in ("%AltOutputFile%") do (
    if not exist "%%F" (
        echo Missing file: %%F
        set "AltFilesPresent=false"
    )
)

if "!AltFilesPresent!"=="true" (
    REG ADD "HKCU\Software\GTAV_ALT" /v "installed" /t REG_SZ /d "" /f
    goto INSTALLED
) else (
    echo [ERROR] Not all files were installed. Aborting.
    goto EXIT
)

:ALTREMOVE
:: Define the correct path to the AltVersionList.txt
set "ALT_VERSION_LIST=%SCRIPT_DIR%AltVersionList.txt"

:: Delete Alt Version Files parsed from AltVersionList.txt
if exist "%ALT_VERSION_LIST%" (
    for /f "usebackq delims=" %%F in ("%ALT_VERSION_LIST%") do (
        if exist "%%F" (
            del /f /q "%%F"
            echo Deleted: %%F
        ) else (
            echo File not found: %%F
        )
    )
) else (
    echo *** AltVersionList.txt NOT FOUND. ABORTING ***
    goto EXIT
)

:: Move primary files back to game directory
for /f "usebackq delims=" %%F in ("%SCRIPT_DIR%AltVersionList.txt") do del "%%F" 2>nul
for %%F in (bink2w64.dll GTA5.exe GTAVLanguageSelect.exe GTAVLauncher.exe PlayGTAV.exe) do move "%DEFAULT_FILES%\%%F" "%GTAV_DIR%" >nul
for %%F in (update.rpf update2.rpf) do move "%DEFAULT_FILES%\update\%%F" "%GTAV_DIR%\update" >nul

:: Use Normal settings.xml
del "%SETTINGS_DIR%\settings.xml" /f
xcopy "%SCRIPT_DIR%Settings\Normal\*.*" "%SETTINGS_DIR%" /s /f /i /y

:: Copy Extra Primary Version files to game directory
xcopy "%PRIMARY_VERSION_DIR%\*.*" "%GTAV_DIR%" /s /f /i /y

:: Confirm Primary Version files are installed
set "CurFilesPresent=true"
for /f "usebackq delims=" %%F in ("%CurOutputFile%") do (
    if not exist "%%F" (
        echo Missing file: %%F
        set "CurFilesPresent=false"
    )
)

if "!CurFilesPresent!"=="true" (
    REG DELETE "HKCU\Software\GTAV_ALT" /v "installed" /f
    goto REMOVED
) else (
    echo [ERROR] Not all files were installed. Aborting.
    goto EXIT
)

:INSTALLED
echo.
echo ██ ████   ██  ██████ ██████ ██████ ██     ██     ██████ ██████
echo ██ ██ █   ██ ███   █   ██   ██  ██ ██     ██     ██     ██   ██
echo ██ ██ ██  ██ ██        ██   ██  ██ ██     ██     ██     ██    ██
echo ██ ██  █  ██  █████    ██   ██████ ██     ██     █████  ██    ██  
echo ██ ██  ██ ██      ██   ██   ██  ██ ██     ██     ██     ██    ██
echo ██ ██   █ ██ █   ███   ██   ██  ██ ██     ██     ██     ██   ██
echo ██ ██   ████ ██████    ██   ██  ██ ██████ ██████ ██████ ██████
echo.  
goto EXIT

:REMOVED
echo.
echo ███████  ██████    ██   ██     █████  ██    ██ ██████ ██████
echo ██    ██ ██       ████ ████   ██   ██ ██    ██ ██     ██   ██
echo ██    ██ ██      ██ ██ ██ ██  ██   ██ ██    ██ ██     ██    ██
echo ███████  █████   ██  ███  ██  ██   ██ ██    ██ █████  ██    ██
echo ██ ██    ██      ██   █   ██  ██   ██  ██  ██  ██     ██    ██
echo ██   ██  ██     ███       ███ ██   ██   ████   ██     ██   ██
echo ██    ██ ██████ ███       ███  █████     ██    ██████ ██████ 
echo.
goto EXIT

:EXIT
set "GTAV_DIR="
set "ALT_VERSION_DIR="
set "SETTINGS_DIR="
set "PRIMARY_VERSION_DIR="
pause
exit
