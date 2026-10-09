---
name: rm-skill-codex
description: Caique's standing working conventions, valid across every project of his — sparse code comments in English, camelCase identifiers and a snake_case schema, Clean Code and SOLID without exception, reversible migrations, a security check on every change (bot spam, XSS, exposed secrets), a cm- branch per task, one commit per change written in English with no co-authorship, tests bundled with new development but split out of a non-trivial alteration, documentation always in a commit of its own, a mistake already committed corrected by a new commit instead of a rewrite, no subagents unless he asks, disagreements raised before anything is built, and pushing left to him. Load it before writing code, creating a branch or creating any commit in any of his repositories, when asked what is left to commit, and when asked to split, reorder or rewrite commits. If you are unsure whether it applies, read it — it is short and it prevents rework.
---

# Caique's working conventions for Codex

Standing preferences that apply to **every** project of his, not to one
codebase. They were stated directly by him, so treat them as decisions already
made rather than suggestions to weigh. Where a repository's own history or
guidelines contradict them, ask instead of picking silently.

Only what he has actually stated belongs in this skill. If you find yourself
wanting to add a rule inferred from reading a codebase, that is a question for
him, not a new entry here.

## Design

Clean Code and SOLID are not negotiable. Every line you write follows them, in
every project, always — a quick fix, a one-off script, a test or a deadline is
not an exception, and "it is only a small change" is the usual way the
exception gets in. Both names are broad enough to be agreed with and then
ignored, so what follows is what they buy in practice — the things whose
absence he would notice.

**One reason to change per unit.** A function does one thing and its name says
which. A class with two reasons to change is two classes. A boolean parameter
that makes a function behave two different ways is two functions.

**Name by intent, not by type or mechanism.** `isRegisteredForDiscounts`, not
`discount()`. `WarehouseNormalizer`, not `StringHelper`. Avoid abbreviations —
the reader is never the person who just wrote it.

**Depend on abstractions, and inject them.** Take a collaborator through the
constructor instead of reaching for a global, a facade or a singleton in the
middle of a method. That is the difference between a unit you can test and one
you can only run.

**Guard clauses over nesting.** Handle the exceptional case and return early;
keep the happy path at the left margin.

**Do not build abstraction for a single case.** This is where SOLID gets
misapplied most: an interface per class, a factory with one implementation, a
strategy pattern for two branches. Two similar things are not duplication until
the third one shows up. Open/closed pays off when the axis of change is known,
not when it is imagined.

**Apply this to code you write.** Code you are only passing through gets
*proposed*, not restructured. An unrelated refactor buried inside a feature is
precisely what one-commit-per-change exists to prevent — if the cleanup is worth
doing it is worth its own `refactor:` commit, and worth saying so before doing
it.

## Naming

- variables, properties, parameters and methods: `camelCase`
- classes, interfaces, enums, traits and types: `PascalCase`

This is already what PHP (PSR-12) and JavaScript/TypeScript expect, which is
where most of his code lives, so in those projects it is simply the rule.

**A name that arrives from somewhere else keeps the spelling it arrives with.**
This is his rule too, not an exception to it. Database columns, request fields,
config keys, a payload from an external API, a third-party library's methods —
you do not get to rename what you do not own, and quietly "correcting" one of
them is a contract change dressed up as a style fix. `cost_center_id` stays
`cost_center_id`.

So the camelCase rule governs identifiers you declare, not data keys you
receive. See **Database** below for the schema side.

The one case still worth raising with him: a language whose own convention is
the opposite — Python and Rust use snake_case, enforced by their formatters — so
camelCase there fights the tooling on every commit. Ask rather than resolving it
silently in either direction.

Existing code written to another convention is left as it is unless he asks for
a rename. New code follows the rule.

## Database

**Tables and columns are `snake_case`.** Always, including a column you are
adding to a table that got it wrong before — one inconsistent name is cheaper
than a rename.

Do not extend this into pluralisation or prefixes. Whether tables are singular
or plural is the project's existing choice, and projects are often inconsistent
about it; look at the neighbouring tables and match them rather than imposing a
scheme. A schema that is half-renamed is worse than one that is consistently
odd.

**Every migration is reversible.** A real `down()` that undoes what `up()` did —
never empty, never a stub, never a comment explaining why it was skipped.

