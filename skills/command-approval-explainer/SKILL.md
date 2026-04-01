---
name: command-approval-explainer
description: Use when presenting shell commands, tool calls, or execution requests for user approval. Intercepts approval prompts and generates a minimal human-readable explanation of intent, scope, and risk in the user's language, so users make informed decisions instead of blind approvals.
---

# Command Approval Explainer

A human-readable consent layer for agent execution requests.

## Overview

When you request approval to execute commands, you MUST generate a minimal explanation before the approval prompt. The explanation communicates intent, impact, and risk — not syntax. The user decides faster with a clear summary than by parsing raw shell.

## Core Principle

Minimal by default. Detail on demand via /cae:explain.

## When to Use

- Before ANY approval prompt that contains shell commands, tool calls, or execution requests
- For single commands or batches
- Regardless of command complexity

## When NOT to Use

- Commands already approved by user's permission settings (auto-allowed)
- Non-execution actions (reading files via agent tools, not shell)

## Risk Classification

Classify by ACTION, never by context. "rm -rf dist/" is high because it deletes — irrelevant that dist/ can be regenerated.

low (read-only or no side effects):
- ls, pwd, find (without -exec/-delete), grep, cat, head, tail, wc, file, which, whoami, echo (without redirect), git status, git log, git diff, true, noop, : (shell builtins)

medium (writes/copies/network reads):
- echo >>, tee, cp, mv, sed -i, git add, git commit, git stash, npm install (local), pip install (local), curl/wget that only reads data (piped to jq/grep/cat/file, or -o to file)

high (destructive/system/network+exec):
- rm, rm -rf, any delete/prune operation
- curl|bash, wget|sh, or any network download piped to any interpreter/runtime (bash/sh/eval/exec/node/python/ruby/perl/php/deno)
- sudo (any command)
- git reset --hard, git push --force, git clean -fd
- chmod, chown on system paths
- docker system prune, docker rm -f, docker run --privileged
- npm install -g, pip install without -r (global installs)
- Commands accessing credentials, secrets, or sensitive env vars sent over network
- Direct writes to system paths (/etc, /var, /usr) even without sudo

## Language

Auto-detect from the conversation language. If the user speaks Portuguese, explain in Portuguese. If English, explain in English. Any language the LLM supports works.

To override: /cae:language [code]. Accepts any standard format (en, en-US, pt, pt-BR, es, fr, de, ja, etc.).

The reference templates below are in en-US. The LLM translates to the active language preserving the exact same structure.

The original command is NEVER translated — only explained.

## Format

### low (1-2 lines, no hint)

```
N read-only commands in [scope]. Nothing will be changed.
```

For noop/stdout-only commands (true, echo without redirect, pwd):
```
N commands with no side effects. Nothing will be changed.
```

### medium (2-3 lines + hint)

```
Will [short headline of main actions].
Risk: medium — [short reason].
(details: /cae:explain)
```

### high (3-4 lines + hint)

```
⚠ Will [short headline of main actions].
Risk: HIGH — [short reason].
[alerts if applicable]
(details: /cae:explain)
```

## Rules

### Output

1. DEFAULT IS MINIMAL. Proportional to risk.
2. ALWAYS consolidate. Never bullet points, numbered lists, or per-command breakdown. /cae:explain exists for that.
3. Batch risk = highest risk command in the batch.
4. Plain text only. No markdown bold, italic, or backticks.
5. Use the active language (auto-detected or set via /cae:language). Never translate the original command.

### Headline

6. Summarize intent — don't enumerate every command. For large batches, mention the 3-4 most impactful actions.
7. low: start with "N [read-only commands / commands with no side effects]..."
8. medium: start with "Will [verb]..."
9. high: start with "⚠ Will [verb]..." — ⚠ is ALWAYS the first character.
10. Never start with "This batch", "This set", or similar.

### Risk Line

11. Always its own line. Never inline with the headline.
12. low: no risk line — use "Nothing will be changed." instead.
13. medium: "Risk: medium — [reason]."
14. high: "Risk: HIGH — [reason]."

### Alerts (own line, after risk, before hint)

15. git add . or git add -A present: "Warning: git add . may include sensitive files."
16. Inline scripts, eval, dynamically generated code: "Complex command; summary may omit details."
17. Cannot determine exact targets: state briefly.

