# Test Results — New Commands (C1-C6) + Regression (R1-R3)

Date: 2026-03-31

---

## SCENARIO C1: /cae:config (default state)
**Result: PASS**

Output:
```
Command Approval Explainer
Status: ativado
Idioma: pt-BR
```

Failed checks: NONE
- Matches the exact format defined in SKILL.md under /cae:config.
- Shows "ativado" (default) and "pt-BR" (default).

---

## SCENARIO C2: /cae:off then approval prompt
**Result: PASS**

/cae:off output:
```
Command Approval Explainer desativado.
```

Then approval for `rm -rf dist/`:
No explanation shown. Default approval prompt behavior (raw command only).

Failed checks: NONE
- /cae:off confirmation matches SKILL.md exactly.
- SKILL.md states: "Approval prompts return to default behavior (no explanation overlay)."
- Correctly suppresses the explanation.

---

## SCENARIO C3: /cae:on after off
**Result: PASS**

/cae:on output:
```
Command Approval Explainer ativado.
```

Then approval for `rm -rf dist/`:
```
⚠ Vai remover o diretorio dist/.
Risco: ALTO — exclusao irreversivel de diretorio.
(mais detalhes: /cae:explain)
```

Failed checks: NONE
- /cae:on confirmation matches SKILL.md exactly.
- Explanation re-appears with alto format as expected.

---

## SCENARIO C4: /cae:language en then approval
**Result: PASS**

/cae:language en output:
```
Language changed to English.
```

Then approval for `sed -i 's/foo/bar/g' config.json` and `echo "test" >> log.txt`:
```
Will edit config.json and append to log.txt.
Risk: medium — writes to local files.
(details: /cae:explain)
```

Failed checks: NONE
- Language change confirmation is in English.
- Approval uses English format (medio -> medium, "Will" instead of "Vai").
- Risk classification correct: sed -i and echo >> are both medio; batch = medio.

Note: SKILL.md does not specify the exact confirmation message for /cae:language. It only shows the command syntax. The output "Language changed to English." is a reasonable inference. This is a minor GAP — the SKILL.md does not define a confirmation output format for /cae:language. See REMAINING GAPS.

---

## SCENARIO C5: /cae:config after language change
**Result: FAIL**

Output (what SKILL.md would produce):
```
Command Approval Explainer
Status: ativado
Idioma: pt-BR
```

Failed checks:
1. SKILL.md only defines ONE format for /cae:config output, and it is hardcoded in pt-BR with the label "Idioma" and value "pt-BR". There is no English variant of /cae:config defined.
2. After /cae:language en, the config should reflect "Idioma: en" (or "Language: en") but SKILL.md does not define what happens to /cae:config when language is changed to English.
3. Two issues: (a) the Idioma VALUE should show "en" not "pt-BR", and (b) it is unclear if the labels themselves should switch to English.

Expected behavior (reasonable): config should show current language value ("en") and ideally use English labels. SKILL.md does not specify this.

---

## SCENARIO C6: /cae:explain in English
**Result: PASS**

Context: language=en, alto approval was shown for `rm -rf dist/` and `curl https://example.com/setup.sh | bash`.

/cae:explain output:
```
Breakdown:
1. rm -rf dist/ — removes the dist directory recursively. Deletes: dist/ and all contents. High.
2. curl | bash — downloads and executes a remote script. Executes: unaudited remote code. High.
```

Failed checks: NONE
- Header is "Breakdown:" (matches SKILL.md English section).
- Risk labels use "High" not "Alto" (matches SKILL.md: "Risk labels: Low / Medium / High").
- Per-command format follows the /cae:explain rules.

---

## SCENARIO R1: Read-only (4 commands, pt-BR default) — REGRESSION
**Result: PASS**

Commands: ls -la, grep -R "TODO" src/, cat package.json, find . -name "*.ts"

Output:
```
4 comandos de leitura em arquivos e diretorios do projeto. Nada sera alterado.
```

