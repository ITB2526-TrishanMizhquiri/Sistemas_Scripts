<#
.SYNOPSIS
    Script de auditoría de seguridad para entornos Windows.
.DESCRIPTION
    Recopila información crítica de seguridad:
    - Procesos con alto uso de CPU o memoria.
    - Conexiones de red establecidas.
    - Tareas programadas sospechosas.
    - Usuarios con sesiones activas.
.AUTHOR
    Trishan Mabel Mizhquiri Valencia (TMV)
.CURSO
    ASIXc - Administració de Sistemes Informàtics en Xarxa
.DATE
    2025-12-17
.REQUIREMENTS
    - Ejecutarse como Administrador.
    - PowerShell 5.1 o superior.
.LICENSE
    MIT
#>

Write-Host "[+] Iniciando auditoría de seguridad - Windows" -ForegroundColor Green
Write-Host "[+] Fecha y hora: $(Get-Date)`n"

# Verificar privilegios de administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[!] ERROR: Este script debe ejecutarse como Administrador." -ForegroundColor Red
    exit 1
}

# 1. Procesos con alto consumo
Write-Host "[+] Procesos con alto uso de recursos:" -ForegroundColor Cyan
Get-Process | Where-Object { $_.CPU -gt 50 -or $_.WorkingSet64 -gt 200MB } | 
    Select-Object Id, ProcessName, CPU, @{Name="Memoria(MB)";Expression={[math]::Round($_.WorkingSet64 / 1MB, 2)}} |
    Format-Table -AutoSize

# 2. Conexiones de red activas
Write-Host "`n[+] Conexiones TCP establecidas:" -ForegroundColor Cyan
Get-NetTCPConnection -State Established | 
    Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess |
    Sort-Object RemoteAddress |
    Format-Table -AutoSize

# 3. Tareas programadas (opcional: filtrar por autor desconocido)
Write-Host "`n[+] Tareas programadas (últimas 10):" -ForegroundColor Cyan
Get-ScheduledTask | Where-Object { $_.State -eq "Ready" } | 
    Select-Object TaskName, Author, Date | 
    Sort-Object Date -Descending | 
    Select-Object -First 10 |
    Format-Table -AutoSize

# 4. Sesiones de usuario activas
Write-Host "`n[+] Sesiones de usuario activas:" -ForegroundColor Cyan
query user 2>$null

Write-Host "`n[+] Auditoría completada." -ForegroundColor Green
