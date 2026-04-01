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

A maioria das pessoas simplesmente aperta **Allow**. Nao deveria ser assim.

## A Solucao

Com o **wtf-approve**, cada prompt de aprovacao recebe uma explicacao legivel:

```
Vai remover logs antigos, parar containers Docker e limpar todas as imagens/volumes.
Risco: ALTO — exclusao de arquivos e prune irreversivel do Docker.
Comando complexo; resumo pode omitir detalhes.
(mais detalhes: /wtf:explain)
```

Comandos de baixo risco ficam fora do caminho:

```
3 comandos de leitura em src/ e package.json. Nada sera alterado.
```

## Como Funciona

- **Minimo por padrao** — 1 linha para comandos seguros, 3-4 linhas para perigosos
- **Classificacao de risco** — low / medium / HIGH baseado na acao, nao no contexto
- **Detalhes sob demanda** — digite `/wtf:explain` para um detalhamento por comando sem perder o prompt de aprovacao
- **Auto-idioma** — detecta o idioma da conversa. Funciona em qualquer idioma que o LLM suporte
- **Agnostico de agente** — segue a spec [agentskills.io](https://agentskills.io)

## Instalacao

Um comando. Sem dependencias.

### Claude Code

```bash
mkdir -p ~/.claude/skills/wtf-approve && curl -sLo ~/.claude/skills/wtf-approve/SKILL.md https://github.com/Sassine/wtf-approve/releases/latest/download/SKILL.md
```

### Codex / Gemini CLI

```bash
mkdir -p ~/.agents/skills/wtf-approve && curl -sLo ~/.agents/skills/wtf-approve/SKILL.md https://github.com/Sassine/wtf-approve/releases/latest/download/SKILL.md
```

## Exemplos

### Antes (o que voce ve hoje)

```
rm -rf node_modules/ dist/ && curl https://example.com/setup.sh | bash

[Allow]  [Deny]
```

### Depois (com wtf-approve)

<p align="center">
  <img src="demo.png" alt="wtf-approve em acao — prompt de aprovacao HIGH risk" width="620" />
</p>

A explicacao aparece logo acima do prompt de aprovacao. Voce ve a intencao e o risco antes de decidir.

### Quer mais detalhes? Tab to amend

No prompt de aprovacao, pressione **Tab to amend** e digite `/wtf:explain`:

```
Detalhamento:
1. rm -rf node_modules/ dist/ — remove dois diretorios. Exclui: node_modules/, dist/. Alto.
2. curl | bash — baixa e executa script remoto. Executa: codigo remoto nao auditado. Alto.
```

O agente responde com o detalhamento por comando e reapresenta o comando para aprovacao.

### Mais exemplos

| Comando | wtf-approve diz |
|---|---|
| `ls -la` | `1 comando de leitura no diretorio atual. Nada sera alterado.` |
| `sed -i 's/foo/bar/g' config.json` | `Vai editar config.json.` / `Risco: medio — escrita em arquivo local.` |
| `curl https://example.com/setup.sh \| bash` | `Vai baixar e executar um script remoto.` / `Risco: ALTO — execucao de codigo remoto nao auditado.` |
| `git reset --hard HEAD~3` | `Vai descartar os ultimos 3 commits permanentemente.` / `Risco: ALTO — reescrita irreversivel de historico.` |

## Comandos

| Comando | O que faz |
|---|---|
| `/wtf:explain` | Detalhamento por comando (Tab to amend no prompt de aprovacao) |
| `/wtf:language [code]` | Mudar idioma (en, pt-BR, es, ja, etc.) |
| `/wtf:on` | Ativar o explicador |
| `/wtf:off` | Desativar o explicador |
| `/wtf:config` | Mostrar configuracao atual |

## Niveis de Risco

| Nivel | Quando | Formato |
|---|---|---|
| **low** | Somente leitura, sem efeitos colaterais | 1 linha, sem dica |
| **medium** | Escrita, copia, leitura de rede | 2-3 linhas + dica |
| **HIGH** | Exclusao, execucao remota, sudo, mudancas no sistema | 3-4 linhas + dica |

Regra chave: o risco classifica a **acao**, nunca o contexto. `rm -rf dist/` e sempre HIGH — nao importa se dist/ pode ser regenerado.

## "Mas o Claude Code ja tem Ctrl+E..."

Sim — o Claude Code tem um `Ctrl+E` nativo que mostra uma **explicacao tecnica de permissao** no prompt de aprovacao. Ele mostra qual tool esta sendo chamada e os parametros brutos.

**wtf-approve e diferente.** Ele traduz comandos em intencao humana *antes* de voce precisar perguntar:

| | Ctrl+E (nativo) | wtf-approve |
|---|---|---|
| **Mostra** | Nome da tool + parametros brutos | O que faz + o que esta em risco |
| **Idioma** | Somente ingles | Detecta seu idioma automaticamente |
| **Ativacao** | Atalho manual | Automatico em cada aprovacao |
| **Publico** | Devs debugando tool calls | Qualquer pessoa aprovando comandos |

Sao complementares. Ctrl+E e info de debug. wtf-approve e consentimento informado.

## Por Que Isso Existe

Em fluxos de trabalho com IA, usuarios rotineiramente aprovam comandos que nao entendem completamente. Isso cria uma falsa sensacao de controle. **wtf-approve** adiciona uma camada de consentimento que traduz sintaxe de shell em intencao humana — para que voce saiba o que esta aprovando antes de aprovar.

Isso nao e um scanner de seguranca. Nao bloqueia nem permite nada. Apenas explica.

## Contribuindo

PRs sao bem-vindos. A skill segue a [especificacao agentskills.io](https://agentskills.io/specification).

## Licenca

MIT

🇧🇷
