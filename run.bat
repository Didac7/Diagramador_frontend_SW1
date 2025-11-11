@echo off
echo ================================
echo Flutter MVC Generator
echo ================================
echo.

REM Verificar que Flutter está instalado
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Flutter no está instalado o no está en el PATH
    echo Por favor instala Flutter desde: https://flutter.dev
    pause
    exit /b 1
)

echo [1/4] Verificando instalación de Flutter...
flutter doctor --version

echo.
echo [2/4] Limpiando proyecto...
flutter clean

echo.
echo [3/4] Descargando dependencias...
flutter pub get

echo.
echo [4/4] Ejecutando aplicación...
echo.
echo Opciones disponibles:
echo   1. Chrome (Web)
echo   2. Windows (Desktop)
echo   3. Android (Emulador/Dispositivo)
echo.
set /p choice="Selecciona una opción (1-3): "

if "%choice%"=="1" (
    echo Ejecutando en Chrome...
    flutter run -d chrome
) else if "%choice%"=="2" (
    echo Ejecutando en Windows...
    flutter run -d windows
) else if "%choice%"=="3" (
    echo Ejecutando en Android...
    flutter run
) else (
    echo Opción inválida. Ejecutando en dispositivo por defecto...
    flutter run
)

pause