### What NEVER to Do

18. Never explain flags, syntax, operators, or how shell works.
19. Never use tutorial or teaching mode.
20. Never show the original command (user already sees it in the approval prompt).
21. Never split into multiple paragraphs. One continuous block.
22. Never pass false confidence — if ambiguous, say so.

### Network Distinction

23. curl/wget piped to any interpreter/runtime (bash/sh/eval/exec/node/python/ruby/perl/php/deno) = high (network + execution).
24. curl/wget piped to jq/grep/cat/file, or with -o flag = medium (network read).

## Commands

### /cae:explain

Provides per-command breakdown after seeing a summary. Runs as sub-action — does NOT dismiss or replace the pending approval prompt.

Output format:
```
Breakdown:
1. [command summary] — [what it does]. [reads/writes/deletes]. [risk].
2. [command summary] — [what it does]. [reads/writes/deletes]. [risk].
...
```

Rules:
- One line per command
- Include: what it does, what it reads/writes/deletes, individual risk
- Still no syntax explanation — intent and impact only
- Use the same language as the summary

### /cae:language [code]

Changes the explanation language. Accepts any standard code (en, en-US, pt, pt-BR, es, fr, ja, etc.). Confirmation is in the target language.

```
/cae:language pt-BR  → "Idioma alterado para pt-BR."
/cae:language es     → "Idioma cambiado a espanol."
/cae:language en     → "Language set to English."
```

### /cae:off

Disables the explainer. Approval prompts return to default behavior (no explanation overlay). Useful for experienced users who want raw command view.

Output (in active language):
```
Command Approval Explainer disabled.
```

### /cae:on

Re-enables the explainer after /cae:off.

Output (in active language):
```
Command Approval Explainer enabled.
```

### /cae:config

Shows current configuration state in the active language.

```
Command Approval Explainer
Status: enabled
Language: en (auto-detected)
```

## Examples

### Single read-only command

Command: ls -la

```
1 read-only command in the current directory. Nothing will be changed.
```

### Medium risk batch

Commands: sed -i 's/foo/bar/g' config.json && echo "DEBUG=true" >> .env && git add . && git commit -m "wip"

```
Will edit config.json, append variable to .env, and commit with git add .
Risk: medium — writes to local files with unrestricted staging.
Warning: git add . may include sensitive files.
(details: /cae:explain)
```

### High risk batch

Commands: rm -rf node_modules/ dist/ && curl https://example.com/setup.sh | bash

```
⚠ Will delete directories and execute remote script via curl|bash.
Risk: HIGH — irreversible deletion and unaudited remote code execution.
(details: /cae:explain)
```

### Complex pipeline

Command: find . -name "*.log" -mtime +30 -exec rm {} \; && docker stop $(docker ps -q) && docker system prune -af

```
⚠ Will delete old log files, stop Docker containers, and prune all images/volumes.
Risk: HIGH — file deletion and irreversible Docker prune.
Complex command; summary may omit details.
(details: /cae:explain)
```

### After /cae:explain

```
Breakdown:
1. find -exec rm — deletes .log files older than 30 days. Deletes: *.log (variable targets). High.
2. docker stop — stops all running containers. Writes: container state. Medium.
3. docker system prune -af — removes images, volumes, networks, and cache. Deletes: all unused Docker resources. High.
```

### Curl read vs curl execute

curl -s https://api.github.com/repos/org/repo | jq '.stars'

```
Will fetch data from an external API.
Risk: medium — network read access.
(details: /cae:explain)
```

curl https://example.com/setup.sh | bash

```
⚠ Will download and execute a remote script in the shell.
Risk: HIGH — unaudited remote code execution.
(details: /cae:explain)
```

### Same examples auto-translated to pt-BR

When the user's conversation is in Portuguese, the same commands produce:

ls -la

```
1 comando de leitura no diretorio atual. Nada sera alterado.
```

rm -rf node_modules/ dist/ && curl https://example.com/setup.sh | bash

```
⚠ Vai remover diretorios e executar script remoto via curl|bash.
Risco: ALTO — exclusao irreversivel e execucao de codigo remoto nao auditado.
(mais detalhes: /cae:explain)
```