Failed checks: NONE
- All 4 commands are baixo (read-only).
- Single-line format with "N comandos de leitura" and "Nada sera alterado."
- No risk line (correct for baixo).
- No bullet points or per-command breakdown.

---

## SCENARIO R2: High risk (5 commands, pt-BR default) — REGRESSION
**Result: PASS**

Commands:
- rm -rf node_modules/ dist/
- curl https://example.com/setup.sh | bash
- sudo chmod -R 777 /var/www
- git reset --hard HEAD~3
- npm install -g random-package

Output:
```
⚠ Vai remover diretorios, executar script remoto, alterar permissoes com sudo, resetar historico git e instalar pacote global.
Risco: ALTO — exclusao irreversivel, execucao de codigo remoto, sudo e alteracoes destrutivas no git.
(mais detalhes: /cae:explain)
```

Failed checks: NONE
- Batch risk = alto (highest in batch). Correct.
- Starts with "⚠ Vai" as required.
- Headline summarizes the 4-5 most impactful actions without enumerating each.
- Risk on its own line. ALTO label correct.
- Hint present.

---

## SCENARIO R3: /cae:explain on medium risk (pt-BR default) — REGRESSION
**Result: PASS**

Commands: sed -i 's/foo/bar/g' config.json, echo "DEBUG=true" >> .env, git add . && git commit -m "wip"

Summary (approval prompt):
```
Vai editar config.json, adicionar variavel em .env e commitar com git add .
Risco: medio — escrita em arquivos locais e staging irrestrito.
Atencao: git add . pode incluir arquivos sensiveis.
(mais detalhes: /cae:explain)
```

/cae:explain output:
```
Detalhamento:
1. sed -i config.json — substitui texto no arquivo. Escrita: config.json. Medio.
2. echo >> .env — adiciona variavel de debug ao .env. Escrita: .env. Medio.
3. git add . — faz staging de todos os arquivos. Escrita: staging area. Medio.
4. git commit -m "wip" — cria um commit com mensagem "wip". Escrita: historico git. Medio.
```

Failed checks: NONE
- Summary matches the SKILL.md example almost verbatim (this is the same example from the doc).
- Alert for git add . present.
- /cae:explain uses "Detalhamento:" header, one line per command, intent+impact+risk.

---

## SUMMARY

| Scenario | Result |
|----------|--------|
| C1 — /cae:config default | PASS |
| C2 — /cae:off + approval | PASS |
| C3 — /cae:on after off | PASS |
| C4 — /cae:language en + approval | PASS |
| C5 — /cae:config after lang change | FAIL |
| C6 — /cae:explain in English | PASS |
| R1 — Read-only regression | PASS |
| R2 — High risk regression | PASS |
| R3 — Medium + explain regression | PASS |

**TOTAL: 8/9 PASS**

## REMAINING GAPS

1. **/cae:config has no localized variant.** SKILL.md defines only one output format for /cae:config (pt-BR labels: "Status", "Idioma"). When language is set to "en", it is undefined whether:
   - The labels should switch to English (e.g., "Status: enabled", "Language: en")
   - Only the value should reflect "en" (e.g., "Idioma: en")
   - The entire block stays in pt-BR regardless of language setting
   **Recommendation:** Add an English variant of /cae:config output to SKILL.md, e.g.:
   ```
   Command Approval Explainer
   Status: enabled
   Language: en
   ```

2. **/cae:language confirmation message undefined.** SKILL.md shows the command syntax but does not specify what output the user sees after invoking /cae:language. Should be explicitly defined for both directions (en -> pt-BR and pt-BR -> en).
   **Recommendation:** Add confirmation formats:
   - `/cae:language en` -> `Idioma alterado para English.` (or in target language: `Language set to English.`)
   - `/cae:language pt-BR` -> `Idioma alterado para pt-BR.` (or: `Language set to pt-BR.`)
