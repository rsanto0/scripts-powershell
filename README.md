# Scripts PowerShell para GitHub

Coleção de scripts para automatizar configuração e envio de código para o GitHub.

## 📋 Scripts Disponíveis

### 1. `setup-github-ssh.ps1`
**Configuração inicial de chaves SSH para GitHub**

#### Funcionalidades:
- ✅ Cria pasta `.ssh` se não existir
- ✅ Gera chave SSH ed25519 (mais segura)
- ✅ Configura ssh-agent do Windows
- ✅ Copia chave pública para área de transferência
- ✅ Abre página do GitHub para adicionar chave
- ✅ Orienta teste de conexão

#### Como usar:
```powershell
# Com email
.\setup-github-ssh.ps1 -Email "seu@email.com"

# Sem email (pergunta interativamente)
.\setup-github-ssh.ps1
```

#### Arquivos criados:
- `~/.ssh/id_ed25519` (chave privada)
- `~/.ssh/id_ed25519.pub` (chave pública)

---

### 2. `git_setup.ps1`
**Setup completo com Personal Access Token**

#### Funcionalidades:
- ✅ Inicializa repositório Git
- ✅ Configura nome e email do Git
- ✅ Adiciona arquivos e faz commit
- ✅ Cria repositório no GitHub via API
- ✅ Configura remote HTTPS
- ✅ Faz push para GitHub

#### Como usar:
```powershell
.\git_setup.ps1
```

#### Requisitos:
- Personal Access Token do GitHub
- Permissão `repo` no token

#### Fluxo:
1. Pergunta configurações do Git
2. Solicita mensagem de commit
3. Pergunta usuário e nome do repositório
4. Solicita Personal Access Token
5. Cria repositório automaticamente
6. Envia código via HTTPS

---

### 3. `git_setup_ssh.ps1`
**Setup híbrido com SSH (recomendado)**

#### Funcionalidades:
- ✅ Verifica se existe chave SSH
- ✅ Inicializa repositório Git
- ✅ Configura nome e email do Git
- ✅ Adiciona arquivos e faz commit
- ✅ Sugere nome da pasta como padrão
- ✅ Pergunta se repositório já existe
- ✅ Cria repositório via API (se necessário)
- ✅ Configura remote SSH
- ✅ Testa conexão SSH
- ✅ Faz push via SSH

#### Como usar:
```powershell
# 1. Configure SSH primeiro (uma vez só)
.\setup-github-ssh.ps1

# 2. Use o script principal
.\git_setup_ssh.ps1
```

#### Fluxo Inteligente:

**Se repositório JÁ EXISTE no GitHub:**
- Usa apenas SSH (sem token)
- Push direto via SSH

**Se repositório NÃO EXISTE:**
- Solicita token apenas para criar
- Usa SSH para push

#### Vantagens:
- 🔒 **Mais seguro** - SSH não expira
- 🚀 **Mais rápido** - SSH é mais eficiente
- 🎯 **Inteligente** - Token só quando necessário
- 📁 **Conveniente** - Sugere nome da pasta

---

## 🚀 Fluxo Recomendado

### Primeira vez (configuração):
```powershell
# 1. Configure SSH (uma vez só)
.\setup-github-ssh.ps1

# 2. Use para todos os projetos
.\git_setup_ssh.ps1
```

### Projetos seguintes:
```powershell
# Apenas isso
.\git_setup_ssh.ps1
```

---

## 📋 Pré-requisitos

### Software:
- ✅ PowerShell 7+ (recomendado)
- ✅ Git instalado
- ✅ Conta no GitHub

### Tokens/Chaves:
- ✅ Chave SSH configurada (via `setup-github-ssh.ps1`)
- ✅ Personal Access Token (só se criar repositórios)

---

## 🔧 Configuração do Personal Access Token

1. Acesse: https://github.com/settings/tokens
2. Clique "Generate new token (classic)"
3. Marque permissão: `repo`
4. Copie o token gerado

---

## 🛠️ Troubleshooting

### Erro de SSH:
```powershell
# Teste manual
ssh -T git@github.com

# Reconfigurar SSH
.\setup-github-ssh.ps1
```

### Erro de PowerShell 5.1:
```powershell
# Instalar PowerShell 7
winget install Microsoft.PowerShell

# Usar PowerShell 7
pwsh
```

### Erro de codificação:
```powershell
# Configurar UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
```

---

## 📁 Estrutura de Arquivos

```
scripts-powershell/
├── setup-github-ssh.ps1    # Configuração SSH
├── git_setup.ps1           # Setup com token
├── git_setup_ssh.ps1       # Setup híbrido (recomendado)
└── README.md               # Esta documentação
```

---

## 🎯 Qual Script Usar?

| Cenário | Script Recomendado |
|---------|-------------------|
| **Primeira vez** | `setup-github-ssh.ps1` + `git_setup_ssh.ps1` |
| **Uso diário** | `git_setup_ssh.ps1` |
| **Sem SSH** | `git_setup.ps1` |
| **Repositório existe** | `git_setup_ssh.ps1` |

---

## 📝 Notas

- Scripts otimizados para **PowerShell 7**
- Compatível com **PowerShell 5.1** (versão sem acentos)
- **SSH é mais seguro** que tokens para uso diário
- Tokens são necessários apenas para **criar repositórios**