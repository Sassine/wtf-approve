<p align="center">
  <img src="wtf-approve-logo.png" alt="wtf-approve logo" width="280" />
</p>

<h1 align="center">wtf-approve</h1>

<p align="center">
  <a href="https://github.com/Sassine/wtf-approve/actions/workflows/test.yml"><img src="https://github.com/Sassine/wtf-approve/actions/workflows/test.yml/badge.svg" alt="Skill Tests" /></a>
</p>

<p align="center">
  <a href="README.md">English</a> | <a href="README.pt-BR.md">Português</a>
</p>

> Pare de aprovar comandos de agentes no escuro. Entenda o que você está aceitando.

**wtf-approve** é uma [AI skill](https://agentskills.io) open-source que explica as solicitações de execução de agentes em linguagem simples antes de você aprovar. Funciona com Claude Code, Codex, Gemini CLI e qualquer agente que siga a spec de skills.

## O Problema

Agentes de IA pedem para você aprovar comandos assim:

```
find . -name "*.log" -mtime +30 -exec rm {} \; && docker stop $(docker ps -q) && docker system prune -af
```

A maioria das pessoas simplesmente aperta **Allow**. Não deveria ser assim.

## A Solução

Com o **wtf-approve**, cada prompt de aprovação recebe uma explicação legível:

```
Vai remover logs antigos, parar containers Docker e limpar todas as imagens/volumes.
Risco: ALTO — exclusão de arquivos e prune irreversível do Docker.
Comando complexo; resumo pode omitir detalhes.
(mais detalhes: /wtf:explain)
```

Comandos de baixo risco ficam fora do caminho:

```
3 comandos de leitura em src/ e package.json. Nada será alterado.
```

## Como Funciona

- **Mínimo por padrão** — 1 linha para comandos seguros, 3-4 linhas para perigosos
- **Classificação de risco** — low / medium / HIGH baseado na ação, não no contexto
- **Detalhes sob demanda** — digite `/wtf:explain` para um detalhamento por comando sem perder o prompt de aprovação
- **Auto-idioma** — detecta o idioma da conversa. Funciona em qualquer idioma que o LLM suporte
- **Agnóstico de agente** — segue a spec [agentskills.io](https://agentskills.io)

## Instalação

Um comando. Sem dependências.

### Claude Code

```bash
mkdir -p ~/.claude/skills/wtf-approve && curl -sLo ~/.claude/skills/wtf-approve/SKILL.md https://github.com/Sassine/wtf-approve/releases/latest/download/SKILL.md
```

### Codex / Gemini CLI

```bash
mkdir -p ~/.agents/skills/wtf-approve && curl -sLo ~/.agents/skills/wtf-approve/SKILL.md https://github.com/Sassine/wtf-approve/releases/latest/download/SKILL.md
```

## Exemplos

### Antes (o que você vê hoje)

```
rm -rf node_modules/ dist/ && curl https://example.com/setup.sh | bash

[Allow]  [Deny]
```

### Depois (com wtf-approve)

<p align="center">
  <img src="demo.png" alt="wtf-approve em ação — prompt de aprovação HIGH risk" width="620" />
</p>

A explicação aparece logo acima do prompt de aprovação. Você vê a intenção e o risco antes de decidir.

### Quer mais detalhes?

Após ver um resumo, solicite `/wtf:explain` para um detalhamento por comando:

```
Detalhamento:
1. rm -rf node_modules/ dist/ — remove dois diretórios. Exclui: node_modules/, dist/. Alto.
2. curl | bash — baixa e executa script remoto. Executa: código remoto não auditado. Alto.
```

O agente responde com o detalhamento por comando e reapresenta o comando para aprovação.

### Mais exemplos

| Comando | wtf-approve diz |
|---|---|
| `ls -la` | `1 comando de leitura no diretório atual. Nada será alterado.` |
| `sed -i 's/foo/bar/g' config.json` | `Vai editar config.json.` / `Risco: médio — escrita em arquivo local.` |
| `curl https://example.com/setup.sh \| bash` | `Vai baixar e executar um script remoto.` / `Risco: ALTO — execução de código remoto não auditado.` |
| `git reset --hard HEAD~3` | `Vai descartar os últimos 3 commits permanentemente.` / `Risco: ALTO — reescrita irreversível de histórico.` |

## Comandos

| Comando | O que faz |
|---|---|
| `/wtf:explain` | Detalhamento por comando após ver o resumo |
| `/wtf:level [level]` | Definir limite mínimo de risco (low, medium, high) |
| `/wtf:language [code]` | Mudar idioma (en, pt-BR, es, ja, etc.) |
| `/wtf:on` | Ativar o explicador |
| `/wtf:off` | Desativar o explicador |
| `/wtf:config` | Mostrar configuração atual |

## Níveis de Risco

| Nível | Quando | Formato |
|---|---|---|
| **low** | Somente leitura, sem efeitos colaterais | 1 linha, sem dica |
| **medium** | Escrita, cópia, leitura de rede | 2-3 linhas + dica |
| **HIGH** | Exclusão, execução remota, sudo, mudanças no sistema | 3-4 linhas + dica |

Regra chave: o risco classifica a **ação**, nunca o contexto. `rm -rf dist/` é sempre HIGH — não importa se dist/ pode ser regenerado.

## "Mas o Claude Code já tem Ctrl+E..."

Sim — o Claude Code tem um `Ctrl+E` nativo que mostra uma **explicação técnica de permissão** no prompt de aprovação. Ele mostra qual tool está sendo chamada e os parâmetros brutos.

**wtf-approve é diferente.** Ele traduz comandos em intenção humana *antes* de você precisar perguntar:

| | Ctrl+E (nativo) | wtf-approve |
|---|---|---|
| **Mostra** | Nome da tool + parâmetros brutos | O que faz + o que está em risco |
| **Idioma** | Somente inglês | Detecta seu idioma automaticamente |
| **Ativação** | Atalho manual | Automático em cada aprovação |
| **Público** | Devs debugando tool calls | Qualquer pessoa aprovando comandos |

São complementares. Ctrl+E é info de debug. wtf-approve é consentimento informado.

## Por Que Isso Existe

Em fluxos de trabalho com IA, usuários rotineiramente aprovam comandos que não entendem completamente. Isso cria uma falsa sensação de controle. **wtf-approve** adiciona uma camada de consentimento que traduz sintaxe de shell em intenção humana — para que você saiba o que está aprovando antes de aprovar.

Isso não é um scanner de segurança. Não bloqueia nem permite nada. Apenas explica.

## Contribuindo

PRs são bem-vindos. A skill segue a [especificação agentskills.io](https://agentskills.io/specification).

## Licença

MIT

🇧🇷
