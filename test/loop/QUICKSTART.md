<!-- generated-by: groundrules v1.6.1 -->
# Quickstart — your first loop, in 5 steps

The everyday rhythm with groundrules: **a fresh project → ask in plain words → set a goal (a failing
test) → let the loop reach it → check the result.** About 5 minutes.

> Want the deep version (build Conway's Game of Life and watch the loop *iterate*)? See
> [`TUTORIAL.md`](TUTORIAL.md). This page is just the everyday flow.

---

## 1. A blank project, bootstrapped

```bash
mkdir my-app && cd my-app && claude
# in Claude Code:
/groundrules:bootstrap        # answer the interview — and say YES to "loop scaffolding" (Call 2c)
```
You get the docs structure (`CLAUDE.md`, `docs/`, `PLAN.md`…) **and** a `loop/` folder — the autonomous
maker/verifier loop, dormant until you use it.

## 2. Ask for something — in the chat, in plain words

Just say what you want:

> **You:** *"Add a `to_roman(n)` function that converts 1–3999 to Roman numerals."*

Your generated `CLAUDE.md` **routes work by regime** — atomic, isolatable, testable work is steered
toward the loop — so the natural move here is to *set one up* rather than code it inline. (It's a
convention nudging you and Claude, not an automatic prompt.)

## 3. Set up the loop: a failing test first

A loop needs a finish line it **can't fake**. So you write the **acceptance test before the code** (you,
or ask Claude to):

> **You:** *"Write a failing test for `to_roman` — 4→IV, 9→IX, 58→LVIII, 1994→MCMXCIV — then
> `/groundrules:realize` this task."*

`/groundrules:realize` takes your **plan** (a pasted task, a `docs/prd/` PRD, or the tasks in `PLAN.md`),
checks the acceptance test is **red**, then writes the task into `loop/backlog.md`, *gated on that test*. (No test? It **refuses to loop** and offers to author one first — the test is the back
pressure, on purpose.)

**Commit the test before you launch** — it's the *frozen spec*, authored before the maker:

```bash
git add test_roman.py && git commit -m "test: add to_roman acceptance test (red)"
```
Why it matters: the verifier checks the maker didn't tamper with the test via `git diff` — on an
**untracked** file that check sees nothing, so committing it first is what makes the guard real. Set one
or two **`## Invariants`** in `CLAUDE.md` too (e.g. "the test suite stays green") — the verifier checks
them every iteration; left as placeholders, they guard nothing.

## 4. Launch the loop

Two engines — pick by how much the result matters ([ADR 0031](../../docs/decisions/0031-goal-interop-swappable-loop-executor.md)):

```bash
# Light & in-the-box — Claude loops on its own until the condition holds:
/goal "the to_roman tests pass"

# …or the full groundrules loop — independent verification, fresh context, parks real decisions:
bash loop/run-loop.sh --max 5
```
Either way, **groundrules already did the important part** — it turned your plain request into a
*verifiable goal*. The engine just runs toward it. (Rule of thumb: `/goal` for a quick, self-evident
goal; the full loop when you want the strong back pressure.)

## 5. Check the result

```bash
git log --oneline      # the loop's own commit(s)
# re-run the test → green. Done.
```
Hit a **real decision** the loop can't make on its own? It stops and writes `loop/blocked.md` for you to
triage — it never guesses.

---

**That's the loop, day to day:** *ask → set a red test → run → check.*

Go deeper: [`TUTORIAL.md`](TUTORIAL.md) (Game of Life, watch it iterate) ·
[`WALKTHROUGH.md`](WALKTHROUGH.md) (the validation reference + the deterministic runner test).