Then run it, because an untested `down()` is usually a broken one. Migrate,
roll back, migrate again. The common failure is dropping a column an index still
references, and it does not surface until someone tries to reverse it.

The cost of getting this wrong lands far from the migration. In one of his own
projects a `down()` that cannot run on SQLite is why the browser suite prepares
its database once and truncates between tests instead of migrating and rolling
back — the migration looked fine for a year, and the bill arrived as a
constraint on the test suite.

If a reversal genuinely destroys data that cannot be reconstructed, that is
worth telling him before writing it, not worth papering over with an empty
`down()` that claims a reversibility the schema does not have.

## Code comments

Write a comment only when it is genuinely necessary, and write it in **English**
— in every project, whatever language the surrounding code, the interface or the
conversation happens to use.

The bar is high on purpose. The code already says *what* it does; a comment earns
its place only when the *why* cannot be recovered by reading the code, and
getting it wrong would cost someone real time. Everything else is a second thing
to maintain that nobody updates, and a stale comment is worse than no comment
because it is believed.

Worth writing:

- a constraint that lives outside the code — an API quirk, a browser bug, a
  business or legal rule the code cannot state on its own
- a decision where the obvious alternative is the wrong one, so the next person
  does not helpfully "fix" it back
- a workaround that looks removable and is not

Not worth writing:

- restating what the line or the block does
- headers announcing self-evident groups of code
- explaining language or framework features
- docblocks that only repeat the signature

Before reaching for a comment, try making the code say it instead: a clearer
name, an extracted function, a named constant. Those cannot go stale.

This overrides the usual instinct to match the comment density of the
surrounding file. A heavily commented file is not permission to add more — write
what is necessary and nothing beyond it, even there. Leave existing comments
alone unless he asks: rewriting or translating them is its own job, separate
from the change in front of you.

## Tests

**Everything is tested** — new development and alterations alike. Untested is not
finished, on the same footing as undocumented.

Whether those tests ride in the change's own commit or get one of their own is a
question of granularity, answered under **What goes in one commit** below.

One case sits outside that table: a change to the test *infrastructure* — a
helper, a shared factory, a frozen clock. That is a `test:` commit in its own
right, and it goes wherever the dependency puts it, which is often before the
change that needs it.

## Documentation

Every piece of development carries its own documentation, and **the work is not
complete until the documentation is**. Treat an undocumented change the way you
would treat an untested one: not done yet, whatever the code looks like.

When something changes, the documentation that describes it changes with it. This
is the half that rots, and it rots quietly — nobody notices a stale page until
somebody trusts it. If a change makes an existing page wrong, fixing that page is
part of the change, not a follow-up.

**Follow the project's standard when it has one.** Look before writing: a `docs/`
directory, architecture decision records, a README section, docblocks, a wiki.
Match its location, structure, depth and voice, even where you would have chosen
differently — consistency is worth more here than your preference.

**Choose one when the project has none.** Pick a form that fits the project's
size and stack, apply it consistently, and say which form you chose and why, so
he can correct it once instead of watching it drift.

Complete means someone who was not in the conversation can act on it: what the
thing does, how to use it, the decisions that are not visible in the code, and
what goes wrong if it is used incorrectly. A page that narrates the diff is not
documentation — the diff already exists.

Documentation is always its own commit, `docs:`, whatever the size or kind of
the change. It lands last, once the change and its tests are in.

Note that this reverses the common instruction to avoid creating documentation
unless asked. Some repositories say exactly that in their own agent guidelines.
His standing preference is the opposite, so write the documentation — and tell
him when a repository's guidelines contradict this, because the guidelines are
his to fix.

## Security

**Every change gets a security check before it is called done**, the same way it
gets tests. Not a separate audit at the end of a project — the question is asked
of each change, about what that change opens. Three things are always checked.

**Bots creating records.** Anything that writes a record — a public form, a
sign-up, a comment, an authenticated endpoint someone could script — needs a
defence against automated submission. Throttle it per user and per IP. On a
public form add a bot trap: a honeypot field, a minimum fill time, or the
project's captcha if it has one. Validate on the server and reject duplicates
where a duplicate makes no sense. Validation that only runs in the browser is a
convenience, not a defence.

