# Command Approval Explainer — Test Results v6

FINAL RULES VERSION: v6
ITERATIONS: 1 (all scenarios passed on first run)

---

## SCENARIO 1: PASS
Risk: baixo (4 read-only commands)
```
Output:
---
4 comandos de leitura no projeto. Nada sera alterado.
---
```
Failed checks: NONE

Validation:
- [x] Risk level correct (baixo)
- [x] No warning symbol
- [x] Headline concise
- [x] No risk line (correct for baixo)
- [x] No hint (correct for baixo)
- [x] Consolidated, no bullets
- [x] Single block
- [x] No markdown
- [x] No tutorial/syntax explanation
- [x] Under line limit (1 line)

---

## SCENARIO 2: PASS
Risk: medio (local writes + git add .)
```
Output:
---
Vai editar config.json, adicionar variavel em .env, copiar dist/ e commitar com git add .
Risco: medio — escrita em arquivos locais e staging irrestrito.
Atencao: git add . pode incluir arquivos sensiveis.
(mais detalhes: /cae:explain)
---
```
Failed checks: NONE

Validation:
- [x] Risk level correct (medio)
- [x] No warning symbol
- [x] Headline starts with "Vai"
- [x] Risk on own line
- [x] git add . alert on own line
- [x] Hint on last line
- [x] Consolidated, no bullets
- [x] Single block
- [x] No markdown
- [x] No tutorial/syntax explanation
- [x] Under line limit (4 lines: 3 content + hint)

---

## SCENARIO 3: PASS
Risk: alto (rm -rf, curl|bash, sudo, git reset --hard)
```
Output:
---
⚠ Vai remover diretorios, executar script remoto via curl|bash, alterar permissoes com sudo e reescrever historico git.
Risco: ALTO — comandos destrutivos, execucao remota, sudo e reescrita de historico.
(mais detalhes: /cae:explain)
---
```
Failed checks: NONE

Validation:
- [x] Risk level correct (alto)
- [x] Warning symbol is first character
- [x] Headline starts with "⚠ Vai"
- [x] Risk on own line
- [x] Hint on last line
- [x] Consolidated, no bullets
- [x] Single block
- [x] No markdown
- [x] No tutorial/syntax explanation
- [x] Under line limit (3 lines)

---

## SCENARIO 4: PASS
Risk: alto (find -exec rm, docker prune, inline script with network exec)
```
Output:
---
⚠ Vai deletar arquivos antigos, gerar relatorio, parar e limpar containers Docker e enviar dados a API externa via script inline.
Risco: ALTO — delecao de arquivos, prune de Docker e execucao de codigo dinamico com rede.
Comando complexo; o resumo pode omitir detalhes.
(mais detalhes: /cae:explain)
---
```
Failed checks: NONE

Validation:
- [x] Risk level correct (alto)
- [x] Warning symbol is first character
- [x] Headline starts with "⚠ Vai"
- [x] Risk on own line
- [x] "Comando complexo" alert on own line
- [x] Hint on last line
- [x] Consolidated, no bullets
- [x] Single block
- [x] No markdown
- [x] No tutorial/syntax explanation
- [x] Under line limit (4 lines)

---

## SCENARIO 5: PASS
Risk: alto (rm -rf elevates batch; curl|jq treated as read/consulta)
```
Output:
---
⚠ Vai remover .cache/, executar testes, guardar stash, criar arquivo e consultar API do GitHub.
Risco: ALTO — remocao de diretorio com rm -rf.
(mais detalhes: /cae:explain)
---
```
Failed checks: NONE

Validation:
- [x] Risk level correct (alto, due to rm -rf)
- [x] Warning symbol is first character
- [x] curl|jq described as "consultar" (not "executar")
- [x] Risk on own line
- [x] Hint on last line
- [x] Consolidated, no bullets
- [x] Single block
- [x] No markdown
- [x] No tutorial/syntax explanation
- [x] Under line limit (3 lines)

---

## SCENARIO 6: PASS
Risk: alto (inline scripts with delete and system file editing)
```
Output:
---
⚠ Vai editar arquivos .conf em /etc e deletar arquivos .bak no diretorio atual via scripts inline.
Risco: ALTO — delecao de arquivos e edicao em massa de configuracoes do sistema.
Comando complexo; o resumo pode omitir detalhes.
(mais detalhes: /cae:explain)
---
```
Failed checks: NONE

Validation:
- [x] Risk level correct (alto)
- [x] Warning symbol is first character
- [x] Headline starts with "⚠ Vai"
- [x] Risk on own line
- [x] "Comando complexo" alert on own line
- [x] Hint on last line
- [x] Consolidated, no bullets
- [x] Single block
- [x] No markdown
- [x] No tutorial/syntax explanation
- [x] Under line limit (4 lines)

---

## SCENARIO 7: PASS
Risk: alto (rm -rf dist/ elevates batch; git add . present)
```
Output:
---
⚠ Vai remover dist/, editar config.json, instalar dependencias e commitar com git add .
Risco: ALTO — remocao de diretorio com rm -rf.
Atencao: git add . pode incluir arquivos sensiveis.
(mais detalhes: /cae:explain)
---
```
Failed checks: NONE

Validation:
- [x] Risk level correct (alto)
- [x] Warning symbol is first character
- [x] Headline summarizes 3-4 key actions (not all 10)
- [x] Risk on own line
- [x] git add . alert on own line
- [x] Hint on last line
- [x] Consolidated, no bullets
- [x] Single block
- [x] No markdown
- [x] No tutorial/syntax explanation
- [x] Under 5 lines total (4 lines)

---

## SUMMARY

FIXES APPLIED: NONE
REMAINING GAPS: NONE

All 7 scenarios passed validation on the first iteration. The v6 rules successfully address the visual hierarchy issue from previous versions by placing risk level and alerts on dedicated lines, making medium/high risk outputs scannable without sacrificing conciseness.

Key design wins in v6:
- Risk line always standalone (never buried in a paragraph)
- Alert lines (git add ., comando complexo) always standalone
- Hint consistently on last line for medio/alto
- Headlines summarize intent (3-4 actions) rather than enumerating all commands
- curl|jq correctly classified as network read (medio), distinct from curl|bash (alto)
