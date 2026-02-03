$brainPath = "$HOME\.antigravity"

# Nota: Usuario debe configurar su URL de Git una vez
Write-Host "Sincronizando Brain con GitHub..." -ForegroundColor Cyan

if (Test-Path "$brainPath\.git") {
    Push-Location $brainPath
    git pull
    git add .
    git commit -m "Sync $(Get-Date)" --allow-empty
    git push
    Pop-Location
    Write-Host "Brain sincronizado exitosamente" -ForegroundColor Green
} else {
    Write-Host "Advertencia: .antigravity no es un repo de Git aún." -ForegroundColor Yellow
    Write-Host "Ejecuta: cd $brainPath; git init; git remote add origin [URL]" -ForegroundColor Yellow
}