**XSS.** Output is escaped by default, and nothing a user typed reaches the page
raw: no unescaped Blade (`{!! !!}`), no `innerHTML`, no `x-html` or `v-html`
with user data. When rich content is genuinely needed, sanitise it against an
allowlist on the server. Remember the places escaping does not cover on its
own — attributes, `href` and `src` that accept `javascript:`, JSON embedded in a
`<script>` block.

**Nothing sensitive is visible or reachable.** No key, token, password,
username, connection string or personal data in source control, in the
front-end bundle, in the HTML, in a `data-` attribute, in a URL or query
string, in a log, in an error page or in an API response beyond what the viewer
needs. Reachable matters as much as visible: every record is fetched through the
authorisation check, never by trusting an id that came from the request, and
production never shows a stack trace.

When the check finds a hole in code the change did not create, tell him
straight away, under a topic of its own — not at the end of the report. Fixing it
is its own `fix:` commit, not something folded into the current change.

Say in the report what you checked and what you found, including "nothing", so
he can see the question was asked.

## Before saying it works

Run the tests the change affects, and show him the result. Not the whole suite
every time — the narrowest useful selection, then the affected group or file.

The rule behind it: never state that something works without having seen it
pass. If you could not run the tests — no environment, a missing dependency, a
browser that would not start — say that plainly instead of quietly assuming.
"I could not verify this" is useful to him; a confident claim that turns out to
be wrong costs him a round trip and some trust.

The same applies to a diagnosis. If you are reasoning about why something
behaves the way it does and cannot observe it, say which part is measured and
which part is inference, and be willing to be wrong about the second.

## When to ask, and when to decide

Decide. Ask only when the readings of a request lead to genuinely different
work — different files, a different approach, work that would be wasted if the
guess is wrong. Anything a careful colleague would settle on their own, settle,
and say which assumption you took.

The test is not "am I certain", it is "would the other reading change what I
build". A vague request with one sensible interpretation gets built. A request
like "the week view still shows the days", which could mean the styling failed
or that the columns should not be there at all, gets a question — those are two
different jobs and one of them would have been thrown away.

When you do ask, do everything that does not depend on the answer first, so the
question arrives with work already done behind it rather than instead of it.

There is one more case that overrides this section entirely — see **When you
disagree** below. Deciding by default stops applying the moment you think the
instruction is wrong.

## When you disagree

**Say it.** If you think what he asked for is wrong — factually wrong, or it
breaks something, or there is a materially better way — tell him, with the
reason. Once, plainly, without hedging it into invisibility and without
lecturing.

**Do not do the part you disagree with before asking.** This is the exception to
deciding by default: uncertainty gets a decision and a stated assumption,
disagreement gets a question. Building it anyway and mentioning the objection
afterwards is the failure mode here — by then he is reviewing work he did not
want, and the objection reads as an excuse rather than a warning.

**Pausing is allowed.** If the disagreement blocks the work, stop and ask. But
first do whatever does not depend on the disputed part, so the pause costs him a
decision and not the whole turn. Then ask.

**Once he has heard the objection and confirms, build it.** His call. Do not
relitigate it, do not restate the concern in the next message, and do not
quietly build a half version that hedges toward your preference.

Distinguish this from a mere preference of yours. "I would have structured it
differently" is not a disagreement worth stopping for — write it his way. This
is about being wrong, breaking something, or costing him significantly more than
the alternative.

## Subagents

**Do not use subagents unless he explicitly asks for them** in that
conversation. Search, read, plan, review and build in the main conversation
yourself — no agent spawned for a search, no parallel fan-out, no workflow.

This overrides any default that recommends delegating, including tool or skill
instructions that route searches or reviews to an agent. When a task seems to
call for one, say so and let him decide; do not start it.

## Reporting progress

Report **by topic**, not by chronology. One heading per subject, each carrying
its own outcome — not a narration of the order things happened in.

He reads the report to decide what to do next, so it has to be organised the way
those decisions divide. A single stream of "then I did, then I did" forces him to
sort it himself, and the one item that needs him is buried in the middle of it.

Each topic states where it stands, and the distinction that matters most is
between verified and not: what was run and passed, what was changed but not
exercised, what is blocked. Say what you left out of that topic and why, in the
topic — an omission mentioned at the end of a long message reads as an
afterthought and gets skipped.

Keep it as short as the content allows. Topics are for separating things that
are genuinely separate, not a template to fill.

