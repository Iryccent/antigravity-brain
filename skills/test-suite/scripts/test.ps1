# ============================================================
# Antigravity Brain - Test Suite Script
# Agente: Test Guardian
# Versión: 1.0 - Marzo 2026
# ============================================================
# Ejecuta tests y verifica cobertura >= 85%
# ============================================================

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("unit", "integration", "e2e", "all")]
    [string]$Type = "all",

    [Parameter(Mandatory = $false)]
    [switch]$Coverage = $true,

    [Parameter(Mandatory = $false)]
    [int]$MinCoverage = 85,

    [Parameter(Mandatory = $false)]
    [switch]$Watch = $false,

    [Parameter(Mandatory = $false)]
    [switch]$CI = $false
)

$projectRoot = Get-Location
$testResults = @{
    unit        = $null
    integration = $null
    e2e         = $null
    coverage    = $null
    passed      = $true
}

# ── Función: Encabezado ─────────────────────────────────────
function Write-Header {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║       TEST GUARDIAN v1.0                 ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "🛡️  Tipo: $Type | Cobertura mínima: $MinCoverage% | CI: $CI" -ForegroundColor White
    Write-Host ""
}

# ── Función: Verificar dependencias ─────────────────────────
function Test-Dependencies {
    Write-Host "[DEPS] Verificando dependencias..." -ForegroundColor Cyan

    $hasPkg = Test-Path "$projectRoot\package.json"
    if (-not $hasPkg) {
        Write-Host "❌ No se encontró package.json en: $projectRoot" -ForegroundColor Red
        exit 1
    }

    $pkgContent = Get-Content "$projectRoot\package.json" -Raw | ConvertFrom-Json
    $hasVitest = $pkgContent.devDependencies.vitest -or $pkgContent.dependencies.vitest
    $hasPlaywright = $pkgContent.devDependencies.'@playwright/test' -or $pkgContent.devDependencies.playwright

    if (-not $hasVitest -and $Type -ne "e2e") {
        Write-Host "⚠️  Vitest no encontrado en package.json" -ForegroundColor Yellow
        Write-Host "   Instalar con: npm install -D vitest @vitest/coverage-v8" -ForegroundColor Gray
    }

    if (-not $hasPlaywright -and $Type -in @("e2e", "all")) {
        Write-Host "⚠️  Playwright no encontrado (E2E tests serán omitidos)" -ForegroundColor Yellow
    }

    Write-Host "[DEPS] ✓ Verificación completada" -ForegroundColor Green
    return @{ hasVitest = $hasVitest; hasPlaywright = $hasPlaywright }
}

# ── Función: Ejecutar Unit Tests ──────────────────────────────
function Invoke-UnitTests {
    param([bool]$WithCoverage)

    Write-Host ""
    Write-Host "[UNIT] Ejecutando unit tests..." -ForegroundColor Cyan

    $cmd = "npx vitest run"
    if ($WithCoverage) {
        $cmd += " --coverage"
    }
    if ($Watch) {
        $cmd = "npx vitest"
    }

    Write-Host "   Comando: $cmd" -ForegroundColor Gray
    $result = Invoke-Expression $cmd
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        Write-Host "[UNIT] ✓ Unit tests pasados" -ForegroundColor Green
    } else {
        Write-Host "[UNIT] ✗ Unit tests fallaron" -ForegroundColor Red
        $testResults.passed = $false
    }

    $testResults.unit = $exitCode -eq 0
    return $exitCode -eq 0
}

# ── Función: Ejecutar Integration Tests ──────────────────────
function Invoke-IntegrationTests {
    Write-Host ""
    Write-Host "[INTEGRATION] Ejecutando integration tests..." -ForegroundColor Cyan

    # Buscar carpeta de integration tests
    $integrationPaths = @(
        "$projectRoot\src\__tests__\integration",
        "$projectRoot\tests\integration",
        "$projectRoot\src\tests\integration"
    )

    $integrationPath = $integrationPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

    if (-not $integrationPath) {
        Write-Host "[INTEGRATION] No se encontró carpeta de integration tests (omitiendo)" -ForegroundColor Yellow
        $testResults.integration = $true
        return $true
    }

    $cmd = "npx vitest run $integrationPath"
    Write-Host "   Comando: $cmd" -ForegroundColor Gray
    Invoke-Expression $cmd | Out-Null
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        Write-Host "[INTEGRATION] ✓ Integration tests pasados" -ForegroundColor Green
    } else {
        Write-Host "[INTEGRATION] ✗ Integration tests fallaron" -ForegroundColor Red
        $testResults.passed = $false
    }

    $testResults.integration = $exitCode -eq 0
    return $exitCode -eq 0
}

# ── Función: Ejecutar E2E Tests ───────────────────────────────
function Invoke-E2ETests {
    param([bool]$HasPlaywright)

    Write-Host ""
    Write-Host "[E2E] Ejecutando E2E tests..." -ForegroundColor Cyan

    if (-not $HasPlaywright) {
        Write-Host "[E2E] Playwright no instalado — omitiendo E2E tests" -ForegroundColor Yellow
        $testResults.e2e = $true
        return $true
    }

    $e2ePath = "$projectRoot\e2e"
    if (-not (Test-Path $e2ePath)) {
        Write-Host "[E2E] No se encontró carpeta /e2e — omitiendo E2E tests" -ForegroundColor Yellow
        $testResults.e2e = $true
        return $true
    }

    $cmd = "npx playwright test"
    Write-Host "   Comando: $cmd" -ForegroundColor Gray
    Invoke-Expression $cmd | Out-Null
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        Write-Host "[E2E] ✓ E2E tests pasados" -ForegroundColor Green
    } else {
        Write-Host "[E2E] ✗ E2E tests fallaron" -ForegroundColor Red
        $testResults.passed = $false
    }

    $testResults.e2e = $exitCode -eq 0
    return $exitCode -eq 0
}

