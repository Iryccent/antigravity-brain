# ============================================
# Antigravity Brain - Sync Script
# ============================================
# Sincroniza el Brain local con GitHub
# Repositorio: https://github.com/Iryccent/antigravity-brain
# ============================================

$brainPath = "$HOME\.antigravity"

Write-Host "[SYNC] Sincronizando Antigravity Brain con GitHub..." -ForegroundColor Cyan
Write-Host "[INFO] Ruta: $brainPath" -ForegroundColor Gray

if (-not (Test-Path "$brainPath\.git")) {
    Write-Host "[ERROR] .antigravity no es un repositorio Git" -ForegroundColor Red
    Write-Host "[SOLUCION] El repositorio esta configurado en:" -ForegroundColor Yellow
    Write-Host "           https://github.com/Iryccent/antigravity-brain" -ForegroundColor Yellow
    exit 1
}

Push-Location $brainPath

try {
    # 1. Verificar si hay cambios remotos
    Write-Host "[PULL] Descargando cambios remotos..." -ForegroundColor Cyan
    git fetch origin main 2>&1 | Out-Null
    
    # 2. Hacer pull con rebase para evitar merge commits
    Write-Host "[REBASE] Sincronizando con remoto..." -ForegroundColor Cyan
    $pullResult = git pull --rebase origin main 2>&1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARNING] Conflicto detectado. Abortando rebase..." -ForegroundColor Yellow
        git rebase --abort 2>&1 | Out-Null
        
        # Intentar merge en lugar de rebase
        Write-Host "[MERGE] Intentando merge automatico..." -ForegroundColor Cyan
        git pull origin main --no-edit 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[ERROR] No se pudo sincronizar automaticamente" -ForegroundColor Red
            Write-Host "[SOLUCION] Resuelve los conflictos manualmente:" -ForegroundColor Yellow
            Write-Host "           cd $brainPath" -ForegroundColor Yellow
            Write-Host "           git status" -ForegroundColor Yellow
            Pop-Location
            exit 1
        }
    }
    
    # 3. Agregar cambios locales
    Write-Host "[ADD] Agregando cambios locales..." -ForegroundColor Cyan
    git add .
    
    # 4. Commit (solo si hay cambios)
    $status = git status --porcelain
    if ($status) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        git commit -m "Auto-sync: $timestamp" 2>&1 | Out-Null
        Write-Host "[COMMIT] Commit creado: $timestamp" -ForegroundColor Green
    }
    else {
        Write-Host "[INFO] No hay cambios locales para commitear" -ForegroundColor Gray
    }
    
    # 5. Push a GitHub
    Write-Host "[PUSH] Enviando a GitHub..." -ForegroundColor Cyan
    git push origin main 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "" 
        Write-Host "[SUCCESS] Brain sincronizado exitosamente con GitHub" -ForegroundColor Green
        Write-Host "[REPO] https://github.com/Iryccent/antigravity-brain" -ForegroundColor Cyan
    }
    else {
        Write-Host "[ERROR] Error al hacer push" -ForegroundColor Red
        Write-Host "[SOLUCION] Verifica tu conexion y permisos de GitHub" -ForegroundColor Yellow
    }
    
}
catch {
    Write-Host "[ERROR] Error inesperado: $_" -ForegroundColor Red
}
finally {
    Pop-Location
}
