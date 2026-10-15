---
name: build
description: Builds a local environment where he can open and test the project — Docker Compose on his machine only, with the database and services the architecture needs, test data and test accounts, ports bound to localhost, and a URL that was checked before it is handed over. Creates only the environment files that are missing, never deploys and never touches anything outside the project. Runs only when he calls $crow:build, $crow:build up, $crow:build down or $crow:build status.
---

# Build the local environment

Arguments: what he wrote after `$crow:build` in the message that invoked this
skill.

The first word picks the command; nothing picks `up`.

| Command | Does |
| --- | --- |
| `up` | creates the missing environment files, starts the containers, prepares the database and checks the URL |
| `status` | shows what is running, on which ports, and whether the URL answers |
| `down` | stops the containers and keeps the data |
| `reset` | destroys the local data and starts clean — only after he confirms |

Local only: everything runs on his machine, in Docker Compose. This skill never
deploys, never pushes an image, never touches a server. Talk to him in the
language he writes in.

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

## up

### 1. Know what to run

Read `ARCHITECTURE.md`, the requirements document in `docs/requirements/`, and
the project's manifests (`composer.json`, `package.json`, `requirements.txt`…).
From them, list the services the project needs: the application, its database
and version, and only the extras the architecture names (cache, queue worker,
mail catcher, search). Nothing the project does not use.

No application code yet? Then there is nothing to run: say so and suggest
`$crow:develop` first.

[references/stacks.md](references/stacks.md) has the pattern for each common
stack; [templates/php-laravel/](templates/php-laravel/) is the full set for
PHP and Laravel.

### 2. Check Docker

`docker info`. If the daemon is not running, ask him to open Docker Desktop and
wait — do not start or reconfigure it yourself.

### 3. Create only what is missing

Take stock first: `compose.yaml` (or `docker-compose.yml`), `docker/`,
`.dockerignore`, `.env.example`, `.env`, the entries in `.gitignore`.

- A file that exists is **never overwritten**. Read it and use it. If it
  cannot work as it is — a missing service, a wrong port — say what and ask
  before changing it.
- Missing files are created from the stack pattern, adapted to the project.
- Missing keys in `.env.example` and `.env` are added; existing keys are left
  alone.

### 4. Keep it local and safe

- **Ports bind to `127.0.0.1`**, never to every interface: nothing on the
  network reaches his environment. Before choosing a port, check it is free;
  if not, take the next free one and write it to `.env`.
- **Secrets live only in `.env`**, which stays out of git; `.env.example`
  holds placeholders. Local passwords are generated, never reused from any
  other environment.
- **Images are pinned** to a version tag (`mysql:8.4`), never `latest`.
- **No privileged containers**, no Docker socket mounted, no host directory
  outside the project mounted.
- **One compose project per project** (`name:` in `compose.yaml`), so
  commands never touch another project's containers or volumes.
- `APP_DEBUG` and similar development settings are fine here and stay in
  `.env`; nothing local is copied into a production configuration.

### 5. Start and prepare

1. `docker compose up -d --build`, then wait until every service with a
   healthcheck reports healthy.
2. Inside the application container: install dependencies, generate the
   application key if the framework needs one, run the migrations and the
   seeders.
3. **Test data and test accounts** come from the project's own seeders. If
   there are none, write a seeder that only runs in the local environment,
   with one account per role in the requirements document and fictitious
   data. Their credentials are local test values: keep them in the seeder or
   `.env.example`, point him there, and do not repeat them in the chat.
4. Run the test suite once inside the container, if there is one.

### 6. Check before handing it over

Request the URL and look at the answer: the home or login page must respond
(200 or a redirect to login), and the logs must be free of errors. Never say
the environment is up without having seen this.

### 7. Commit the environment files

The environment files belong to the project — whoever clones it can run it —
so they are committed, following his conventions: their own `cm-` branch cut
from `main`, `chore:` commits in English, no co-author, no push. `.env` is
never committed; make sure `.gitignore` covers it before the first commit.

If the application only exists on a phase branch that is not merged yet, ask
him whether the environment goes on that branch or waits for the merge.

### 8. Report

- the URL, and how to open it;
- where the test accounts are;
- what runs: each service, image and port;
- the result of the URL check and of the test suite, as seen;
- the commands, one per line: start, stop, logs, run the tests, open a shell
  in the application container;
- what was created and what already existed;
- that `reset` destroys the local data.

## status

`docker compose ps` and a request to the URL. Report what runs, on which port,
and whether the URL answers. Change nothing.

## down

`docker compose down` — without `-v`. The data stays in the volumes.

## reset

Destroys the local database and any other volume of this project. **Ask
first**, saying exactly what will be lost. Only after his yes:
`docker compose down -v`, then `up`.

## Never

- deploy, push an image, or run anything against a server;
- `docker system prune`, `docker volume prune`, or any command without the
  project's compose scope;
- delete volumes, containers or images without his confirmation;
- touch containers of other projects;
- change Docker Desktop settings.
