# Four principles for working well with an AI agent

### PRD · Pushback · Memory · Reversibility — and how to apply them in Claude Code

These four principles are what separates serious use of an AI agent from the "vibe-prompting" that spirals out of control. They are tool-independent, but this document shows how to put them into practice concretely in **Claude Code**.

The common thread: **a powerful agent amplifies your good intentions just as much as your imprecisions.** These principles serve to frame things up front, keep control during, and be able to roll back afterward.

---

## 1. PRD — Frame before building

### Why it's good

A **PRD** (*Product Requirements Document*, or simply a specification document) describes what you want **before** the agent starts producing. It's the equivalent of the architect's blueprint before pouring the foundations.

Without framing, an agent fills the gaps with its own assumptions. Thirty minutes later you discover it has built something coherent… but not what you wanted. The PRD attacks this problem at the root:

- It **forces explicitness**: problem to solve, success criteria, scope (what's *in* and *out* of scope), constraints, build plan.
- It **surfaces questions early**, when fixing them costs a sentence rather than a day of work.
- It serves as a **shared reference**: the agent can anchor to it at each step instead of drifting.
- It **documents the decision**: in six months, you know why things are the way they are.

The rule to remember: **"PRD first, always"** — nothing non-trivial gets built without a validated spec.

### How to use it in Claude Code

**Plan mode is the PRD built into Claude Code.** Press `Shift+Tab` to cycle through the permission modes (`default` → `acceptEdits` → `plan`), or type `/plan`. In plan mode, Claude **explores read-only** (it reads files, digs through the code) and **proposes a plan without modifying anything**. You validate, or you correct, *before* the slightest write.

For heavier projects, materialize the PRD in a versioned file:

```
docs/prd/my-feature.md
```

Then point Claude at it:

```
Read docs/prd/my-feature.md. Before writing a single line of code:
1. Ask me all the open questions.
2. Propose a step-by-step build plan.
3. Wait for my explicit validation before starting.
```

**Reusable PRD skeleton:**

```markdown
# PRD — [Name]
## Problem         What need? For whom?
## Success criteria    How will we know it succeeded? (measurable)
## Scope           In scope / Out of scope (explicit)
## Constraints     Technical, time, dependencies
## Build plan      Ordered steps, with validation checkpoints
## Risks           What can go wrong
```

> **Tip:** turn this skeleton into a custom command. A `.claude/commands/prd.md` file lets you type `/prd` to generate a PRD from a few answers.

---

## 2. Pushback — Make the agent contradict you

### Why it's good

By default, an AI assistant is compliant: it tends to do what it's asked, even when the request is shaky. That's dangerous, because you're not infallible — and the agent sometimes sees things you miss.

Explicitly asking for **pushback** turns the agent from a docile executor into a **critical collaborator**:

- It **challenges** when the plan seems off-strategy, technically wrong, or inconsistent with earlier decisions.
- It **flags the tradeoffs** you didn't see ("it works, but it'll cost you in performance / maintainability").
- It **asks the uncomfortable questions** instead of guessing.

A good collaborator who tells you "wait, are you sure?" saves you costly mistakes. That's exactly what we want from an agent.

### How to use it in Claude Code

Pushback is steered through **persistent instructions** in the `CLAUDE.md` memory file (see principle 3). Add a section like this:

```markdown
## Expected posture
- Challenge me when a plan seems off-strategy, technically
  incorrect, or inconsistent with an earlier decision.
- Flag the tradeoffs I may not have considered.
- If a request is ambiguous, ask questions BEFORE acting —
  don't guess.
- Don't be sycophantic: your role is to help me be right,
  not to agree with me.
```

Since these lines are loaded automatically at every session, the behavior becomes permanent, without having to ask again.

> **Note:** there is no dedicated "pushback mode" in Claude Code. The lever is these instructions in `CLAUDE.md` — that's sufficient and effective.

---

## 3. Memory — Document continuously

### Why it's good

An agent retains nothing from one session to the next. Worse: within a long session, its context window "bloats" and it starts to forget or confuse things. Without memory management, you keep re-explaining the same things, and the agent falls back into the same bad habits.

Good memory hygiene means:

- **Capitalizing**: project conventions, architecture decisions, style preferences — written once, always respected.
- **Reducing the cost of repetition**: you no longer have to re-contextualize at each start.
- **Guaranteeing consistency**: the agent applies the same rules today and three months from now.

The rule: **document aggressively**, from the start, and clean up regularly.

### How to use it in Claude Code

The heart of the system is the **`CLAUDE.md`** file, loaded automatically at the beginning of each session.

**Locations (loaded in this order):**

| File | Scope |
|---|---|
| `~/.claude/CLAUDE.md` | Global — all your projects |
| `./CLAUDE.md` | Project root — versionable in git, shared with the team |
| `./CLAUDE.local.md` | Personal to the project — to put in `.gitignore` |

Parent folders are loaded in full at launch (useful in a monorepo); subfolders load on demand when Claude reads files there.

**Useful commands:**

- `/init` — analyzes your repo and generates a starter `CLAUDE.md` (build, tests, detected conventions).
- `/memory` — lists the loaded memory files, lets you edit them and enable/disable automatic memory.

**Modular imports:** a `CLAUDE.md` can include others with the `@path/to/file` syntax (up to 4 levels), to keep memory well organized:

```markdown
# CLAUDE.md
@docs/conventions.md
@docs/architecture.md
```

**Best practice:** keep `CLAUDE.md` short and high-value. Put the stable conventions and structuring decisions there, not ephemeral details. Reread it periodically and prune — a memory that bloats with obsolete notes hurts as much as no memory at all.

---

## 4. Reversibility — Keep the ability to roll back

### Why it's good

An agent acting on your system can do damage: overwrite a file, run a destructive command, modify what it shouldn't have. The reversibility principle holds in one sentence:

> **Interrupting with a question always costs less than destroying something silently.**

Concretely, we want two guarantees: **ask before anything that's hard to undo**, and **be able to restore a previous state** if needed.

### How to use it in Claude Code

Claude Code offers several safety nets — stack them.

**a) Caution instruction in `CLAUDE.md`:**

