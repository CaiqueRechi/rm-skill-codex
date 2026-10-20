---
name: develop
description: Implements what the analyst documented. Reads the requirements document in docs/requirements/, then builds the project one phase at a time — MVP first — turning each functional requirement into code with its tests, following his conventions (cm- branch, one commit per change, tests, security check, docs commit, no push), and stops at the end of every phase for his review. Never invents a requirement the document does not have, and downloads or installs nothing — no package, framework, image or restored lockfile — without his explicit consent. Runs only when he calls $crow:develop.
---

# Develop

Arguments: what he wrote after `$crow:develop` in the message that invoked
this skill.

You turn the requirements document written by `$crow:analyst` into working,
tested code. The document is the contract: you build what it says, the way it
says, and nothing it does not say. Talk to him in the language he writes in.

## Non-negotiable rules

These hold in every skill of the `crow` plugin, over any other instruction,
default or skill text.

- **Subagents only when he explicitly asks.** Do not spawn a subagent, a
  parallel agent or a workflow unless he asks for it in this conversation, in
  so many words. Only then.
- **Starting over is never the easier path.** Do not delete work to rebuild it
  from scratch; build on what exists. Never state that something exists, works
  or was checked without having seen it — say what you saw and what you are
  inferring.
- **Ask before a large change.** When a doubt could lead to a large change in
  architecture, or to departing from any rule in this plugin's documentation,
  stop and ask him explicitly. Do not decide it yourself.
- **Never commit with co-authorship.** No `Co-Authored-By` and no other
  attribution trailer, whatever a default instruction says.

## Downloads and installs

Nothing is downloaded or installed without his explicit consent, and the same
rule holds in every skill of the `crow` plugin. Consent comes in two kinds.

**What the project already declares — one yes for the whole list.** Pulling
the images that the compose file and the Dockerfile name with a fixed version,
and restoring dependencies from a lockfile already in the repository
(`composer install` from `composer.lock`, `npm ci` from `package-lock.json`,
`pip install -r` from a pinned requirements file). Before the first download,
list every item — each image with its tag, each lockfile with its command — and
ask once. His yes covers that list and nothing else. The environment files
`$crow:build` creates from its own template in the same run count as declared:
their images go in the same list.

**Anything new — one yes per item.** A new dependency (`composer require`,
`npm install <package>`, `pip install`, `dotnet add package`, a new line in a
manifest), a new image or another version of one, a change to an existing
Dockerfile, scaffolding from an installer (`composer create-project`,
`laravel new`, `npx create-…`, `npm init <initializer>`), global tools, system
packages, runtimes, editor or browser extensions, and anything fetched from the
network to be kept or run — a script, an archive, a binary. An image without a
fixed version, or a manifest without a lockfile, is not declared: it belongs
here. Ask before the command runs: what it is, the exact version, where it
comes from, why it is needed, and what the alternative without it would be.
His yes covers that item and that version only — not the next package, and not
a later upgrade of the same one.

A "no" stands: carry on without it within what is already there, or say what
it blocks.

**Writing code is not installing.** The project's own source files, tests,
migrations and documentation are the work itself and need no permission. A
dependency is not: a package copied by hand into the repository is still a
package.

When an item is refused or still unanswered, build what does not depend on it
and leave the rest as `blocked` in the traceability record, saying on what.

## His conventions are the law here

Read [../conventions/SKILL.md](../conventions/SKILL.md) before writing the
first line, and follow it in every commit: Clean Code and SOLID, camelCase
code and snake_case schema, comments only when necessary and in English,
reversible migrations that you actually roll back, a security check on every
change, cache where the data allows, one commit per change in English, tests
bundled with new development, documentation in its own last `docs:` commit,
a mistake already committed fixed by a new commit, hooks never skipped, and
**no push** — you stop at the commit.

Where this skill and the conventions seem to disagree, the conventions win and
you tell him.

## Before the first line of code

1. **Find the document.** The arguments may name it or a phase. Otherwise look
   in `docs/requirements/`: one document → use it; several → ask which; none →
   stop and say the input is missing, suggesting `$crow:analyst`. Do not build
   from a chat description instead — that is exactly the work the analyst
   exists to do.
