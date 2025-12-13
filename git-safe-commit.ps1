# Script : git-safe-commit.ps1

# Vérifier qu'on est dans un repo Git
if (-not (Test-Path ".git")) {
    Write-Error "Pas un répertoire Git !"
    exit 1
}

# 1. BONNE PRATIQUE: Pull avant pour éviter les conflits
Write-Host "🔄 Récupération des dernières modifications..." -ForegroundColor Yellow
git pull origin master
if ($LASTEXITCODE -ne 0) {
    Write-Error "Erreur lors du pull. Arrêt."
    exit 1
}

# 2. Vérifier s'il y a des changements à committer
git status --porcelain | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "✅ Aucune modification à committer." -ForegroundColor Green
    exit 0
}

# 3. Message de commit avec date/heure + stats
$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$stats = git diff --stat --cached | Select-Object -Last 1
$commitMessage = "Auto-update $now`n`n$stats"

# 4. Ajouter, committer et push
Write-Host "➕ Ajout des modifications..." -ForegroundColor Yellow
git add .

Write-Host "✅ Commit: $commitMessage" -ForegroundColor Green
git commit -m $commitMessage

Write-Host "🚀 Push vers master..." -ForegroundColor Yellow
git push origin master
