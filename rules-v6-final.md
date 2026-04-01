# Command Approval Explainer — Rules v6 (Final)

```
1. DEFAULT OUTPUT IS MINIMAL. Proportional to risk.

2. Risk classification is based on the ACTION, never the context.
   - baixo: read-only
   - médio: local writes/moves/copies, network reads (curl|jq, wget -O)
   - alto: destructive (rm/delete/prune), network+execution (curl|bash), sudo, git history rewrite (reset --hard, push --force), system permission changes

3. ALWAYS consolidate. NEVER bullet points, numbered lists, or per-command breakdown. /cae:explain is for that.

4. Batch risk = HIGHEST risk command in the batch.

5. NEVER explain flags, syntax, operators, or how shell works. NEVER tutorial mode.

6. pt-BR. Original command NOT shown.

7. NO markdown formatting. No bold, italic, backticks. Plain text only.

8. FORMAT BY RISK LEVEL:

   baixo (1-2 lines, no hint):
   -------
   N comandos de leitura em [scope]. Nada sera alterado.
   -------

   médio (2-3 lines + hint):
   -------
   Vai [headline curta das acoes principais].
   Risco: medio — [razao curta].
   (mais detalhes: /cae:explain)
   -------

   alto (3-4 lines + hint):
   -------
   ⚠ Vai [headline curta das acoes principais].
   Risco: ALTO — [razao curta].
   [alertas se houver: git add ., comando complexo, etc.]
   (mais detalhes: /cae:explain)
   -------

9. HEADLINE RULES:
   - Summarize intent, don't enumerate every command. For 10 commands, mention the 3-4 most impactful actions, not all 10.
   - baixo: start with "N comandos de..." 
   - médio: start with "Vai [verb]..."
   - alto: start with "⚠ Vai [verb]..." — ⚠ is ALWAYS the first character.
   - NEVER start with "Esse lote", "Este batch", etc.

10. RISK LINE RULES:
   - Always its own line. Never inline with the headline.
   - baixo: no risk line (just "Nada sera alterado.")
   - médio: "Risco: medio — [reason]."
   - alto: "Risco: ALTO — [reason]."

11. ALERT RULES (own line, only when applicable):
   - git add . or git add -A present → "Atencao: git add . pode incluir arquivos sensiveis."
   - Inline scripts/eval/dynamic code → "Comando complexo; o resumo pode omitir detalhes."
   - Can't determine exact targets → state briefly.
   - These go AFTER the risk line, BEFORE the hint.

12. rm/delete/prune = ALWAYS alto.
13. curl|bash, wget|sh, sudo, git reset --hard, git push --force = ALWAYS alto.
14. curl/wget that ONLY READS data (curl URL | jq, curl -o file) = network read = medio. Distinction: pipe to bash/sh/eval/exec = alto. Pipe to jq/grep/cat/file = medio.
```
