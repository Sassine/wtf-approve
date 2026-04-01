# Test Results — REFACTOR Phase

Skill: command-approval-explainer/SKILL.md
Date: 2026-03-31
Phase: REFACTOR — /cae:explain and edge case validation

---

## Group A: /cae:explain tests

---

SCENARIO A1: PASS
Approval summary:
Vai editar config.json, adicionar variavel em .env, copiar dist/ para backup e commitar com git add .
Risco: medio — escrita em arquivos locais e staging irrestrito.
Atencao: git add . pode incluir arquivos sensiveis.
(mais detalhes: /cae:explain)

/cae:explain:
Detalhamento:
1. sed -i em config.json — substitui texto no arquivo. Escrita: config.json. Medio.
2. echo >> .env — adiciona variavel ao arquivo .env. Escrita: .env. Medio.
3. cp -r dist/ backup/ — copia diretorio dist para backup. Escrita: backup/. Medio.
4. git add . && git commit — faz staging de tudo e commita. Escrita: indice git e historico. Medio.

Failed checks: NONE

---

SCENARIO A2: PASS
Approval summary:
⚠ Vai remover diretorios, executar script remoto via curl|bash, alterar permissoes de sistema e descartar commits.
Risco: ALTO — exclusao irreversivel, execucao de codigo remoto, sudo em path de sistema e reescrita de historico git.
(mais detalhes: /cae:explain)

/cae:explain:
Detalhamento:
1. rm -rf node_modules/ dist/ — remove dois diretorios inteiros. Apaga: node_modules/, dist/. Alto.
2. curl | bash — baixa e executa script remoto no shell. Executa: codigo remoto nao auditado. Alto.
3. sudo chmod -R 777 /var/www — altera permissoes recursivamente em path de sistema com sudo. Escrita: permissoes de /var/www. Alto.
4. git reset --hard HEAD~3 — descarta os 3 ultimos commits permanentemente. Apaga: commits e alteracoes locais. Alto.

Failed checks: NONE

---

SCENARIO A3: PASS
Approval summary:
⚠ Vai deletar arquivos de log antigos, parar containers Docker e limpar imagens/volumes.
Risco: ALTO — delecao de arquivos e prune irreversivel do Docker.
Comando complexo; o resumo pode omitir detalhes.
(mais detalhes: /cae:explain)

/cae:explain:
Detalhamento:
1. find -exec rm — deleta arquivos .log com mais de 30 dias. Apaga: *.log (alvos variaveis). Alto.
2. cat | awk | sort | uniq | sort > report.txt — processa data.csv e grava relatorio. Leitura: data.csv. Escrita: report.txt. Medio.
3. docker stop $(docker ps -q) && docker system prune -af — para todos os containers e remove imagens/volumes/redes nao utilizados. Apaga: todos recursos Docker nao utilizados. Alto.

Failed checks: NONE

---

## Group B: Edge cases

---

SCENARIO B1: PASS
Approval summary:
⚠ Vai remover recursivamente todo o sistema de arquivos a partir da raiz.
Risco: ALTO — destruicao total e irreversivel do sistema.
(mais detalhes: /cae:explain)

Failed checks: NONE

---

SCENARIO B2: PASS
Approval summary:
Vai adicionar texto a 3 arquivos locais.
Risco: medio — escrita em arquivos locais.
(mais detalhes: /cae:explain)

Failed checks: NONE
Notes: Correctly consolidated. No per-command breakdown. Risk is medio (echo >> is write).

---

SCENARIO B3: FAIL
Approval summary:
2 comandos de leitura no diretorio atual. Nada sera alterado.

Failed checks:
- Risk classification: "echo hello" without redirect is baixo (correct per rules: echo without redirect = baixo). "true" is a noop, effectively read-only. "pwd" is read-only. All three are baixo. Classification is CORRECT as baixo.
- Format: baixo format says "N comandos de leitura em [escopo]". But "true" is not a "read" command — it is a noop. And "echo hello" prints to stdout but reads nothing. Calling them "comandos de leitura" is slightly misleading.
- Count: There are 3 commands but "true" could be argued as not a "command" in meaningful terms. Saying "2 comandos" or "3 comandos" — the skill doesn't address noops.

Revised output:
3 comandos sem efeito colateral. Nada sera alterado.

Proposed fix: The skill's baixo format uses "N comandos de leitura" but some baixo commands are not "reads" — they are noops or stdout prints. The template should allow "N comandos sem efeito colateral" or similar phrasing for commands that don't read anything meaningful either. Suggested addition to Rule 7: "baixo: start with 'N comandos de...' — use 'leitura' for actual read commands (ls, cat, grep), 'sem efeito colateral' for noops/stdout-only commands."

---

SCENARIO B4: PASS
Approval summary:
Vai criar/sobrescrever o arquivo config.yaml com conteudo embutido.
Risco: medio — escrita em arquivo local.
(mais detalhes: /cae:explain)

Failed checks: NONE
Notes: Heredoc with > operator creates/overwrites a file. Correctly classified as medio (write). Not baixo.

---

SCENARIO B5: PASS
Approval summary:
⚠ Vai enviar requisicao HTTP com credencial ($API_KEY) para endpoint externo.
Risco: ALTO — envio de credencial/segredo via rede.
(mais detalhes: /cae:explain)

Failed checks: NONE
Notes: Correctly classified as alto per rule "Commands accessing credentials, secrets, or sensitive env vars sent over network". The $API_KEY in an Authorization header sent via curl is exactly this case.

---

SCENARIO B6: PASS
Approval summary:
Vai iniciar servicos via docker-compose em modo detached.
Risco: medio — inicia containers locais.
(mais detalhes: /cae:explain)