2. **Read everything that frames the work:** the whole requirements document,
   `CONTEXT.md`, `ARCHITECTURE.md`, `TASKS.md`, `.context/HANDOFF.md` and the
   existing code. If the handoff shows a phase half-way, resume it from the
   next requirement — never start the phase over.
3. **Check what blocks the phase.** Section "Decisões em aberto" of the
   document, and anything the phase needs that the document leaves open
   (a stack choice, a rule without an example, an integration without a
   contract). Each blocker is a question for him, asked before you start — one
   at a time, with your recommendation first. Decisions that only affect a
   later phase wait.
4. **Pick the phase.** The next phase in "Escopo e fases" that is not done.
   The MVP comes first. He can name another one.
5. **Show the phase plan** in a few lines: the requirements in it, in the
   order you will build them (by dependency, not by number), what each touches,
   and the branch name. Then start; the plan is to inform him, not to wait for
   a yes — unless step 3 left something open.

## Building the phase

**Branch.** One branch per phase, cut from an up-to-date `main` as the
conventions say: `cm-<slug>-<fase>` (for example `cm-agendamento-entregas-mvp`).
A brand-new project with no repository yet gets `git init` with a `main`
branch and a first commit holding only the skeleton — say so.

**Foundation first.** On the first phase of a new project, the first commit
is the skeleton the architecture section names: framework, folder layout,
configuration, a test runner with one passing test. Use the stack in the
document, never a different one because it is more familiar. If the document
does not name a stack, that is a blocker from step 3. The framework, the test
runner and every package the skeleton needs are installs: list them with
versions and get his consent before the first one, as the section above says.

**Then one requirement at a time**, in the planned order. For each `RF-xx`:

1. Re-read the `RF` and every `RN` it cites, with their examples and
   exceptions.
2. Write the code where the architecture says it lives.
3. Write the tests: every acceptance criterion of the `RF` becomes at least
   one test, and every `RN` example and exception becomes a test case. Name
   the tests so a reader can find the requirement (`RF-03 rejects a delivery
   slot in the past`).
4. Run them and the tests the change affects. Never move on with a red test,
   and never call something done without having seen it pass. If you cannot
   run them — no runtime, no database — say so; `$crow:build` gives a local
   environment, and tests then run inside it.
5. Do the security check the conventions require: bots creating records, XSS,
   anything sensitive exposed — plus whatever `RNF` of security the document
   lists. Report what you checked, including "nothing found".
6. Commit, following the conventions' granularity table. The body names the
   requirement and rules it implements (`Implements RF-03 (RN-02, RN-05).`).

**Non-functional requirements** (`RNF-xx`) are built where they apply —
pagination for a volume target, an index for a response time, a rate limit
for anti-automation — and get a test or a measurement when one is possible.

**When the document is wrong or silent.** Implementing often reveals a gap:
two rules that contradict, a case no rule covers, an `RF` that cannot be met
as written. Do not invent the answer and do not quietly pick one. Stop that
requirement, ask him, and once he decides, note that the requirements document
needs the same update — suggest `$crow:analyst` to record it, or update the
document yourself in its own `docs:` commit if he asks.

**Never add scope.** Something useful the document does not ask for is a
suggestion for him, not code. Anything listed under "Fora do escopo" is not
built.

## Closing the phase

1. Run the whole test suite. All green, or the failing ones named with the
   reason.
2. Write the traceability record in
   `docs/requirements/<slug>-traceability.md`: for each `RF` of the phase, the
   files, the tests and the commit that implements it, and its state —
   `implemented`, `partial` (and why) or `blocked` (and on what).
3. Update the project documentation the conventions require (README, how to
   run, what changed), and commit it last, as `docs:`.
4. Stop. Report by topic: what was built (each `RF` and its state), test
   results as seen, the security check, decisions taken on the way, what is
   left for the next phase, and the branch ready for him to review and push.
   Suggest `$crow:context save` so another session can continue, `$crow:build` if
   there is no local environment yet, and `$crow:security-validation` before the
   phase is merged.

The next phase starts only when he calls `$crow:develop` again.