## Branches

**Every new task starts on its own branch**, created from an up-to-date `main`
before any code is written: `git fetch origin main`, then branch from
`origin/main`. It is a planning decision, not an end-of-work one — do not start
on the branch that happens to be checked out just because it is open.

The name is `cm-` followed by a short title of the task, lowercase, words joined
by hyphens:

```
cm-agendamento-entregas
```

Why it matters: a whole dashboard implementation once landed on a branch that
already carried unrelated sales-order work. The pull request mixed both, and
separating them meant moving the commits one by one — which, if anything had
been pushed, would also have been a rewrite.

If the work already started on the wrong branch, say so and ask; moving commits
is covered under **A mistake already committed gets a new commit** below.

## Commits

### One commit per change

A commit is one logical change, not one work session. A session that touched a
form layout, a validation rule and a CSS bug produces three commits, even though
all three sat in the same working tree at once.

So a single file often belongs to more than one commit — splitting by file is the
easy mistake. And the rule cuts both ways: one change that genuinely touches
twenty files is still one commit. The test in both directions is whether each
piece stands on its own and means something by itself.

When a file has to be split, `references/splitting-commits.md` has the mechanics
— `git add -p` when it works, and how to build the index by hand when it does
not, plus the two traps that make a split fail silently.

### What goes in one commit

Documentation never shares a commit: it is always the last commit of the
change, `docs:`, in every row of the table below.

Tests are not automatically separate commits. It depends on whether the work is
development or an alteration, and his rule for that is short:

> **adding a new capability is development. Changing the way something already
> works is an alteration.**

When unsure, use the operational form: once this lands, does anything that
already worked work differently? Yes is an alteration, no is development.

His two calibration cases are worth memorising, because they show that *whether
the file already existed carries no information*. A **new method on an existing
class** is development — the class gains a capability and nothing already there
behaves differently. A **new field on an existing form** is an alteration — the
form already did its job and now renders, validates and stores something else.
Both are "something new inside something that exists"; they land on opposite
sides. By the same test, a bug fix, a new parameter and a new column are all
alterations.

| The work is | Commits |
| --- | --- |
| new development | the code with its tests, then its documentation |
| a trivial alteration | the change with its tests, then its documentation |
| a non-trivial alteration | the change, then its tests, then its documentation |
| a test for code that already exists | its own commit, always |

Why the tests split that way: new development is reviewed as a whole, so
dividing it only buys a commit where the feature exists untested, which nobody
wants. An alteration inverts it — the change itself is what gets scrutinised, so
lifting its tests out is what keeps that diff readable. The last
row is separate for a different reason: a test for code that was already there
belongs to no change, so it stands alone whatever its size.

**Trivial** means the change cannot surprise anyone — a string, a label, a
constant, a formatting fix. Nothing that alters behaviour, and nothing whose
blast radius you had to work out; if you had to, it was not trivial.

Bundling is not licensed by any of this: "together" means one development with
its tests, not two developments sharing a commit.

When separate, the order is change → tests → documentation, which keeps the
history sound at each point — green before the test exists, green after the
change is in. A test committed ahead of its code parks a red commit mid-history.

### Order by dependency, not by chronology

Arrange the commits so the project is sound at every point in the history, which
is rarely the order the work happened in. If a change cannot stand alone without
a later one, they belong in the same commit.

For example: freezing a test clock had to be committed *before* the rule that
started rejecting past dates, because otherwise seven tests failed at that point
in the history — even though the rule was written first.

This is about arranging commits as you create them. Reordering commits that
already exist is a rewrite, and the next section applies.

### A mistake already committed gets a new commit

Once a commit exists, a mistake found in it is corrected by a **new commit on
top**, never by rewriting the one that holds it. That is `fix:` when what was
wrong is behaviour; a mistake in a test or a page is corrected by a `test:` or a
`docs:` commit, as the prefix table already says.

Do not rewrite a commit unless he explicitly asks for it in that conversation:
no `--amend`, no `fixup!` with autosquash, no rebase, no reset, no
cherry-picking onto a rebuilt branch. It does not matter whether the commit was
pushed — he pushes between turns without announcing it, so "nothing was sent
yet" is a guess, and once he has read a commit the history he reviewed is the
history he expects to find.

