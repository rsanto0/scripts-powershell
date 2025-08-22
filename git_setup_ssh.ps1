# Script de Setup para GitHub com SSH - PowerShell 7
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    SCRIPT DE SETUP PARA GITHUB (SSH)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se existe chave SSH
$sshKeyPath = "$env:USERPROFILE\.ssh\id_ed25519"
if (-not (Test-Path $sshKeyPath)) {
    Write-Host "❌ Chave SSH não encontrada!" -ForegroundColor Red
    Write-Host "Execute primeiro: .\setup-github-ssh.ps1" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit
}

Write-Host "✅ Chave SSH encontrada" -ForegroundColor Green
Write-Host ""

# Verificar se já existe repositório Git
if (Test-Path ".git") {
    Write-Host "Repositório Git já existe nesta pasta." -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "Inicializando repositório Git..." -ForegroundColor Green
    git init
    Write-Host ""
}

# Verificar configuração do Git
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

Write-Host "Configuração atual:" -ForegroundColor Blue
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

# Informações do repositório GitHub
$githubUser = Read-Host "Digite seu usuário do GitHub"
$repoName = Read-Host "Digite o nome do repositório no GitHub"
Write-Host ""

# Perguntar se repositório já existe
$repoExists = Read-Host "O repositório '$repoName' já existe no GitHub? (s/n)"

if ($repoExists -ne 's' -and $repoExists -ne 'S') {
    # Repositório não existe - criar via API
    Write-Host ""
    Write-Host "📝 Criando repositório no GitHub..." -ForegroundColor Yellow
    $githubToken = Read-Host "Digite seu Personal Access Token do GitHub" -AsSecureString
    $token = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($githubToken))
    
    # Criar repositório via API
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
        Write-Host "✅ Repositório criado com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Erro ao criar repositório:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host ""
        Write-Host "Criando manualmente..." -ForegroundColor Yellow
        Start-Process "https://github.com/new"
        Read-Host "Crie o repositório manualmente e pressione Enter para continuar"
    }
    Write-Host ""
}

# Adicionar remote SSH
Write-Host "Configurando remote SSH..." -ForegroundColor Green
git remote remove origin 2>$null
git remote add origin "git@github.com:$githubUser/$repoName.git"

# Testar conexão SSH
Write-Host "Testando conexão SSH com GitHub..." -ForegroundColor Green
$sshTest = ssh -T git@github.com 2>&1
if ($sshTest -match "successfully authenticated") {
    Write-Host "✅ Conexão SSH funcionando!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Teste de SSH:" -ForegroundColor Yellow
    Write-Host $sshTest
}
Write-Host ""

# Push
Write-Host "Enviando código para o GitHub via SSH..." -ForegroundColor Green
git branch -M main
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "   CÓDIGO ENVIADO COM SUCESSO!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Repositório: https://github.com/$githubUser/$repoName" -ForegroundColor Blue
} else {
    Write-Host ""
    Write-Host "❌ Erro no push. Verifique se:" -ForegroundColor Red
    Write-Host "1. O repositório existe no GitHub" -ForegroundColor Yellow
    Write-Host "2. Sua chave SSH está configurada corretamente" -ForegroundColor Yellow
    Write-Host "3. Você tem permissão no repositório" -ForegroundColor Yellow
}

Read-Host "Pressione Enter para sair"