FINAL RULES VERSION: v5 (no changes needed)
ITERATIONS NEEDED: 1

================================================================================
SCENARIO 1: PASS — Read-only (4 commands)
================================================================================
Output:
4 comandos de leitura no diretorio e arquivos do projeto.

Checks:
- Risk level correct? PASS (baixo)
- ⚠ placement correct? PASS (absent, correct for baixo)
- Consolidated? PASS (single sentence)
- Single block? PASS
- Starts correctly? PASS ("4 comandos de...")
- Hint present/absent correctly? PASS (absent for baixo)
- No markdown formatting? PASS
- No tutorial/syntax explanation? PASS
- curl|jq not classified as execution? N/A
- Inline script uncertainty? N/A
- git add . warning? N/A

================================================================================
SCENARIO 2: PASS — Medium risk (4 commands)
================================================================================
Output:
Vai editar config.json, adicionar texto em .env, copiar dist/ para backup/, e fazer commit de todas as alteracoes. Atencao: git add . pode incluir arquivos sensiveis como .env ou credenciais. (mais detalhes: /cae:explain)

Checks:
- Risk level correct? PASS (medio)
- ⚠ placement correct? PASS (absent, correct for medio)
- Consolidated? PASS (comma-separated in one flow)
- Single block? PASS
- Starts correctly? PASS ("Vai editar...")
- Hint present/absent correctly? PASS (present)
- No markdown formatting? PASS
- No tutorial/syntax explanation? PASS
- curl|jq not classified as execution? N/A
- Inline script uncertainty? N/A
- git add . warning? PASS ("git add . pode incluir arquivos sensiveis")

================================================================================
SCENARIO 3: PASS — High risk (5 commands)
================================================================================
Output:
⚠ Vai apagar node_modules/ e dist/, executar script remoto via curl, alterar permissoes com sudo em /var/www, descartar 3 commits com git reset --hard, e instalar pacote global. Risco alto: inclui exclusao irreversivel, execucao remota, e alteracao de sistema. (mais detalhes: /cae:explain)

Checks:
- Risk level correct? PASS (alto)
- ⚠ placement correct? PASS (first character)
- Consolidated? PASS
- Single block? PASS
- Starts correctly? PASS ("⚠ Vai apagar...")
- Hint present/absent correctly? PASS (present)
- No markdown formatting? PASS
- No tutorial/syntax explanation? PASS
- curl|jq not classified as execution? N/A
- Inline script uncertainty? N/A
- git add . warning? N/A

================================================================================
SCENARIO 4: PASS — Complex pipelines (4 commands)
================================================================================
Output:
⚠ Vai apagar arquivos .log com mais de 30 dias, gerar report.txt a partir de data.csv, parar todos os containers Docker e limpar imagens/volumes, e executar script inline que faz POST para API externa. Risco alto: exclusao de arquivos, limpeza Docker irreversivel, e execucao remota com dados sensiveis. Comando complexo; o resumo pode omitir detalhes. (mais detalhes: /cae:explain)

Checks:
- Risk level correct? PASS (alto)
- ⚠ placement correct? PASS (first character)
- Consolidated? PASS (no bullets, no individual listings)
- Single block? PASS
- Starts correctly? PASS ("⚠ Vai apagar...")
- Hint present/absent correctly? PASS (present)
- No markdown formatting? PASS
- No tutorial/syntax explanation? PASS
- curl|jq not classified as execution? N/A
- Inline script uncertainty? PASS ("Comando complexo; o resumo pode omitir detalhes.")
- git add . warning? N/A

================================================================================
SCENARIO 5: PASS — Mixed batch with curl READ (6 commands)
================================================================================
Output:
⚠ Vai ler README.md, rodar testes, salvar alteracoes no stash, apagar .cache/, criar greeting.txt, e consultar dados da API do GitHub. Risco alto: inclui exclusao irreversivel de .cache/. (mais detalhes: /cae:explain)

Checks:
- Risk level correct? PASS (alto because rm -rf)
- ⚠ placement correct? PASS (first character)
- Consolidated? PASS
- Single block? PASS
- Starts correctly? PASS ("⚠ Vai ler...")
- Hint present/absent correctly? PASS (present)
- No markdown formatting? PASS
- No tutorial/syntax explanation? PASS
- curl|jq NOT classified as execution? PASS ("consultar dados da API" = network read, not execution)
- Inline script uncertainty? N/A
- git add . warning? N/A

================================================================================
SCENARIO 6: PASS — Inline scripts (2 commands)
================================================================================
Output:
⚠ Vai editar todos os arquivos .conf em /etc substituindo enderecos, e apagar todos os arquivos .bak no diretorio atual. Risco alto: modifica arquivos de sistema e exclui arquivos. Comando complexo; o resumo pode omitir detalhes. (mais detalhes: /cae:explain)

Checks:
- Risk level correct? PASS (alto)
- ⚠ placement correct? PASS (first character)
- Consolidated? PASS (single paragraph, NO bullets)
- Single block? PASS
- Starts correctly? PASS ("⚠ Vai editar...")
- Hint present/absent correctly? PASS (present)
- No markdown formatting? PASS
- No tutorial/syntax explanation? PASS
- curl|jq not classified as execution? N/A
- Inline script uncertainty? PASS ("Comando complexo; o resumo pode omitir detalhes.")
- git add . warning? N/A

================================================================================
SCENARIO 7: PASS — Stress test 10 commands
================================================================================
Output:
⚠ Vai ler arquivos do projeto, adicionar texto em log.txt, fazer backup e editar config.json, instalar dependencias, fazer commit de todas as alteracoes, e apagar dist/. Risco alto: inclui exclusao irreversivel de dist/. Atencao: git add . pode incluir arquivos sensiveis. (mais detalhes: /cae:explain)

Checks:
- Risk level correct? PASS (alto because rm -rf)
- ⚠ placement correct? PASS (first character)
- Consolidated? PASS (10 commands in one flowing sentence)
- Single block? PASS
- Starts correctly? PASS ("⚠ Vai ler...")
- Hint present/absent correctly? PASS (present)
- No markdown formatting? PASS
- No tutorial/syntax explanation? PASS
- Under 4 lines? PASS (3 lines)
- curl|jq not classified as execution? N/A
- Inline script uncertainty? N/A
- git add . warning? PASS ("git add . pode incluir arquivos sensiveis")

================================================================================
FIXES APPLIED: None
REMAINING GAPS: NONE
================================================================================
