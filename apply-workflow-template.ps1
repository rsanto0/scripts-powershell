# Script para aplicar template Postman em repositorios existentes

param(
    [string]$RepositoryPath,
    [string]$TemplatePath = "postman-workflow-template"
)

# Pergunta o caminho do repositorio se nao fornecido
if (-not $RepositoryPath) {
    $RepositoryPath = Read-Host "Digite o caminho do repositorio"
}

Write-Host "Aplicando template Postman em: $RepositoryPath" -ForegroundColor Green

# Verifica se o repositorio existe
if (-not (Test-Path $RepositoryPath)) {
    Write-Host "Repositorio nao encontrado: $RepositoryPath" -ForegroundColor Red
    exit 1
}

# Verifica se o template existe
if (-not (Test-Path $TemplatePath)) {
    Write-Host "Template nao encontrado: $TemplatePath" -ForegroundColor Red
    exit 1
}

# Cria estrutura .github/workflows se nao existir
$workflowDir = Join-Path $RepositoryPath ".github\workflows"
if (-not (Test-Path $workflowDir)) {
    Write-Host "Criando diretorio: $workflowDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $workflowDir -Force | Out-Null
}

# Copia o workflow
$sourceWorkflow = Join-Path $TemplatePath ".github\workflows\sync-postman.yml"
$targetWorkflow = Join-Path $workflowDir "sync-postman.yml"

if (Test-Path $sourceWorkflow) {
    Copy-Item $sourceWorkflow $targetWorkflow -Force
    Write-Host "Workflow copiado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "Workflow nao encontrado no template" -ForegroundColor Red
    exit 1
}

# Verifica se existe collection *-postman.json
$collections = Get-ChildItem -Path $RepositoryPath -Name "*-postman.json"
if ($collections.Count -eq 0) {
    Write-Host "Nenhuma collection *-postman.json encontrada" -ForegroundColor Yellow
    Write-Host "Crie um arquivo seguindo o padrao: projeto-postman.json" -ForegroundColor Cyan
} else {
    Write-Host "Collection encontrada: $($collections[0])" -ForegroundColor Green
}

Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor Cyan
Write-Host "1. Configure os secrets no GitHub:" -ForegroundColor White
Write-Host "   - POSTMAN_API_KEY" -ForegroundColor Gray
Write-Host "2. Faca commit e push dos arquivos" -ForegroundColor White
Write-Host "3. O workflow executara automaticamente!" -ForegroundColor White