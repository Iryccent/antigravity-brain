# ============================================================
# Antigravity Brain - Refactor Code Script
# Agente: Ruthless Code Reviewer
# Versión: 1.0 - Marzo 2026
# ============================================================
# Analiza y refactoriza código para mejorar calidad
# ============================================================

param(
    [Parameter(Mandatory = $true)]
    [string]$Target,

    [Parameter(Mandatory = $false)]
    [switch]$AutoFix = $false,

    [Parameter(Mandatory = $false)]
    [switch]$Report = $false,

    [Parameter(Mandatory = $false)]
    [ValidateSet("low", "medium", "high", "critical")]
    [string]$Severity = "medium"
)

$severityLevels = @{ "low" = 0; "medium" = 1; "high" = 2; "critical" = 3 }
$minLevel = $severityLevels[$Severity]
$issues = @()
$reportPath = "refactor-report-$(Get-Date -Format 'yyyy-MM-dd_HH-mm').md"

# ── Función: Escribir encabezado ─────────────────────────────
function Write-Header {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║     RUTHLESS CODE REVIEWER v1.0          ║" -ForegroundColor Magenta
    Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "🔍 Analizando: $Target" -ForegroundColor White
    Write-Host "⚙️  Severity: $Severity | AutoFix: $AutoFix | Report: $Report" -ForegroundColor Gray
    Write-Host ""
}

# ── Función: Analizar archivo ─────────────────────────────────
function Analyze-File {
    param([string]$FilePath)

    $content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return }

    $lines = Get-Content $FilePath
    $lineCount = $lines.Count
    $fileName = Split-Path $FilePath -Leaf
    $fileIssues = @()

    # Verificar longitud del archivo
    if ($lineCount -gt 350) {
        $fileIssues += [PSCustomObject]@{
            File     = $FilePath
            Line     = $lineCount
            Severity = "HIGH"
            Rule     = "RG-03"
            Message  = "Archivo demasiado largo: $lineCount líneas (máx 350)"
        }
    } elseif ($lineCount -gt 250) {
        $fileIssues += [PSCustomObject]@{
            File     = $FilePath
            Line     = $lineCount
            Severity = "MEDIUM"
            Rule     = "RG-03"
            Message  = "Archivo largo: $lineCount líneas (advertencia > 250)"
        }
    }

    # Detectar console.log no permitidos
    $consoleLogs = $lines | Select-String -Pattern "console\.log\(" -SimpleMatch
    foreach ($match in $consoleLogs) {
        $fileIssues += [PSCustomObject]@{
            File     = $FilePath
            Line     = $match.LineNumber
            Severity = "MEDIUM"
            Rule     = "RG-01"
            Message  = "console.log detectado (usar console.warn o console.error)"
        }
    }

    # Detectar API keys hardcodeadas (patrones comunes)
    $keyPatterns = @("sk-", "pk_", "api_key\s*=\s*['\"]", "apiKey\s*:\s*['\"]", "secret\s*:\s*['\"][^$\{]")
    foreach ($pattern in $keyPatterns) {
        $matches = $lines | Select-String -Pattern $pattern
        foreach ($match in $matches) {
            $fileIssues += [PSCustomObject]@{
                File     = $FilePath
                Line     = $match.LineNumber
                Severity = "CRITICAL"
                Rule     = "RS-01"
                Message  = "Posible API key hardcodeada detectada"
            }
        }
    }

    # Detectar funciones extremadamente largas (heurística por indentación y keywords)
    $functionStartLines = @()
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "(function\s+\w+|=>\s*\{|async\s+function)") {
            $functionStartLines += $i
        }
    }

    # Detectar TODO sin ticket
    $todoLines = $lines | Select-String -Pattern "TODO(?!\(#\d+\))" -SimpleMatch
    foreach ($match in $todoLines) {
        $fileIssues += [PSCustomObject]@{
            File     = $FilePath
            Line     = $match.LineNumber
            Severity = "LOW"
            Rule     = "ED-03"
            Message  = "TODO sin ticket de referencia (usar: TODO(#123): descripción)"
        }
    }

    # Detectar any de TypeScript
    $anyUsages = $lines | Select-String -Pattern ":\s*any\b" -SimpleMatch
    foreach ($match in $anyUsages) {
        $fileIssues += [PSCustomObject]@{
            File     = $FilePath
            Line     = $match.LineNumber
            Severity = "MEDIUM"
            Rule     = "GA-01"
            Message  = "Uso de 'any' en TypeScript (usar tipos explícitos)"
        }
    }

    return $fileIssues
}

# ── Función: Aplicar auto-fix ─────────────────────────────────
function Apply-AutoFix {
    param([string]$FilePath, [array]$FileIssues)

    $content = Get-Content $FilePath -Raw
    $fixed = $false

    # Auto-fix: console.log → console.warn
    if ($FileIssues | Where-Object { $_.Rule -eq "RG-01" }) {
        $content = $content -replace "console\.log\(", "console.warn("
        $fixed = $true
        Write-Host "  🔧 Auto-fix: console.log → console.warn en $FilePath" -ForegroundColor Yellow
    }

    if ($fixed) {
        Set-Content -Path $FilePath -Value $content -Encoding UTF8
    }
}