Failed checks: NONE
Notes: No tutorial about || operator (Rule 18: never explain operators). Both sides do the same thing (start services). Correctly consolidated as one action, medio risk.

---

SCENARIO B7: PASS
Approval summary:
Vai buscar refs remotos, criar branch, aplicar cherry-pick e enviar branch para origin.
Risco: medio — operacoes git locais e push sem force.
(mais detalhes: /cae:explain)

Failed checks: NONE
Notes: git push without --force is NOT in the alto list. git cherry-pick is a local mutation (write). git fetch is read-only. Correctly classified as medio overall. No false positive to alto.

---

SCENARIO B8: PASS
Approval summary:
Vai instalar dependencias via npm, pip e brew localmente.
Risco: medio — instalacao de pacotes locais.
(mais detalhes: /cae:explain)

Failed checks: NONE
Notes: npm install (local) and pip install (local) are explicitly listed as medio. brew install is analogous. No -g flag. Correctly medio, not alto.

---

SCENARIO B9: PASS
Approval summary:
Vai construir imagem Docker e executar container na porta 3000.
Risco: medio — operacoes Docker locais.
(mais detalhes: /cae:explain)

Failed checks: NONE
Notes: docker build and docker run are local container operations. Not in the alto list (which lists docker system prune, docker rm -f). Correctly medio.

---

SCENARIO B10: FAIL
Approval summary (expected in English):
⚠ Will delete dist/ directory and execute remote script via curl|bash.
Risk: HIGH — irreversible deletion and execution of unaudited remote code.
(details: /cae:explain)

Failed checks:
- Language: The skill says "Use the user's configured language (default: pt-BR). Supported: pt-BR, en." It specifies that language follows user preference. However, ALL format templates and examples are in pt-BR only. There are NO English templates.
- When language=en, the agent must translate: "Vai" -> "Will", "Risco: ALTO" -> "Risk: HIGH", "Risco: medio" -> "Risk: medium", "mais detalhes" -> "details", "Nada sera alterado" -> "Nothing will be changed", "Atencao:" -> "Warning:", "Detalhamento:" -> "Breakdown:", etc.
- The skill declares en support but provides zero guidance on English translations of the fixed-format strings. This relies entirely on agent inference.

Proposed fix: Add an English template section or a translation table. Suggested addition after the Language section:

```
### English (en) format equivalents

baixo: "N read-only commands in [scope]. Nothing will be changed."
medio: "Will [headline]. / Risk: medium — [reason]. / (details: /cae:explain)"
alto: "⚠ Will [headline]. / Risk: HIGH — [reason]. / [alerts] / (details: /cae:explain)"
Alerts: "Warning: git add . may include sensitive files."
/cae:explain header: "Breakdown:"
Risk labels in breakdown: Low / Medium / High
```

---

## SUMMARY

```
SCENARIO A1: PASS
SCENARIO A2: PASS
SCENARIO A3: PASS
SCENARIO B1: PASS
SCENARIO B2: PASS
SCENARIO B3: FAIL — "comandos de leitura" misleading for noop/stdout-only commands
SCENARIO B4: PASS
SCENARIO B5: PASS
SCENARIO B6: PASS
SCENARIO B7: PASS
SCENARIO B8: PASS
SCENARIO B9: PASS
SCENARIO B10: FAIL — English language support declared but no English templates provided
```

Total: 13 scenarios, 11 PASS, 2 FAIL

---

## PROPOSED SKILL.MD CHANGES

1. **Rule 7 (baixo headline) — noop/stdout commands**: Currently says 'start with "N comandos de..."'. Should be expanded to: 'baixo: start with "N comandos de..." — use "leitura" for actual read commands (ls, cat, grep, find without -exec), "sem efeito colateral" for noops/stdout-only commands (true, echo without redirect, pwd).'

2. **English language templates**: The Language section declares en support but provides no English format strings. Add a subsection with English equivalents for all fixed-format elements:
   - baixo: "N read-only commands in [scope]. Nothing will be changed."
   - medio: "Will [headline]. / Risk: medium — [reason]. / (details: /cae:explain)"
   - alto: "⚠ Will [headline]. / Risk: HIGH — [reason]. / [alerts] / (details: /cae:explain)"
   - Alert for git add .: "Warning: git add . may include sensitive files."
   - Alert for complex commands: "Complex command; summary may omit details."
   - /cae:explain header: "Breakdown:"
   - Risk labels: Low / Medium / High

3. **Noop classification** (minor): Add "true, noop, :" (shell builtins that do nothing) to the baixo list explicitly for completeness.

## REMAINING GAPS

1. **Global package installs**: The skill lists "npm install (local)" and "pip install (local)" as medio, but does not explicitly state that "npm install -g", "pip install" without -r (global), or "brew install" with --cask should be classified differently. Current behavior (medio) seems acceptable for most cases, but the distinction is implicit.

2. **docker run with --privileged or -v /:/host**: Not addressed. A `docker run --privileged` could be argued as alto (system-level access). Current rules would classify it as medio (local container operation). This is a potential false negative.

3. **Pipe to other interpreters**: The alto rule covers curl piped to bash/sh/eval/exec/node/python. But curl piped to `ruby`, `perl`, `php`, or `deno` is not listed. These should also be alto. The rule could say "piped to any interpreter/runtime."

4. **Write to system paths without sudo**: e.g., `echo "malicious" > /etc/hosts` (if running as root). The alto rules require sudo explicitly, but direct writes to system paths (/etc, /var, /usr) without sudo could also be destructive. Edge case since most agents don't run as root.
