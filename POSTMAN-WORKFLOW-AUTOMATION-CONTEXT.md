# Contexto: Scripts PowerShell para Automação

## 📍 Localização
`C:\Area_de_Tecnologia\wksp-eclipse\scripts-powershell`

## 🎯 Propósito
Coleção de scripts PowerShell para automatizar configuração Git/GitHub e sincronização com Postman.

## 📁 Estrutura Atual

### Scripts Principais
- `apply-workflow-template.ps1` - Aplica template de workflow GitHub Actions
- `git_setup_complete.ps1` - Setup completo Git/GitHub (legado)

### Templates
- `postman-workflow-template/` - Template para sincronização automática Postman
  - `.github/workflows/sync-postman.yml` - Workflow GitHub Actions

## 🔧 Scripts Disponíveis

### `apply-workflow-template.ps1`
**Função:** Aplica template de workflow para sincronização Postman em repositórios existentes

**Uso:**
```powershell
.\apply-workflow-template.ps1 -RepositoryPath "C:\caminho\do\projeto"
# ou interativo
.\apply-workflow-template.ps1
```

**O que faz:**
- Cria estrutura `.github/workflows/` se não existir
- Copia workflow `sync-postman.yml` do template
- Verifica se existe collection `*-postman.json`
- Orienta configuração de secrets

## 🚀 Workflow Postman (sync-postman.yml)

### Triggers
- Push em arquivos `*-postman.json`
- Execução manual via GitHub Actions

### Funcionalidades
- ✅ Detecta collections `*-postman.json` automaticamente
- ✅ Cria collections no Postman via API
- ✅ Remove IDs customizados (incompatíveis com Postman)
- ✅ Atualiza arquivo local com ID real do Postman
- ✅ Debug completo para troubleshooting

### Secrets Necessários
- `POSTMAN_API_KEY` - Chave da API do Postman (obrigatório)

### Exemplo de Uso
1. Adicione collection `projeto-postman.json` no repositório
2. Configure secret `POSTMAN_API_KEY` no GitHub
3. Faça push - workflow executa automaticamente
4. Collection é criada/atualizada no Postman

## 🔍 Troubleshooting Resolvido

### Problema: "Invalid API Key"
**Solução:** Configurar `POSTMAN_API_KEY` nos secrets do repositório

### Problema: "The specified uid is invalid"
**Solução:** Workflow remove IDs customizados e deixa Postman gerar automaticamente

### Problema: "Parameter is missing (collection)"
**Solução:** Workflow envolve JSON no formato `{"collection": {...}}`

## 📊 Status dos Projetos

### ✅ Configurados
- `auth-service` - Workflow funcionando, collection sincronizada

### 🔄 Pendentes
- `sistema-ponto` - Aplicar template
- `api-gateway` - Aplicar template

## 🎯 Próximos Passos

1. **Aplicar template em outros projetos:**
   ```powershell
   .\apply-workflow-template.ps1 -RepositoryPath "C:\Area_de_Tecnologia\wksp-eclipse\sistema-ponto"
   ```

2. **Criar collections Postman** para projetos que não têm

3. **Configurar secrets** nos repositórios GitHub

## 💡 Melhorias Futuras

- [ ] Script para criar collections Postman automaticamente
- [ ] Template para outros tipos de workflow
- [ ] Integração com Newman para testes automatizados
- [ ] Versionamento de collections

## 🔗 Links Úteis

- **Postman API:** https://documenter.getpostman.com/view/631643/JsLs/
- **GitHub Actions:** https://docs.github.com/en/actions
- **PowerShell:** https://docs.microsoft.com/en-us/powershell/

---
**Última atualização:** Workflow Postman funcionando com debug completo
**Responsável:** Automação de DevOps para microserviços Spring Boot