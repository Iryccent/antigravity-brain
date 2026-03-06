# ============================================
# Antigravity Brain - Sync Script v2.0
# ============================================
# Sincroniza el Brain local con GitHub
# Repositorio: https://github.com/Iryccent/antigravity-brain
#
# Funciones principales:
#   1. Test-BrainIntegrity   - Valida integridad de archivos críticos
#   2. New-BrainBackup       - Crea backup automático antes de sync
#   3. Invoke-BrainPull      - Descarga cambios remotos de forma segura
#   4. Invoke-BrainCommit    - Commit inteligente con timestamp
#   5. Invoke-BrainPush      - Push a GitHub con verificación
#   6. Show-BrainStatus      - Muestra estado actual del Brain
#   7. Invoke-BrainSync      - Orquesta el flujo completo de sync
# ============================================

$brainPath = "$HOME\.antigravity"
$backupPath = "$HOME\.antigravity-backups"
$criticalFiles = @(
    "AGENT.md",
    "argv.json",
    "rules\rules.md"
)

# ── Función 1: Validar Integridad ────────────────────────────────────────────
function Test-BrainIntegrity {
    Write-Host "[INTEGRITY] Validando integridad del Brain..." -ForegroundColor Cyan
    $allOk = $true

    foreach ($file in $criticalFiles) {
        $fullPath = Join-Path $brainPath $file
        if (Test-Path $fullPath) {
            $size = (Get-Item $fullPath).Length
            if ($size -eq 0) {
                Write-Host "[WARNING] Archivo vacío detectado: $file" -ForegroundColor Yellow
                $allOk = $false
            } else {
                Write-Host "  ✓ $file ($size bytes)" -ForegroundColor Green
            }
        } else {
            Write-Host "  ✗ FALTANTE: $file" -ForegroundColor Red
            $allOk = $false
        }
    }

    return $allOk
}

# ── Función 2: Crear Backup ──────────────────────────────────────────────────
function New-BrainBackup {
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $thisBackup = Join-Path $backupPath $timestamp

    Write-Host "[BACKUP] Creando backup en: $thisBackup" -ForegroundColor Cyan

    if (-not (Test-Path $backupPath)) {
        New-Item -ItemType Directory -Path $backupPath | Out-Null
    }

    # Copiar solo archivos esenciales (no .git ni node_modules)
    $excludeDirs = @(".git", "node_modules", ".antigravity-backups")
    Copy-Item -Path $brainPath -Destination $thisBackup -Recurse -Exclude $excludeDirs -ErrorAction SilentlyContinue

    # Mantener solo los últimos 5 backups
    $allBackups = Get-ChildItem $backupPath | Sort-Object Name
    if ($allBackups.Count -gt 5) {
        $toDelete = $allBackups | Select-Object -First ($allBackups.Count - 5)
        $toDelete | Remove-Item -Recurse -Force
        Write-Host "[BACKUP] Backups antiguos eliminados: $($toDelete.Count)" -ForegroundColor Gray
    }

    Write-Host "[BACKUP] ✓ Backup creado: $timestamp" -ForegroundColor Green
    return $thisBackup
}

# ── Función 3: Pull Seguro ───────────────────────────────────────────────────
function Invoke-BrainPull {
    Write-Host "[PULL] Descargando cambios remotos..." -ForegroundColor Cyan
    git fetch origin main 2>&1 | Out-Null

    $pullResult = git pull --rebase origin main 2>&1

    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARNING] Conflicto detectado. Abortando rebase..." -ForegroundColor Yellow
        git rebase --abort 2>&1 | Out-Null

        Write-Host "[MERGE] Intentando merge automático..." -ForegroundColor Cyan
        git pull origin main --no-edit 2>&1 | Out-Null

        if ($LASTEXITCODE -ne 0) {
            Write-Host "[ERROR] No se pudo sincronizar automáticamente" -ForegroundColor Red
            Write-Host "[SOLUCIÓN] Resuelve los conflictos manualmente:" -ForegroundColor Yellow
            Write-Host "           cd $brainPath && git status" -ForegroundColor Yellow
            return $false
        }
    }

    Write-Host "[PULL] ✓ Sincronizado con remoto" -ForegroundColor Green
    return $true
}