# ── Función: Generar reporte ──────────────────────────────────
function Generate-Report {
    param([array]$AllIssues)

    $criticalCount = ($AllIssues | Where-Object { $_.Severity -eq "CRITICAL" }).Count
    $highCount = ($AllIssues | Where-Object { $_.Severity -eq "HIGH" }).Count
    $mediumCount = ($AllIssues | Where-Object { $_.Severity -eq "MEDIUM" }).Count
    $lowCount = ($AllIssues | Where-Object { $_.Severity -eq "LOW" }).Count

    $reportContent = @"
# 📊 Reporte de Refactoring — $(Get-Date -Format "yyyy-MM-dd HH:mm")

**Target:** $Target  
**Generado por:** Ruthless Code Reviewer v1.0  

## Resumen

| Severidad | Cantidad |
|-----------|---------|
| 🔴 CRITICAL | $criticalCount |
| 🟠 HIGH | $highCount |
| 🟡 MEDIUM | $mediumCount |
| 🔵 LOW | $lowCount |
| **TOTAL** | **$($AllIssues.Count)** |

## Detalle de Problemas

"@

    $groupedByFile = $AllIssues | Group-Object -Property File
    foreach ($fileGroup in $groupedByFile) {
        $reportContent += "`n### ``$($fileGroup.Name)```n`n"
        foreach ($issue in $fileGroup.Group | Sort-Object { $severityLevels[$_.Severity.ToLower()] } -Descending) {
            $icon = switch ($issue.Severity) {
                "CRITICAL" { "🔴" }
                "HIGH" { "🟠" }
                "MEDIUM" { "🟡" }
                "LOW" { "🔵" }
            }
            $reportContent += "- $icon **[$($issue.Severity)]** Línea $($issue.Line): $($issue.Message) ``[$($issue.Rule)]```n"
        }
    }

    $reportContent += "`n---`n*Generado por Antigravity Brain — Ruthless Code Reviewer*`n"
    Set-Content -Path $reportPath -Value $reportContent -Encoding UTF8
    Write-Host "📄 Reporte guardado en: $reportPath" -ForegroundColor Cyan
}

# ── Main ──────────────────────────────────────────────────────
Write-Header

# Verificar que el target existe
if (-not (Test-Path $Target)) {
    Write-Host "❌ Error: No se encontró el target: $Target" -ForegroundColor Red
    exit 1
}

# Obtener archivos a analizar
$extensions = @("*.ts", "*.tsx", "*.js", "*.jsx")
$files = @()

if (Test-Path $Target -PathType Leaf) {
    $files = @($Target)
} else {
    foreach ($ext in $extensions) {
        $files += Get-ChildItem -Path $Target -Filter $ext -Recurse |
            Where-Object { $_.FullName -notmatch "node_modules|\.next|dist|build|coverage" } |
            Select-Object -ExpandProperty FullName
    }
}

Write-Host "📂 Archivos a analizar: $($files.Count)" -ForegroundColor White
Write-Host ""

# Analizar cada archivo
foreach ($file in $files) {
    $fileIssues = Analyze-File -FilePath $file
    if ($fileIssues -and $fileIssues.Count -gt 0) {
        $issues += $fileIssues

        if ($AutoFix) {
            Apply-AutoFix -FilePath $file -FileIssues $fileIssues
        }
    }
}

# Filtrar por severidad mínima
$filteredIssues = $issues | Where-Object {
    $severityLevels[$_.Severity.ToLower()] -ge $minLevel
}

# Mostrar resultados
$criticalCount = ($filteredIssues | Where-Object { $_.Severity -eq "CRITICAL" }).Count
$highCount = ($filteredIssues | Where-Object { $_.Severity -eq "HIGH" }).Count

Write-Host "════════════════════════════════════════" -ForegroundColor Gray
Write-Host "📊 RESULTADOS DEL ANÁLISIS" -ForegroundColor White
Write-Host "════════════════════════════════════════" -ForegroundColor Gray
Write-Host ""
Write-Host "🔴 CRITICAL: $criticalCount" -ForegroundColor Red
Write-Host "🟠 HIGH:     $highCount" -ForegroundColor DarkYellow
Write-Host "🟡 MEDIUM:   $(($filteredIssues | Where-Object { $_.Severity -eq 'MEDIUM' }).Count)" -ForegroundColor Yellow
Write-Host "🔵 LOW:      $(($filteredIssues | Where-Object { $_.Severity -eq 'LOW' }).Count)" -ForegroundColor Blue
Write-Host ""

# Mostrar problemas críticos y altos en consola
$criticalAndHigh = $filteredIssues | Where-Object { $_.Severity -in @("CRITICAL", "HIGH") }
if ($criticalAndHigh.Count -gt 0) {
    Write-Host "⚠️  PROBLEMAS CRÍTICOS Y ALTOS:" -ForegroundColor Red
    foreach ($issue in $criticalAndHigh) {
        $icon = if ($issue.Severity -eq "CRITICAL") { "🔴" } else { "🟠" }
        Write-Host "  $icon $($issue.File):$($issue.Line) — $($issue.Message)" -ForegroundColor White
    }
    Write-Host ""
}

# Generar reporte si se solicitó
if ($Report -and $filteredIssues.Count -gt 0) {
    Generate-Report -AllIssues $filteredIssues
}

# Resultado final
if ($criticalCount -gt 0) {
    Write-Host "🚫 MERGE BLOQUEADO — Hay $criticalCount problema(s) CRITICAL" -ForegroundColor Red
    exit 1
} elseif ($highCount -gt 0) {
    Write-Host "⚠️  MERGE CONDICIONADO — Hay $highCount problema(s) HIGH que resolver" -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "✅ Código aprobado por Ruthless Code Reviewer" -ForegroundColor Green
    exit 0
}
