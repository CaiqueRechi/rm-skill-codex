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
