# Script de Setup para GitHub - PowerShell
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    SCRIPT DE SETUP PARA GITHUB" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se ja existe repositorio Git
if (Test-Path ".git") {
    Write-Host "Repositorio Git ja existe nesta pasta." -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "Inicializando repositorio Git..." -ForegroundColor Green
    git init
    Write-Host ""
}

# Verificar configuracao do Git
$gitName = git config --global user.name 2>$null
$gitEmail = git config --global user.email 2>$null

if (-not $gitName) {
    $gitName = Read-Host "Digite seu nome para o Git"
    git config --global user.name $gitName
}

if (-not $gitEmail) {
    $gitEmail = Read-Host "Digite seu email para o Git"
    git config --global user.email $gitEmail
}

Write-Host "Configuracao atual:" -ForegroundColor Blue
Write-Host "Nome: $gitName"
Write-Host "Email: $gitEmail"
Write-Host ""

# Adicionar arquivos
Write-Host "Adicionando arquivos..." -ForegroundColor Green
git add .
Write-Host ""

# Commit
$commitMsg = Read-Host "Digite a mensagem do commit (ou Enter para Initial commit)"
if (-not $commitMsg) { $commitMsg = "Initial commit" }
git commit -m $commitMsg
Write-Host ""

# Informacoes do repositorio GitHub
$githubUser = Read-Host "Digite seu usuario do GitHub"
$repoName = Read-Host "Digite o nome do repositorio no GitHub"
$githubToken = Read-Host "Digite seu Personal Access Token do GitHub" -AsSecureString
$token = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($githubToken))
Write-Host ""

# Criar repositorio no GitHub
Write-Host "Criando repositorio no GitHub..." -ForegroundColor Green
$body = @{
    name = $repoName
    private = $false
} | ConvertTo-Json

$headers = @{
    "Authorization" = "token $token"
    "Content-Type" = "application/json"
}

try {
    $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Body $body -Headers $headers
    Write-Host "Repositorio criado com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "Repositorio pode ja existir ou houve erro. Continuando..." -ForegroundColor Yellow
}
Write-Host ""

# Adicionar remote
git remote remove origin 2>$null
git remote add origin "https://github.com/$githubUser/$repoName.git"

# Push
Write-Host "Enviando codigo para o GitHub..." -ForegroundColor Green
git branch -M main
git push -u origin main

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   CODIGO ENVIADO COM SUCESSO!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Repositorio: https://github.com/$githubUser/$repoName" -ForegroundColor Blue
Read-Host "Pressione Enter para sair"