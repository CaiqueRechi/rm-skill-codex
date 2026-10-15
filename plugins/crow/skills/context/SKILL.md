---
name: context
description: Prepares a project so work survives the end of a session — another model, another harness (Codex, Cursor, Gemini, Copilot) or a new chat continues exactly where the last one stopped, and agents can leave each other messages. Creates only the missing files among CLAUDE.md, AGENTS.md, GEMINI.md, CONTEXT.md, ARCHITECTURE.md, TASKS.md and .context/, keeps all of them out of git, and saves or resumes the state on demand. Runs only when he calls $crow:context, $crow:context save, $crow:context resume or $crow:context message.
---

# Project context

Arguments: what he wrote after `$crow:context` in the message that invoked
this skill.

The first word picks the command; nothing picks `prepare`.

| Command | When he uses it |
| --- | --- |
| `prepare` | first thing in a project, before any other skill |
| `save` | before the tokens run out, before switching model or harness, at the end of a session |
| `resume` | at the start of a new chat, model or harness |
| `message <to> <text>` | to leave a note for another agent |

The point of every command is the same: someone who never saw this
conversation — another model, another tool, him next week — opens the project
and knows exactly what is going on and what to do next. Write for that reader.
Files are written in Portuguese, the language he reads.

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

## The files

| Path | Holds | Template |
| --- | --- | --- |
| `CLAUDE.md` | orientation for Claude: read the context first, update it before stopping, the rules | [entry.md](templates/entry.md) |
| `AGENTS.md` | the same orientation for Codex — also read by Cursor, Copilot and others | [entry.md](templates/entry.md) |
| `GEMINI.md` | the same orientation for Gemini CLI | [entry.md](templates/entry.md) |
| `CONTEXT.md` | current state, objectives, decisions, restrictions, stack, key paths, how to run and test | [CONTEXT.md](templates/CONTEXT.md) |
| `ARCHITECTURE.md` | the technical architecture in detail | [ARCHITECTURE.md](templates/ARCHITECTURE.md) |
| `TASKS.md` | pending tasks and progress | [TASKS.md](templates/TASKS.md) |
| `.context/CONVENTIONS.md` | his working conventions, for models without this plugin | copied from [../conventions/SKILL.md](../conventions/SKILL.md) |
| `.context/HANDOFF.md` | exactly where the last session stopped and the next action | [HANDOFF.md](templates/HANDOFF.md) |
| `.context/sessions/` | one append-only log per session | [session.md](templates/session.md) |
| `.context/messages/` | one file per message between agents | [message.md](templates/message.md) |

All paths are relative to the project root: `git rev-parse --show-toplevel`,
or the current directory when it is not a git repository.

**Your agent id** signs sessions and messages: harness and model, lowercase,
hyphens — `claude-code-opus-5.5`, `codex-gpt-5`, `cursor-sonnet`. Use the same
id every time in the same session.

## Nothing goes to git

These files are his working memory, not part of the project. Never `git add`
or commit them, and never write them into `.gitignore`, which is itself
tracked.

Keep them out through the repository's local exclude file instead — its path
is `git rev-parse --git-path info/exclude`, which also works inside a
worktree. The entries are:

```
/CLAUDE.md
/AGENTS.md
/GEMINI.md
/CONTEXT.md
/ARCHITECTURE.md
/TASKS.md
/.context/
```

Add only the lines that are not there yet — create the file if it does not
exist. Never remove or reorder what is already in it.

**A file that is already tracked is not yours.** Check each one with
`git ls-files --error-unmatch <path>`. If, say, the project already commits
its own `CLAUDE.md`, do not edit it, do not exclude it, and ask him how to
proceed — editing it would put context into git, which is exactly what he
ruled out. Everything else carries on meanwhile.

## prepare

**Create only what is missing. Never overwrite.**

1. **Take stock.** For every path in the table, record whether it exists and
   whether it is tracked. A file that already exists is read and used as
   context — never regenerated, never "improved", never reformatted.
2. **Read the project** before writing anything: README, dependency manifests,
   `docs/` (in particular `docs/requirements/`, where `$crow:analyst` leaves the
   requirements document), schema or migrations, CI files, `git log
   --oneline -20`, current branch, `git status`. Fill the new files from what
   you read. When an analyst document exists, CONTEXT.md and ARCHITECTURE.md
   come from it.
3. **Do not guess.** Anything you could not read stays as `> A preencher: <what
   is missing>`. List those gaps in the report; for a project with no
   requirements yet, suggest `$crow:analyst` rather than interviewing him here.
4. **Create the missing files** from the templates. `.context/CONVENTIONS.md`
   is the body of the conventions skill — everything after its frontmatter —
   under a first line saying where and when it was copied.
5. **Exclude** the missing lines, as above.
6. **Report**, in three lists: `criados`, `já existiam (mantidos)` and
   `não tocados por estarem no git`. Then the gaps. If an existing file looks
   outdated or contradicts what you read, say so and ask — do not fix it.

Running `prepare` twice in a row must change nothing the second time.

## save

Write down the state so the next reader loses nothing. Edit the sections that
changed; do not rewrite a file wholesale, and never delete history.

1. **Gather facts**, not memories: current branch, last commit (`git log -1
   --oneline`), `git status --short`, and what was done in this session.
2. **TASKS.md** — move what finished to `Concluídas` with the date, update what
   is in progress, add what was discovered.
3. **CONTEXT.md** — update `Estado atual`; append new decisions to the
   decisions table with date, reason and who decided. Past decisions are never
   edited; a reversed decision gets a new row that says so.
4. **ARCHITECTURE.md** — only if the architecture actually changed.
5. **.context/HANDOFF.md** — replace it with the new snapshot. It must name
   **one concrete next action**, specific enough that the next agent can start
   on it without asking. When a skill is mid-way — an analyst interview, a
   develop phase, a security validation — write its working state here: for
   the analyst, every checklist item with its state and the answers so far,
   so the interview resumes on the next question instead of starting over;
   for develop, the phase, its branch and the state of each `RF`, so the phase
   resumes on the next requirement.
6. **.context/sessions/<YYYY-MM-DD>-<agent id>.md** — append this session:
   what was done, what was decided, what was left, files touched. Create the
   file if it does not exist; never edit earlier entries.
7. **Report** what was updated, and say plainly that none of it is in git.

## resume

1. **Read** CONTEXT.md, ARCHITECTURE.md, TASKS.md, `.context/HANDOFF.md` and
   `.context/CONVENTIONS.md`.
2. **Messages.** In `.context/messages/`, read every message whose `to:` is
   your agent id, your harness or `all`, and whose `status:` is `new`.
   Set each to `read` once you have acted on it.
3. **Check the handoff against reality.** Compare the branch, last commit and
   uncommitted files in HANDOFF with the current `git` state. If they differ,
   someone moved on after the last save — say what changed before doing
   anything.
4. **Tell him where things stand** in a few lines: where it stopped, the next
   action, open questions, new messages.
5. **Continue** from the next action. If it requires a decision that is his —
   or the handoff is too vague to act on — ask instead of guessing.

## message

`message <to> <text>` — `<to>` is an agent id, a harness name, or `all`.

Create `.context/messages/<YYYYMMDD-HHMMSS>-<from>-to-<to>.md` from the
template, with `status: new`. One file per message, never a shared file, so
two agents writing at the same moment never overwrite each other. To answer a
message, write a new one with `reply_to: <file name of the original>`.

Messages are how agents in different tools coordinate: there is no live
channel between them, and the files in this project are the only thing they
all can read. The entry files tell every agent to check for messages when it
starts.
