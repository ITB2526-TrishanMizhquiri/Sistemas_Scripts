@echo off
REM ==========================================================
REM Script: antivirus_windows_TMV.bat
REM Autor: Trishan Mabel Mizhquiri Valencia (TMV)
REM Curso: ASIXc - Administració de Sistemes Informàtics en Xarxa
REM Fecha: 2025-12-17
REM Descripción: 
REM   Ejecuta un escaneo completo del sistema usando Windows Defender.
REM   Ideal para tareas programadas o respuesta a incidentes.
REM Requisitos:
REM   - Ejecutarse como Administrador.
REM   - Windows 10/11 con Windows Defender activado.
REM Licencia: MIT
REM ==========================================================

echo.
echo [+] Iniciando script de antivirus - Windows Defender
echo [+] Fecha y hora: %date% %time%
echo.

REM Comprobar si se ejecuta como administrador
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo [!] ERROR: Este script debe ejecutarse como Administrador.
    timeout /t 5 >nul
    exit /b 1
)

echo [+] Ejecutando escaneo completo con Windows Defender...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2

if %errorlevel% EQU 0 (
    echo [+] Escaneo completado sin amenazas detectadas.
) else (
    echo [!] Advertencia: El escaneo finalizó con errores o amenazas detectadas.
)

echo [+] Script finalizado.
pause
