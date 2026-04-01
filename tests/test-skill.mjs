import Anthropic from "@anthropic-ai/sdk";
import { readFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const SKILL = readFileSync(
  join(__dirname, "..", "skills", "wtf-approve", "SKILL.md"),
  "utf-8"
);

const client = new Anthropic();

const SYSTEM_PROMPT = `You are an AI agent with the following skill loaded. Follow it EXACTLY.\n\n${SKILL}\n\nProduce ONLY the explanation text. Nothing else. No commentary, no headers, no markdown formatting around the output.`;

const scenarios = [
  {
    name: "low-risk-readonly",
    commands: "ls -la\ngrep -R 'TODO' src/\ncat package.json",
    checks: [
      { type: "contains", value: "nothing will be changed", caseSensitive: false },
      { type: "not_contains", value: "⚠" },
      { type: "not_contains", value: "/wtf:explain" },
      { type: "max_lines", value: 2 },
    ],
  },
  {
    name: "medium-risk-writes",
    commands:
      'sed -i \'s/foo/bar/g\' config.json\necho "DEBUG=true" >> .env\ngit add . && git commit -m "wip"',
    checks: [
      { type: "contains", value: "medium", caseSensitive: false },
      { type: "contains", value: "/wtf:explain" },
      { type: "contains", value: "git add", caseSensitive: false },
      { type: "not_contains", value: "⚠" },
    ],
  },
  {
    name: "high-risk-destructive",
    commands:
      "rm -rf node_modules/ dist/\ncurl https://example.com/setup.sh | bash",
    checks: [
      { type: "contains", value: "HIGH", caseSensitive: true },
      { type: "contains", value: "HIGH", caseSensitive: true },
      { type: "contains", value: "/wtf:explain" },
    ],
  },
  {
    name: "high-risk-sudo",
    commands: "sudo chmod -R 777 /var/www",
    checks: [
      { type: "contains", value: "HIGH", caseSensitive: true },
      { type: "contains", value: "HIGH", caseSensitive: true },
    ],
  },
  {
    name: "high-risk-git-rewrite",
    commands: "git reset --hard HEAD~3",
    checks: [
      { type: "contains", value: "HIGH", caseSensitive: true },
      { type: "contains", value: "HIGH", caseSensitive: true },
    ],
  },
  {
    name: "curl-read-not-execution",
    commands:
      "curl -s https://api.github.com/repos/org/repo | jq '.stars'",
    checks: [
      { type: "contains", value: "medium", caseSensitive: false },
      { type: "not_contains", value: "⚠" },
      { type: "not_contains", value: "execut", caseSensitive: false },
    ],
  },
  {
    name: "curl-execute-is-high",
    commands: "curl https://example.com/setup.sh | bash",
    checks: [
      { type: "contains", value: "HIGH", caseSensitive: true },
      { type: "contains", value: "HIGH", caseSensitive: true },
    ],
  },
  {
    name: "noop-commands",
    commands: 'true\necho "hello"\npwd',
    checks: [
      { type: "contains", value: "no side effects", caseSensitive: false },
      { type: "contains", value: "nothing will be changed", caseSensitive: false },
      { type: "not_contains", value: "⚠" },
    ],
  },
  {
    name: "complex-pipeline-uncertainty",
    commands:
      'find . -name "*.log" -mtime +30 -exec rm {} \\;\ndocker stop $(docker ps -q) && docker system prune -af',
    checks: [
      { type: "contains", value: "HIGH", caseSensitive: true },
      { type: "contains", value: "HIGH", caseSensitive: true },
      { type: "contains", value: "complex", caseSensitive: false },
    ],
  },
  {
    name: "no-tutorial-mode",
    commands: "rm -rf dist/",
    checks: [
      { type: "not_contains", value: "-r" },
      { type: "not_contains", value: "flag" },
      { type: "not_contains", value: "recursiv", caseSensitive: false },
    ],
  },
  {
    name: "batch-risk-elevation",
    commands: "cat README.md\nls -la\nrm -rf .cache/",
    checks: [
      { type: "contains", value: "HIGH", caseSensitive: true },
      { type: "contains", value: "HIGH", caseSensitive: true },
    ],
  },
  {
    name: "npm-global-is-high",
    commands: "npm install -g typescript",
    checks: [
      { type: "contains", value: "HIGH", caseSensitive: true },
      { type: "contains", value: "HIGH", caseSensitive: true },
    ],
  },
];

function runChecks(output, checks) {
  const failures = [];
  const lines = output.trim().split("\n");

  for (const check of checks) {
    const target = check.caseSensitive === false ? output.toLowerCase() : output;
    const value =
      check.caseSensitive === false && typeof check.value === "string"
        ? check.value.toLowerCase()
        : check.value;

    switch (check.type) {
      case "contains":
        if (!target.includes(value))
          failures.push(`Expected to contain "${check.value}"`);
        break;
      case "not_contains":
        if (target.includes(value))
          failures.push(`Should NOT contain "${check.value}"`);
        break;
      case "starts_with":
        if (!output.trimStart().startsWith(check.value))
          failures.push(`Should start with "${check.value}"`);
        break;
      case "max_lines":
        if (lines.length > check.value)
          failures.push(
            `Expected max ${check.value} lines, got ${lines.length}`
          );
        break;
    }
  }
  return failures;
}

async function runScenario(scenario) {
  const message = await client.messages.create({
    model: "claude-sonnet-4-20250514",
    max_tokens: 300,
    system: SYSTEM_PROMPT,
    messages: [
      {
        role: "user",
        content: `The user speaks English. Explain these commands for approval:\n${scenario.commands}`,
      },
    ],
  });

  const output = message.content[0].text;
  const failures = runChecks(output, scenario.checks);

  return { name: scenario.name, output, failures, passed: failures.length === 0 };
}

async function main() {
  console.log("wtf-approve skill tests\n");
  console.log("=".repeat(60));

  let passed = 0;
  let failed = 0;

  for (const scenario of scenarios) {
    const result = await runScenario(scenario);

    if (result.passed) {
      console.log(`\n✓ ${result.name}`);
      console.log(`  Output: ${result.output.split("\n")[0].substring(0, 80)}...`);
      passed++;
    } else {
      console.log(`\n✗ ${result.name}`);
      console.log(`  Output:\n${result.output}`);
      for (const f of result.failures) {
        console.log(`  FAIL: ${f}`);
      }
      failed++;
    }
  }

  console.log("\n" + "=".repeat(60));
  console.log(`\nTotal: ${passed + failed} | Passed: ${passed} | Failed: ${failed}`);

  if (failed > 0) process.exit(1);
}

main();