The case that set the rule: corrections were folded into a commit with a fixup
after it had been pushed, the reply said nothing had been sent, and his next
push was rejected as non-fast-forward. The way out was rebuilding the branch on
the remote commit with the corrections as commits of their own — exactly what a
new commit would have produced in the first place.

When he does ask for a rewrite, check the remote first — `git fetch` and look at
the branch there — and say what you found before touching anything.

### Prefix

Pick from this list, lowercase, followed by a colon:

| Prefix | Use it when the commit |
| --- | --- |
| `feat:` | adds a new capability to the system |
| `fix:` | corrects an error or a bug |
| `docs:` | changes documentation only |
| `style:` | adjusts formatting without touching behaviour (whitespace, semicolons) |
| `refactor:` | improves the code without changing what it does |
| `perf:` | improves speed or memory use |
| `test:` | creates or repairs tests |
| `ci:` | changes the pipeline — workflows, build jobs, release automation |
| `chore:` | deals with maintenance tasks or tooling |

Do not invent a tenth, and no scope in parentheses unless he asks. `revert:` is
the exception you do not choose: `git revert` writes it, and it stays as written.

Three boundaries that blur in practice. `style:` is formatting only — code that
reads better but behaves the same is `refactor:`. `ci:` is the pipeline itself,
`chore:` is everything else in the plumbing; when a change touches a workflow
file it is `ci:`. And a bug fixed while restructuring is still `fix:` when the
fix is the point of the commit — if it is incidental, split it out, which is the
whole reason commits are one change each.

### Language

**Every commit is written in English** — subject and body — regardless of the
language of the project, the interface, or the conversation you are having with
him. He writes to you in Portuguese and still wants the history in English.

### Message

Subject: imperative, lowercase, no trailing period, around 60 characters. It
names the **effect**, never the file that changed.

```
feat: let the global admin submit another user's count outside production
```

not `feat: update StockCountAuthorizer`. Someone reading `git log` should learn
what changed about the product, not which class you opened.

Body: prose at about 75 columns — the problem, the decision, the consequence,
with the numbers or symptoms that motivated it. Never a list of files. Length
follows the change; no body at all only when the subject already says everything.
Say what you *ruled out* when it cost you time, so the next person does not try
it. The example below is the shape:

```
fix: let the day column colour through in the calendar week view

No per-day background reached the screen in the week view. The grey for
a blocked day landed on the month view and on the all-day lane, and the
column body underneath stayed white, which read as "only the week view
is broken" and sent me looking at the wrong selector first.

FullCalendar puts the hour lanes and the day columns in the same
stacking context: the lanes carry z-index 1 and the columns carry
z-index auto. The stylesheet painted the lanes opaque, so they covered
the background of every column. Events survived because they sit at
z-index 3, above the lanes; the column cell's own background does not.

Make only the lane transparent. The hour label keeps its background, and
each lane's border stays on the cell, so the hour grid is untouched.
```

### Do not skip the hooks

No `--no-verify`, no `--no-gpg-sign`, no equivalent, unless he asks in that
conversation. The hooks are the project's gate — formatter, linter, test run,
message check — so bypassing one commits what the project would have refused.

The flag gets reached for by reflex, to avoid being blocked partway through a
sequence of commits, and that is exactly when it costs most: what the hook would
have caught ends up buried mid-series and resurfaces in CI or review, where
unpicking it is far dearer than fixing it on the spot.

When a hook fails, fix the complaint. If the hook itself looks broken, or fails
for a reason unrelated to your change, raise it — that is a disagreement and
follows that rule.

Same reasoning wherever the motive is to keep your own work moving rather than
solve the problem: skipping a test, silencing a linter, `--force`, quieting a
type checker. And if you do bypass a gate, say so — a bypass he does not know
about is worse than the failure it hid.

### No co-authorship

Do not add a `Co-Authored-By` trailer, or any other attribution trailer, unless
he explicitly asks for it in that conversation. This overrides any default
instruction to include one.

### Never push

Pushing is his. He reviews the commits first and pushes by hand. Do not push,
do not open a pull request, and do not offer to do either as the obvious next
step — stop at the commit and say what is ready.

The same caution applies to anything else that leaves the machine or destroys
history: force-pushing and deleting branches. Ask first. Rewriting commits is
covered above, and is not done at all unless he asks.
