# Test Results — SKILL.md Validation (7 Scenarios)

---

SCENARIO 1: PASS
Output:
4 comandos de leitura no diretorio e codigo-fonte. Nada sera alterado.
Failed checks: NONE

Validation:
- Risk level correct? YES — all commands (ls, grep, cat, find) are baixo (read-only).
- No warning symbol: YES — baixo has no symbol.
- Headline: "4 comandos de leitura..." follows rule 7. Concise, not enumerating each command.
- Risk on own line? N/A — baixo uses "Nada sera alterado." inline per format template.
- Alerts: N/A — none needed.
- Hint on last line? N/A — baixo has no hint (rule: no hint for baixo). Correct.
- No hint for baixo? YES — confirmed absent.
- Consolidated? YES — single sentence, no bullets.
- Single block? YES — 1 line.
- No markdown? YES.
- No tutorial/syntax? YES.
- Under line limits? YES — 1 line (limit: 1-2).

---

SCENARIO 2: PASS
Output:
Vai editar config.json, adicionar variavel em .env, copiar dist/ e commitar com git add .
Risco: medio — escrita em arquivos locais e staging irrestrito.
Atencao: git add . pode incluir arquivos sensiveis.
(mais detalhes: /cae:explain)
Failed checks: NONE

Validation:
- Risk level correct? YES — sed -i, echo >>, cp, git add/commit are all medio. No alto commands.
- No warning symbol: YES — medio has no symbol.
- Headline: starts with "Vai" per rule 8. Summarizes 4 actions concisely.
- Risk on own line? YES — "Risco: medio..." is its own line.
- Alerts on own lines? YES — "Atencao: git add ." is its own line after risk, before hint.
- Hint on last line? YES — "(mais detalhes: /cae:explain)" is last line.
- Consolidated? YES — no bullets or lists.
- Single block? YES — continuous block of 4 lines.
- No markdown? YES.
- No tutorial/syntax? YES.
- git add . warning? YES — "Atencao: git add . pode incluir arquivos sensiveis." present.
- Under line limits? YES — 4 lines (medio: 2-3 lines + hint; alert adds 1 line, consistent with SKILL.md example).

---

SCENARIO 3: PASS
Output:
⚠ Vai remover diretorios, executar script remoto via curl|bash, alterar permissoes de sistema e resetar historico git.
Risco: ALTO — exclusao irreversivel, execucao de codigo remoto, sudo em path de sistema e reescrita de historico.
(mais detalhes: /cae:explain)
Failed checks: NONE

Validation:
- Risk level correct? YES — rm -rf (alto), curl|bash (alto), sudo chmod (alto), git reset --hard (alto), npm install -g (medio, but batch = alto).
- Warning symbol first char? YES — line starts with ⚠.
- Headline: starts with "⚠ Vai" per rule 9. Summarizes 4 most impactful actions (rule 6). npm install -g omitted as least impactful.
- Risk on own line? YES.
- Alerts on own lines? N/A — no specific alerts triggered (no git add ., no inline scripts).
- Hint on last line? YES.
- Consolidated? YES — no bullets.
- Single block? YES — 3 lines.
- No markdown? YES.
- No tutorial/syntax? YES.
- Under line limits? YES — 3 lines (alto: 3-4 lines + hint; hint is line 3).

---

SCENARIO 4: PASS
Output:
⚠ Vai deletar arquivos de log antigos, gerar relatorio, parar e limpar Docker, e enviar dado sensivel a API externa.
Risco: ALTO — delecao de arquivos, prune irreversivel do Docker e envio de credencial via rede.
Comando complexo; o resumo pode omitir detalhes.
(mais detalhes: /cae:explain)
Failed checks: NONE

Validation:
- Risk level correct? YES — rm via find -exec (alto), docker prune (alto), ENV_VAR=secret + curl POST (alto: credentials sent over network). Pipeline to report.txt is medio.
- Warning symbol first char? YES.
- Headline: concise summary of 4 most impactful actions. Not enumerating each pipeline.
- Risk on own line? YES.
- Alerts on own lines? YES — "Comando complexo; o resumo pode omitir detalhes." is on its own line.
- Hint on last line? YES.
- Consolidated? YES.
- Single block? YES — 4 lines.
- No markdown? YES.
- No tutorial/syntax? YES.
- "Comando complexo..." present? YES — rule 16 triggered by complex pipelines (find -exec rm, awk pipeline, docker subshell, node -e with execSync).
- Under line limits? YES — 4 lines (alto: 3-4 lines + hint).