```markdown
## Reversibility
- Confirm with me before any action that's hard to undo
  (deletion, migration, mass write, destructive command).
- When in doubt, stop and ask.
```

**b) Permissions (`allow` / `deny`) in `.claude/settings.json`:** define what's allowed, what requires confirmation, what's forbidden. Rules are evaluated in the order `deny` → `ask` → `allow`, first match wins:

```json
{
  "permissions": {
    "allow": ["Bash(npm run lint)", "Read(~/.zshrc)"],
    "deny": ["Bash(rm *)", "Read(./.env*)"]
  }
}
```

The `/permissions` command lets you manage these rules during a session.

**c) `PreToolUse` hooks:** a hook that triggers *before* a tool executes can **block** a dangerous call (by exiting with code 2), and this **takes precedence over `allow` rules**. Ideal for robustly forbidding risky commands (`rm -rf`, force push, etc.).

**d) Checkpoints / rewind:** Claude Code takes a snapshot of your files **before each edit** (independent of git, local to the session). To roll back:

- `/rewind` or **`Esc` twice** — restores the code, the conversation, or both to an earlier point.
- **`Esc` once** — interrupts Claude immediately, without waiting for the turn to finish.

> ⚠️ Checkpoints do **not** track changes made via the Bash tool (e.g. files modified by a script). The complementary reflex remains: **work in a git repo** and commit often. That's your ultimate net.

---

## Putting the four together: a starter `CLAUDE.md`

Here's a minimal file that combines pushback, memory, and reversibility (the PRD itself plays out mostly through plan mode and your specs):

```markdown
# CLAUDE.md

## Context
[Describe the project, the stack, the goal in 2-3 lines.]

## Working method
- PRD first: before any non-trivial feature, propose a plan
  and wait for my explicit validation. Use plan mode.
- Ask all open questions BEFORE coding.

## Posture
- Challenge me if a plan seems off-strategy, wrong, or inconsistent
  with a past decision. Flag the tradeoffs not considered.
- Don't be sycophantic.

## Memory
- Document structuring decisions here as you go.
- Respect the conventions below: [links @docs/...]

## Reversibility
- Confirm before any action that's hard to undo.
- When in doubt, stop and ask.
```

---

## Cheat sheet

| Principle | Why | Claude Code lever |
|---|---|---|
| **PRD** | Build the right thing, not a surprise | Plan mode (`Shift+Tab` / `/plan`), validated spec file |
| **Pushback** | A critical collaborator avoids mistakes | Instructions in `CLAUDE.md` |
| **Memory** | Consistency + not repeating yourself | `CLAUDE.md`, `/init`, `/memory`, `@` imports |
| **Reversibility** | Undoing beats destroying | Permissions, `PreToolUse` hooks, `/rewind` / `Esc`, git |

---

## What the research says

These four principles aren't mere tricks: each is backed by academic research or by recognized engineering practices. Here's a synthesis of the evidence, with its nuances.

### PRD — confirmed (it has become a named methodology)