# ── Función 4: Commit Inteligente ────────────────────────────────────────────
function Invoke-BrainCommit {
    git add .
    $status = git status --porcelain

    if ($status) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $changedFiles = ($status -split "`n").Count
        $commitMsg = "Auto-sync: $timestamp ($changedFiles archivo(s) modificado(s))"
        git commit -m $commitMsg 2>&1 | Out-Null
        Write-Host "[COMMIT] ✓ $commitMsg" -ForegroundColor Green
        return $true
    } else {
        Write-Host "[INFO] No hay cambios locales para commitear" -ForegroundColor Gray
        return $false
    }
}

# ── Función 5: Push con Verificación ─────────────────────────────────────────
function Invoke-BrainPush {
    Write-Host "[PUSH] Enviando a GitHub..." -ForegroundColor Cyan
    git push origin main 2>&1 | Out-Null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "[PUSH] ✓ Brain sincronizado con GitHub" -ForegroundColor Green
        return $true
    } else {
        Write-Host "[ERROR] Error al hacer push" -ForegroundColor Red
        Write-Host "[SOLUCIÓN] Verifica tu conexión y permisos de GitHub" -ForegroundColor Yellow
        return $false
    }
}

# ── Función 6: Mostrar Estado ─────────────────────────────────────────────────
function Show-BrainStatus {
    Write-Host "" 
    Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║       ANTIGRAVITY BRAIN STATUS       ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📍 Ruta: $brainPath" -ForegroundColor Gray
    Write-Host "🔗 Repo: https://github.com/Iryccent/antigravity-brain" -ForegroundColor Gray
    Write-Host ""

    $lastCommit = git log --oneline -1 2>&1
    Write-Host "📝 Último commit: $lastCommit" -ForegroundColor White

    $pendingChanges = git status --porcelain 2>&1
    if ($pendingChanges) {
        Write-Host "⚠️  Cambios pendientes detectados" -ForegroundColor Yellow
    } else {
        Write-Host "✅ Brain limpio (sin cambios pendientes)" -ForegroundColor Green
    }
    Write-Host ""
}

# ── Función 7: Sync Completo (Orquestador) ────────────────────────────────────
function Invoke-BrainSync {
    Write-Host ""
    Write-Host "[SYNC] Iniciando sincronización del Antigravity Brain v2.0..." -ForegroundColor Cyan
    Write-Host ""

    # Verificar que es un repositorio git
    if (-not (Test-Path "$brainPath\.git")) {
        Write-Host "[ERROR] .antigravity no es un repositorio Git" -ForegroundColor Red
        Write-Host "[SOLUCIÓN] El repositorio está en:" -ForegroundColor Yellow
        Write-Host "           https://github.com/Iryccent/antigravity-brain" -ForegroundColor Yellow
        exit 1
    }

    Push-Location $brainPath

    try {
        # Paso 1: Validar integridad
        $integrityOk = Test-BrainIntegrity
        if (-not $integrityOk) {
            Write-Host "[WARNING] Se detectaron problemas de integridad, continuando de todas formas..." -ForegroundColor Yellow
        }

        # Paso 2: Crear backup
        $backupDir = New-BrainBackup

        # Paso 3: Pull remoto
        $pullOk = Invoke-BrainPull
        if (-not $pullOk) {
            Pop-Location
            exit 1
        }

        # Paso 4: Commit local
        Invoke-BrainCommit | Out-Null

        # Paso 5: Push
        $pushOk = Invoke-BrainPush

        # Paso 6: Mostrar estado final
        Show-BrainStatus

        if ($pushOk) {
            Write-Host "🎉 SYNC COMPLETO — Brain actualizado exitosamente" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "[ERROR] Error inesperado: $_" -ForegroundColor Red
    }
    finally {
        Pop-Location
    }
}

# ── ENTRY POINT ──────────────────────────────────────────────────────────────
Invoke-BrainSync