---

SCENARIO 5: PASS
Output:
⚠ Vai executar testes, guardar stash, remover cache e consultar API externa.
Risco: ALTO — exclusao irreversivel de diretorio.
(mais detalhes: /cae:explain)
Failed checks: NONE

Validation:
- Risk level correct? YES — cat (baixo), npm test (medio), git stash (medio), rm -rf .cache/ (alto), echo > (medio), curl|jq (medio). Batch = alto.
- Warning symbol first char? YES.
- Headline: concise, mentions 3-4 most impactful actions. cat README.md and echo > greeting.txt omitted as less impactful. Correct per rule 6.
- Risk on own line? YES.
- Alerts: none triggered (no git add ., no inline scripts, no complex pipelines).
- Hint on last line? YES.
- Consolidated? YES.
- Single block? YES — 3 lines.
- No markdown? YES.
- No tutorial/syntax? YES.
- curl|jq = read not execution? YES — curl|jq is classified as medio (network read per rule 24), not alto. The headline says "consultar API externa" (read/query), not "executar" (execute). The batch is alto due to rm -rf, not due to curl.
- Under line limits? YES — 3 lines.

---

SCENARIO 6: PASS
Output:
⚠ Vai editar arquivos de configuracao em /etc e deletar arquivos .bak no diretorio atual.
Risco: ALTO — escrita em paths de sistema e exclusao de arquivos.
Comando complexo; o resumo pode omitir detalhes.
(mais detalhes: /cae:explain)
Failed checks: NONE

Validation:
- Risk level correct? YES — bash -c with sed -i on /etc (alto: inline script + system paths), python3 -c with os.remove (alto: delete + inline script).
- Warning symbol first char? YES.
- Headline: concise summary of 2 actions. Not enumerating syntax.
- Risk on own line? YES.
- Alerts on own lines? YES — "Comando complexo; o resumo pode omitir detalhes." on own line.
- Hint on last line? YES.
- Consolidated? YES.
- Single block? YES — 4 lines.
- No markdown? YES.
- No tutorial/syntax? YES.
- "Comando complexo..." present? YES — rule 16 triggered by both inline scripts (bash -c, python3 -c).
- Under line limits? YES — 4 lines (alto: 3-4 lines + hint).

---

SCENARIO 7: PASS
Output:
⚠ Vai editar e fazer backup de config.json, instalar dependencias, commitar com git add . e remover dist/.
Risco: ALTO — exclusao irreversivel de diretorio.
Atencao: git add . pode incluir arquivos sensiveis.
(mais detalhes: /cae:explain)
Failed checks: NONE

Validation:
- Risk level correct? YES — ls, cat, grep (baixo); echo >>, cp, sed -i, npm install, git add, git commit (medio); rm -rf (alto). Batch = alto.
- Warning symbol first char? YES.
- Headline: concise, mentions 3-4 most impactful actions out of 10 commands. Baixo commands (ls, cat, grep) omitted. Correct per rule 6.
- Risk on own line? YES.
- Alerts on own lines? YES — "Atencao: git add ." is on its own line; placed after risk, before hint.
- Hint on last line? YES.
- Consolidated? YES — no bullets, no per-command breakdown.
- Single block? YES — 4 lines.
- No markdown? YES.
- No tutorial/syntax? YES.
- git add . warning? YES — "Atencao: git add . pode incluir arquivos sensiveis." present.
- Under line limits? YES — 4 lines (alto: 3-4 lines + hint).

---

## SUMMARY

| Scenario | Result | Risk Level | Notes |
|----------|--------|------------|-------|
| 1        | PASS   | baixo      | 4 read-only commands |
| 2        | PASS   | medio      | git add . alert correctly triggered |
| 3        | PASS   | alto       | 5 destructive/system commands |
| 4        | PASS   | alto       | Complex pipelines, "Comando complexo" alert triggered |
| 5        | PASS   | alto       | curl|jq correctly treated as read (medio), batch alto due to rm -rf |
| 6        | PASS   | alto       | Inline scripts, "Comando complexo" alert triggered |
| 7        | PASS   | alto       | 10-command stress test, git add . alert triggered |

REMAINING GAPS: NONE