"PRD first" corresponds to **spec-driven development (SDD)**, a now-established movement: you write a detailed specification before the code, and the spec becomes the "source of truth." Practitioners report that this upfront effort "drastically reduces misunderstandings with the agent afterward" and avoids the inconsistencies of *vibe coding*. There are even dedicated courses and research publications on the subject.

> **Nuance:** it's not all or nothing. Three levels of rigor are distinguished (*spec-first*, *spec-anchored*, *spec-as-source*) — the effort should be proportional to the stakes of the task.

### Pushback — confirmed (a response to a measured bias: *sycophancy*)

Models' compliance has a name in the literature: **sycophancy**. It is measured and significant: sycophantic behavior observed in ~58% of cases on medical and mathematical questions; models switching from a correct to an incorrect answer in ~15% of cases after a simple user disagreement; adherence to false beliefs at ~64% on average (up to 95% depending on the model). The identified cause is **RLHF**, where humans rate agreeable answers more highly than accurate ones. A study published in *Science* even shows that sycophantic AI increases user dependence.

> **Nuance:** asking for pushback is a *partial mitigation*, not a guarantee — the bias is structural.

### Memory — confirmed (a precise technical foundation)

Research validates both the need to capitalize and the risk of "bloating." Two documented phenomena: **context rot** (a study testing 18 models, including Claude, GPT-4.1, and Gemini, shows that *all* degrade as the input gets longer — some dropping from 95% to 60% accuracy) and **"lost in the middle"** (information in the middle of a long prompt is recalled less well than at the beginning or end). Hence the emergence of *context engineering* as a discipline in its own right.

> **Practical consequence:** keeping `CLAUDE.md` short and pruning it regularly isn't a matter of comfort, it's what preserves performance.

### Reversibility — confirmed (with a major nuance)

*Human-in-the-loop* before any irreversible action is a standard recommendation (OWASP, documented field reports on agent "horror stories"). Best practices describe exactly the layered approach: action classification (auto-approve reads, require confirmation for deletions, deployments, payments) and fine-grained per-tool permissions.

> **Key nuance:** several sources insist — the guardrails must live **at the infrastructure level, not the prompt level**. An instruction in `CLAUDE.md` is weaker than a permission rule or a hook, and the "lies-in-the-loop" attack shows you can even fool the human confirmation. **Hence the rule: stack permissions + hooks + git, and never rely on instructions alone.**

### The common thread across all the sources

> **Architecture-based guardrails (specs, permissions, hooks, infrastructure) are more reliable than those based on the prompt alone.**

### References

- [Spec-driven development — Wikipedia](https://en.wikipedia.org/wiki/Spec-driven_development)
- [Spec-Driven Development with Coding Agents — DeepLearning.AI](https://www.deeplearning.ai/courses/spec-driven-development-with-coding-agents)
- [How to write a good spec for AI agents — Addy Osmani](https://addyosmani.com/blog/good-spec/)
- [Sycophancy (artificial intelligence) — Wikipedia](https://en.wikipedia.org/wiki/Sycophancy_(artificial_intelligence))
- [Sycophantic AI decreases prosocial intentions and promotes dependence — Science](https://www.science.org/doi/10.1126/science.aec8352)
- [When helpfulness backfires: LLMs and sycophantic behavior — npj Digital Medicine (Nature)](https://www.nature.com/articles/s41746-025-02008-z)
- [Context Engineering for Agents — LangChain](https://www.langchain.com/blog/context-engineering-for-agents)
- [Active Context Compression: Autonomous Memory Management in LLM Agents — arXiv](https://arxiv.org/abs/2601.07190)
- [AI Agent Security Cheat Sheet — OWASP](https://cheatsheetseries.owasp.org/cheatsheets/AI_Agent_Security_Cheat_Sheet.html)
- [AI Coding Agent Horror Stories: Security Risks — Docker](https://www.docker.com/blog/ai-coding-agent-horror-stories-security-risks/)
- ['Lies-in-the-Loop' Attack Defeats AI Coding Agents — Dark Reading](https://www.darkreading.com/application-security/-lies-in-the-loop-attack-ai-coding-agents)

---

## Going further

- **Start small.** Adopt PRD + memory on a real project first before aiming for complex workflows.
- **Version everything.** Git isn't optional when an agent writes in your repo — it's the last-resort safety net.
- **Prune the memory.** Reread `CLAUDE.md` regularly; a memory that bloats with stale notes degrades results.
- **Official documentation:** [code.claude.com/docs](https://code.claude.com/docs) — see the *permission-modes*, *memory*, *permissions*, *checkpointing*, *hooks-guide* pages.
