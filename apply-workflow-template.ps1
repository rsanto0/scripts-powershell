# Script para aplicar template Postman em repositórios existentes

param(
    [string]$RepositoryPath,
    [string]$TemplatePath = "postman-workflow-template"
)

# Pergunta o caminho do repositório se não fornecido
if (-not $RepositoryPath) {
    $RepositoryPath = Read-Host "📁 Digite o caminho do repositório"
}

Write-Host "🚀 Aplicando template Postman em: $RepositoryPath" -ForegroundColor Green

# Verifica se o repositório existe
if (-not (Test-Path $RepositoryPath)) {
    Write-Host "❌ Repositório não encontrado: $RepositoryPath" -ForegroundColor Red
    exit 1
}

# Verifica se o template existe
if (-not (Test-Path $TemplatePath)) {
    Write-Host "❌ Template não encontrado: $TemplatePath" -ForegroundColor Red
    exit 1
}

# Cria estrutura .github/workflows se não existir
$workflowDir = Join-Path $RepositoryPath ".github\workflows"
if (-not (Test-Path $workflowDir)) {
    Write-Host "📁 Criando diretório: $workflowDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $workflowDir -Force | Out-Null
}

# Copia o workflow
$sourceWorkflow = Join-Path $TemplatePath ".github\workflows\sync-postman.yml"
$targetWorkflow = Join-Path $workflowDir "sync-postman.yml"

if (Test-Path $sourceWorkflow) {
    Copy-Item $sourceWorkflow $targetWorkflow -Force
    Write-Host "✅ Workflow copiado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "❌ Workflow não encontrado no template" -ForegroundColor Red
    exit 1
}

# Verifica se existe collection *-postman.json
$collections = Get-ChildItem -Path $RepositoryPath -Name "*-postman.json"
if ($collections.Count -eq 0) {
    Write-Host "⚠️  Nenhuma collection *-postman.json encontrada" -ForegroundColor Yellow
    Write-Host "📝 Crie um arquivo seguindo o padrão: projeto-postman.json" -ForegroundColor Cyan
} else {
    Write-Host "✅ Collection encontrada: $($collections[0])" -ForegroundColor Green
}

Write-Host ""
Write-Host "🔧 Próximos passos:" -ForegroundColor Cyan
Write-Host "1. Configure os secrets no GitHub:" -ForegroundColor White
Write-Host "   - POSTMAN_API_KEY" -ForegroundColor Gray
Write-Host "   - GH_TOKEN" -ForegroundColor Gray
Write-Host "2. Faça commit e push dos arquivos" -ForegroundColor White
Write-Host "3. O workflow executará automaticamente!" -ForegroundColor White