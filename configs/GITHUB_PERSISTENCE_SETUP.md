# 🔄 SETUP: GitHub Persistence for Antigravity Brain

> [!IMPORTANT]
> Este documento automatiza la sincronización de la configuración del Brain entre máquinas vía GitHub.

## 🎯 Objetivo
Mantener `.antigravity/configs` sincronizado en todas tus máquinas de trabajo usando un repositorio privado.

---

## 📋 Pasos de Configuración

### 1. Crear Repositorio Privado

```bash
# En GitHub, crea un repo privado llamado: antigravity-config
# Luego ejecuta localmente:

cd %USERPROFILE%\.antigravity
git init
git add configs/
git commit -m "Initial Brain configuration"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/antigravity-config.git
git push -u origin main
```

### 2. Script de Sincronización Automática

Crea este archivo en `%USERPROFILE%\.antigravity\sync-brain.ps1`:

```powershell
# Sync Antigravity Brain with GitHub
cd $env:USERPROFILE\.antigravity

# Pull latest changes
git pull origin main --rebase

# Push any local changes
git add -A
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Auto-sync: $timestamp" -a --allow-empty
git push origin main

Write-Host "Brain synchronized successfully" -ForegroundColor Green
```

### 3. Automatizar al Iniciar Sesión

**Windows (Task Scheduler):**
```powershell
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File $env:USERPROFILE\.antigravity\sync-brain.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -TaskName "SyncAntigravityBrain" -Action $action -Trigger $trigger -Description "Sync Brain config on login"
```

**Linux/Mac (crontab):**
```bash
@reboot cd ~/.antigravity && git pull origin main --rebase
```

---

## ✅ Verificación

Ejecuta manualmente:
```bash
powershell -File %USERPROFILE%\.antigravity\sync-brain.ps1
```

Si ves "Brain synchronized successfully", está funcionando correctamente.

---

**Última actualización:** Febrero 2026
