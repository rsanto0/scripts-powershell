# ==============================
# Script: setup-github-ssh.ps1
# Gera chave SSH, configura no Windows e abre pagina do GitHub para adicionar
# ==============================

param (
    [string]$Email = ""
)

# Validar email
if (-not $Email) {
    $Email = Read-Host "Digite seu email do GitHub"
}

$sshKeyPath = "$env:USERPROFILE\.ssh\id_ed25519"

try {
    # 1. Criar pasta .ssh se nao existir
    if (-not (Test-Path -Path "$env:USERPROFILE\.ssh")) {
        New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.ssh" | Out-Null
        Write-Host "[OK] Pasta .ssh criada"
    }

    # 2. Gerar chave SSH ed25519
    if (-not (Test-Path "$sshKeyPath")) {
        ssh-keygen -t ed25519 -C $Email -f $sshKeyPath -N '""'
        Write-Host "[OK] Chave SSH gerada em: $sshKeyPath"
    } else {
        Write-Host "[AVISO] Ja existe uma chave SSH em $sshKeyPath"
    }

    # 3. Iniciar o ssh-agent
    try {
        if ((Get-Service ssh-agent).Status -ne 'Running') {
            Start-Process powershell -Verb RunAs -ArgumentList "Set-Service ssh-agent -StartupType Automatic; Start-Service ssh-agent" -Wait -WindowStyle Hidden
        }
        ssh-add $sshKeyPath 2>$null
        Write-Host "[OK] ssh-agent configurado"
    } catch {
        Write-Host "[AVISO] Erro no ssh-agent. Execute como administrador ou configure manualmente"
        Write-Host "Comando manual: ssh-add $sshKeyPath"
    }

    # 4. Copiar chave publica para area de transferencia
    $publicKey = Get-Content "$sshKeyPath.pub" -Raw
    Set-Clipboard $publicKey.Trim()
    Write-Host "[OK] Sua chave publica foi copiada para a area de transferencia."

    # 5. Mostrar chave publica
    Write-Host "`nSua chave publica:"
    Write-Host $publicKey -ForegroundColor Green

    # 6. Abrir pagina do GitHub para adicionar chave
    Write-Host "`nAbrindo pagina do GitHub para adicionar a chave..."
    Start-Process "https://github.com/settings/ssh/new"
    Write-Host "Cole a chave no GitHub e pressione Enter para testar a conexao..."
    Read-Host

    # 7. Teste de conexao com GitHub
    Write-Host "Testando conexao com GitHub..."
    Write-Host "Se aparecer pergunta sobre fingerprint, digite 'yes' e pressione Enter"
    Write-Host "Executando: ssh -T git@github.com"
    Write-Host "Para testar manualmente depois: ssh -T git@github.com" -ForegroundColor Yellow

} catch {
    Write-Host "[ERRO] $($_.Exception.Message)" -ForegroundColor Red
}