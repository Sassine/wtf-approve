# Command Approval Explainer - Scenario Validation Results

## S1 — Read-only, user speaks English
Commands: ls -la, grep -R "TODO" src/, cat package.json

Generated explanation:
```
3 read-only commands in the current directory and src/. Nothing will be changed.
```

CHECKLIST:
- Correct language? PASS (English, auto-detected from user language)
- Correct risk? PASS (low — ls, grep, cat are all read-only per skill classification)
- Correct format? PASS (1 line + "Nothing will be changed." matches low format)
- Warning placement? PASS (no warning needed for low)
- No markdown? PASS (plain text only)

RESULT: PASS

---

## S2 — Read-only, user speaks Portuguese
Commands: ls -la, grep -R "TODO" src/, cat package.json

Generated explanation:
```
3 comandos de leitura no diretorio atual e src/. Nada sera alterado.
```

CHECKLIST:
- Correct language? PASS (Portuguese, auto-detected from user language)
- Correct risk? PASS (low — same commands as S1)
- Correct format? PASS (1 line + "Nada sera alterado." is the translated low format)
- Warning placement? PASS (no warning needed for low)
- No markdown? PASS (plain text only)

RESULT: PASS

---

## S3 — Medium, user speaks Spanish
Commands: sed -i 's/foo/bar/g' config.json, echo "test" >> log.txt

Generated explanation:
```
Editara config.json y agregara texto a log.txt.
Riesgo: medio — escritura en archivos locales.
(detalles: /cae:explain)
```

CHECKLIST:
- Correct language? PASS (Spanish, auto-detected from user language)
- Correct risk? PASS (medium — sed -i is medium, echo >> is medium; batch risk = highest = medium)
- Correct format? PASS (headline "Will [verb]" translated to Spanish, risk line on own line, hint line)
- Warning placement? PASS (no warning needed for medium without git add .)
- No markdown? PASS (plain text only)

RESULT: PASS

---

## S4 — High, user speaks Japanese
Commands: rm -rf dist/, curl https://example.com/setup.sh | bash

Generated explanation:
```
⚠ dist/を削除し、リモートスクリプトをcurl|bashで実行します。
リスク: 高 — 不可逆な削除と未監査のリモートコード実行。
(詳細: /cae:explain)
```

CHECKLIST:
- Correct language? PASS (Japanese, auto-detected from user language)
- Correct risk? PASS (high — rm -rf is high, curl|bash is high)
- Correct format? PASS (3 lines: headline with verb, risk line, hint line)
- Warning placement? PASS (⚠ is the FIRST character of the headline, per rule 9)
- No markdown? PASS (plain text only)

RESULT: PASS

---

## S5 — /cae:language pt-BR then high risk
User runs: /cae:language pt-BR
System responds: Idioma alterado para pt-BR.

Then command: rm -rf dist/

Generated explanation:
```
⚠ Vai remover o diretorio dist/.
Risco: ALTO — exclusao irreversivel de diretorio.
(mais detalhes: /cae:explain)
```

CHECKLIST:
- Correct language? PASS (Portuguese pt-BR, set via /cae:language)
- Correct risk? PASS (high — rm -rf is always high per classification)
- Correct format? PASS (high format: ⚠ headline, ALTO risk line, hint line)
- Warning placement? PASS (⚠ is the FIRST character)
- No markdown? PASS (plain text only)

RESULT: PASS

---

## S6 — /cae:config (auto-detected English)

Generated explanation:
```
Command Approval Explainer
Status: enabled
Language: en (auto-detected)
```

CHECKLIST:
- Correct language? PASS (English, auto-detected)
- Correct risk? N/A (config command, not a risk scenario)
- Correct format? PASS (matches the /cae:config template exactly, includes "auto-detected")
- Warning placement? N/A
- No markdown? PASS (plain text only)

RESULT: PASS

---

## S7 — /cae:off then approval
User runs: /cae:off

System responds:
```
Command Approval Explainer disabled.
```

Then command needing approval: rm -rf dist/

Generated explanation: (none — explainer is disabled, approval prompt shows with no explanation overlay)

CHECKLIST:
- Correct language? PASS (disabled message in active language per spec)
- Correct risk? N/A (explainer is off, no risk classification produced)
- Correct format? PASS (disabled message matches template; subsequent approval has no explanation)
- Warning placement? N/A
- No markdown? PASS (plain text only)

RESULT: PASS

---

## S8 — /cae:explain in English
After high approval for: rm -rf dist/, curl https://example.com/setup.sh | bash

User runs: /cae:explain

Generated explanation:
```
Breakdown:
1. rm -rf dist/ — deletes the dist/ directory recursively. Deletes: dist/ and all contents. High.
2. curl | bash — downloads and executes a remote script. Reads: network. Executes: unaudited remote code. High.
```

CHECKLIST:
- Correct language? PASS (English, same as the summary)
- Correct risk? PASS (individual risks listed per command: both high)
- Correct format? PASS ("Breakdown:" header, numbered lines, one per command, intent+impact+risk per line)
- Warning placement? N/A (explain format has no ⚠)
- No markdown? PASS (plain text only)

RESULT: PASS

---

## S9 — Noop commands, English
Commands: true, echo "hello", pwd

Generated explanation:
```
3 commands with no side effects. Nothing will be changed.
```

CHECKLIST:
- Correct language? PASS (English)
- Correct risk? PASS (low — true is noop, echo without redirect is low, pwd is low)
- Correct format? PASS (uses the "no side effects" variant per the skill spec for noop/stdout-only commands)
- Warning placement? PASS (no warning needed for low)
- No markdown? PASS (plain text only)

RESULT: PASS

---

## S10 — /cae:language es then /cae:config
User runs: /cae:language es

System responds: Idioma cambiado a espanol.

User runs: /cae:config

Generated explanation:
```
Command Approval Explainer
Estado: habilitado
Idioma: es (configurado manualmente)
```

CHECKLIST:
- Correct language? PASS (Spanish, set via /cae:language es)
- Correct risk? N/A (config command)
- Correct format? PASS (config output translated to Spanish, language shows "es" — note: since language was manually set, "auto-detected" is not shown; instead it reflects the manual override)
- Warning placement? N/A
- No markdown? PASS (plain text only)

RESULT: PASS

---

## Summary

| Scenario | Language | Risk | Format | Warning | No MD | Result |
|----------|----------|------|--------|---------|-------|--------|
| S1       | PASS     | PASS | PASS   | PASS    | PASS  | PASS   |
| S2       | PASS     | PASS | PASS   | PASS    | PASS  | PASS   |
| S3       | PASS     | PASS | PASS   | PASS    | PASS  | PASS   |
| S4       | PASS     | PASS | PASS   | PASS    | PASS  | PASS   |
| S5       | PASS     | PASS | PASS   | PASS    | PASS  | PASS   |
| S6       | PASS     | N/A  | PASS   | N/A     | PASS  | PASS   |
| S7       | PASS     | N/A  | PASS   | N/A     | PASS  | PASS   |
| S8       | PASS     | PASS | PASS   | N/A     | PASS  | PASS   |
| S9       | PASS     | PASS | PASS   | PASS    | PASS  | PASS   |
| S10      | PASS     | N/A  | PASS   | N/A     | PASS  | PASS   |

TOTAL: 10/10 PASS

REMAINING GAPS: NONE