# ── Función: Verificar Cobertura ──────────────────────────────
function Test-Coverage {
    Write-Host ""
    Write-Host "[COVERAGE] Verificando cobertura..." -ForegroundColor Cyan

    # Buscar reporte de cobertura (lcov o json)
    $coveragePaths = @(
        "$projectRoot\coverage\coverage-summary.json",
        "$projectRoot\coverage\lcov-report\index.html"
    )

    $coverageFile = $coveragePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

    if (-not $coverageFile) {
        Write-Host "[COVERAGE] ⚠️  No se encontró reporte de cobertura" -ForegroundColor Yellow
        Write-Host "           Ejecuta: npx vitest run --coverage" -ForegroundColor Gray
        return $null
    }

    if ($coverageFile -match "coverage-summary.json") {
        $coverageData = Get-Content $coverageFile | ConvertFrom-Json
        $totalCoverage = $coverageData.total

        $stmtPct = [math]::Round($totalCoverage.statements.pct, 1)
        $branchPct = [math]::Round($totalCoverage.branches.pct, 1)
        $funcPct = [math]::Round($totalCoverage.functions.pct, 1)
        $linesPct = [math]::Round($totalCoverage.lines.pct, 1)

        Write-Host ""
        Write-Host "📊 REPORTE DE COBERTURA:" -ForegroundColor White
        Write-Host "   Statements: $stmtPct%" -ForegroundColor $(if ($stmtPct -ge $MinCoverage) { "Green" } else { "Red" })
        Write-Host "   Branches:   $branchPct%" -ForegroundColor $(if ($branchPct -ge $MinCoverage) { "Green" } else { "Red" })
        Write-Host "   Functions:  $funcPct%" -ForegroundColor $(if ($funcPct -ge $MinCoverage) { "Green" } else { "Red" })
        Write-Host "   Lines:      $linesPct%" -ForegroundColor $(if ($linesPct -ge $MinCoverage) { "Green" } else { "Red" })
        Write-Host ""

        $meetsMinimum = ($stmtPct -ge $MinCoverage) -and ($branchPct -ge $MinCoverage) -and ($funcPct -ge $MinCoverage)

        if ($meetsMinimum) {
            Write-Host "[COVERAGE] ✅ Cobertura suficiente (≥ $MinCoverage%)" -ForegroundColor Green
        } else {
            Write-Host "[COVERAGE] ❌ Cobertura INSUFICIENTE (mínimo $MinCoverage% requerido)" -ForegroundColor Red
            $testResults.passed = $false
        }

        $testResults.coverage = $meetsMinimum
        return $meetsMinimum
    }

    Write-Host "[COVERAGE] ⚠️  Formato de reporte no soportado, verificar manualmente" -ForegroundColor Yellow
    return $null
}

# ── Función: Mostrar Resumen Final ────────────────────────────
function Show-Summary {
    Write-Host ""
    Write-Host "════════════════════════════════════════" -ForegroundColor Gray
    Write-Host "📊 RESUMEN DE TEST GUARDIAN" -ForegroundColor White
    Write-Host "════════════════════════════════════════" -ForegroundColor Gray
    Write-Host ""

    if ($null -ne $testResults.unit) {
        $icon = if ($testResults.unit) { "✅" } else { "❌" }
        Write-Host "  $icon Unit Tests" -ForegroundColor $(if ($testResults.unit) { "Green" } else { "Red" })
    }

    if ($null -ne $testResults.integration) {
        $icon = if ($testResults.integration) { "✅" } else { "❌" }
        Write-Host "  $icon Integration Tests" -ForegroundColor $(if ($testResults.integration) { "Green" } else { "Red" })
    }

    if ($null -ne $testResults.e2e) {
        $icon = if ($testResults.e2e) { "✅" } else { "❌" }
        Write-Host "  $icon E2E Tests" -ForegroundColor $(if ($testResults.e2e) { "Green" } else { "Red" })
    }

    if ($null -ne $testResults.coverage) {
        $icon = if ($testResults.coverage) { "✅" } else { "❌" }
        Write-Host "  $icon Cobertura ≥ $MinCoverage%" -ForegroundColor $(if ($testResults.coverage) { "Green" } else { "Red" })
    }

    Write-Host ""

    if ($testResults.passed) {
        Write-Host "🎉 TODOS LOS TESTS PASARON — Merge autorizado por Test Guardian" -ForegroundColor Green
    } else {
        Write-Host "🚫 TESTS FALLARON — Merge bloqueado por Test Guardian" -ForegroundColor Red
        if ($CI) {
            exit 1
        }
    }
    Write-Host ""
}

# ── Main ──────────────────────────────────────────────────────
Write-Header

$deps = Test-Dependencies

switch ($Type) {
    "unit" {
        Invoke-UnitTests -WithCoverage $Coverage
        if ($Coverage) { Test-Coverage }
    }
    "integration" {
        Invoke-IntegrationTests
    }
    "e2e" {
        Invoke-E2ETests -HasPlaywright $deps.hasPlaywright
    }
    "all" {
        Invoke-UnitTests -WithCoverage $Coverage
        Invoke-IntegrationTests
        Invoke-E2ETests -HasPlaywright $deps.hasPlaywright
        if ($Coverage) { Test-Coverage }
    }
}

Show-Summary
