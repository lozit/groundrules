# Write Loops, Not Prompts — Resource pack and synthesis

> *"I don't prompt Claude anymore. I have loops that are running. They're the ones prompting Claude and figuring out what to do. My job is to write loops."*
> — **Boris Cherny**, creator of Claude Code (Anthropic), Sequoia conference, June 2, 2026 ([original quote on X](https://x.com/rohanpaul_ai/status/2063289804708835412), [conference video](https://www.youtube.com/watch?v=SlGRN8jh2RI))

This pack gathers 5 articles and 5 YouTube videos (transcripts downloaded into the `transcripts/` folder) to understand what Boris Cherny means by "write loops, not prompts" — and how to set it up concretely.

---

## 1. The idea in one sentence

The engineer's unit of work has evolved: **from typing at the keyboard → to the prompt → to the loop.** Instead of being *you* typing every prompt, you build **the system that prompts on your behalf**: it decides what to do, launches the agents, checks the results — without you in the typing loop.

Cherny describes his own journey in **three stages**:

| Stage | What you do | The AI's role |
|-------|-------------------|--------------|
| **1. Code** | You write the code | Autocomplete: a faster keyboard |
| **2. Prompts** | You run 5–10 sessions in parallel, you type each prompt | The AI writes the code, but you're the human engine at every step |
| **3. Loops** | You design the loop once | The loop reads your GitHub/Slack/Twitter, decides what to do, and launches the agents |

Most people are stuck at **stage 2**, believing the ceiling is writing ever longer and cleverer prompts. Stage 3 is the floor above.

**Important — prompt engineering is not dead.** Cherny didn't get rid of prompts: he wrote several prompt architectures, then automated *who calls them*. Prompts are now *embedded in automated loops* instead of being triggered manually.

---

## 2. Two meanings of the word "loop" — don't confuse them

1. **The loop INSIDE the model** (classic agentic loop): the agent calls a tool, reads the result, calls another, until done. A single session, a single context that grows. That's what the SDK already does.
2. **The loop AROUND the agent** (the topic here): a program launches the agent, lets it do a bit of work, then **restarts it from scratch**. Each iteration = a fresh context. The memory of what was done lives **on disk, not in the model.**

It's this second loop that people call "writing loops."

---

## 3. Why start from a blank context at every iteration?

Because of **context rot**: models don't use a long context uniformly. Reliability degrades as the window fills up, even on easy tasks. Cited example: GPT-4o succeeds 99% of the time with a short context, but drops to 70% at 32,000 tokens on the same task. **A short, fresh context at every loop is therefore not a tradeoff: it's the goal.** (Source study: *[Context Rot](https://research.trychroma.com/context-rot)*, Chroma Research, July 2025 — 18 models tested, all degrade as the input grows.)

So where does continuity come from if every run starts from scratch? **From the file system**:
- a `specs/` folder = what to build (written once, survives every restart)
- an implementation plan = the task list, checked off run after run
- the Git history = what has already been done, commit by commit
- the tests = the definition of "done"

**"The model forgets, the repo remembers."**

---

## 4. The origin: Geoffrey Huntley's "Ralph" loop

The technique is about a year old. Developer **Geoffrey Huntley** named it "Ralph" (after the Simpsons character, because "it's wonderfully dumb"), in his founding post *[Ralph Wiggum as a "software engineer"](https://ghuntley.com/ralph/)* (July 2025), extended by *[everything is a ralph loop](https://ghuntley.com/loop/)*. In one line:

```bash
while true; do cat PROMPT.md | claude; done
```

A fixed prompt re-injected into Claude over and over until the work is done. **No framework, no orchestration library: the orchestrator is the shell.**

In practice, you wrap it in a small funnel: **3 phases, 2 prompts, 1 loop.**
1. *Requirements* phase → turns intent into spec files.
2. *Planning* phase → turns specs into a prioritized task list.
3. **Build loop** → takes a task, implements it, runs the tests, commits. This is the only part that repeats.

**Proof of existence:** Huntley ran this loop for ~3 months and built a functional programming language ("cursed") with a compiler producing native binaries via LLVM on Mac/Linux/Windows. His words: *"The highest-IQ thing might be the lowest-IQ thing: running an agent in a loop."* (Full account: *[i ran Claude in a loop for three months, and it created a genz programming language called cursed](https://ghuntley.com/cursed/)*.)

---

## 5. How to set it up concretely

### The ready-to-use Claude Code commands

- **`/loop`** — runs a task on a schedule, in natural language. E.g.: `/loop 30 minutes: run the build and the tests, let me know if it breaks.` Ideal for watching CI, babysitting PRs, producing a daily summary. Loops run for **3 days max** then stop (no runaway process burning through your budget).
- **`/goal`** — more aggressive: continues over several turns until a condition *you* wrote is true. E.g.: `/goal all tests in folder X pass and the lint is clean.` After each turn, **a separate small model** judges whether it's done — the agent that wrote the code doesn't grade its own paper.

> `/loop` controls the **pace**. `/goal` controls the **finish line**. Real loop engineering combines the two.

Anthropic also provides an **official plugin** that uses a *stop hook* to catch the agent trying to exit and re-inject the prompt until a "done" keyword or an iteration ceiling.

### The 5 building blocks + 1 brain (Addy Osmani's framework)

1. **Automations / scheduler** — the heartbeat. Without it, you've just run something once.
2. **Git work trees** — each parallel agent has its own isolated copy of the code so it doesn't overwrite the others' files.
3. **Skills** — your conventions, build commands, and lessons learned in a file, so the agent starts with the project's memory instead of guessing.
4. **Connectors (MCP)** — to touch the real world: read the issue tracker, open PRs, post to Slack.
5. **Sub-agents** — the most important piece (see rule 1 below).
6. **The brain = external memory** — a simple markdown file tracking what's done / to do. On disk, in the repo, **not in the conversation context.**

### The 3 golden rules

1. **Separate the writer from the verifier.** The agent that writes the code and the one that checks it must be two different agents (ideally two different models). A model grading its own work is absurdly lenient. This is exactly what `/goal` does under the hood: you separate the player and the referee. This is the **maker / verifier** pattern, an "LLM-as-a-judge" dynamic that catches hallucinations.
2. **The stop condition must be verifiable, not based on a feeling.** "Improve the code" = a garbage loop burning tokens forever. "All tests pass, zero lint errors, clean types" = a real loop. Never let the agent declare "I'm done" of its own accord — let the tests and the type-checkers judge. This is what Huntley calls **back pressure**, and his slogan: *"sit on the loop, not in it"* (sit ON the loop, not IN it).
3. **State lives in the repo, not in the chat.** Each iteration starts a fresh conversation; the agent re-reads the files and the Git history to know where the previous run left off.

### A loop to steal: the daily on-call engineer

Every morning, an automation triggers and calls a triage *skill*: it reads the previous day's CI failures, the open issues, and the recent commits, and writes its findings to a state file. For each problem to fix, it opens an isolated work tree and sends **agent A** to write the fix. **Agent B** reviews this fix against the project's skills and the existing tests. If it passes review, the loop opens the PR and updates the ticket. If it gets stuck, it lands in your inbox. The state file records the day's progress, so tomorrow's run picks up exactly where today's left off. **You designed it once — you prompted none of these steps.**

### To get started without getting burned

Start where it's forgiving: a **new repo** (greenfield), a **spec you actually wrote**, **tests that make sense**, and a **hard iteration ceiling**. Build the back pressure first, then let the loop go.

---

## 6. The limits and the pitfalls (the honest part)

- **Running ≠ being done.** Huntley's "cursed" language compiles, but its standard library is "wild and incomplete." It's a proof of existence, not a guarantee.
- **A greenfield technique.** Huntley: *"there's no way I'd ever run this on an existing codebase."* A loop can leave you with a broken repo that no longer compiles; sometimes the right move in the morning is `git reset --hard`.
- **The cost runs off.** A bare loop has no stop condition → the budget blows up. The **iteration ceiling is the real safety mechanism**, not an option.
- **Open loop vs closed loop.** The *open loop* ("figure it out yourself") discovers unexpected things but burns enormous amounts of tokens. The *closed loop* (bounded goal, evaluation at each step) keeps the budget under control — preferred.
- **Comprehension debt.** Shipping code you've never read widens a gap between what exists and what you understand. Accepting "passing" outputs without checking the logic is "cognitive surrender." **The last safeguard remains the human review of the final, verified merge.**
- **The most dangerous posture is the most comfortable one.** Two people build the same loop: one to go faster on work they've mastered, the other to avoid understanding the work. The loop can't tell the difference — your quality can. Osmani's words: **"Build the loop, but stay the engineer."**

---

## 7. The bigger picture

Cherny places this in the long history: just as the printing press in the 15th century took literacy from ~10% to ~70% of the population, AI is **democratizing software writing** — "much faster than 50 years." The best author of an accounting software may no longer be an engineer but a good accountant, because coding is becoming the easy part and knowing the domain is the hardest.

Anthropic internally: no more code written by hand in the company, SQL is generated, and employees' Claudes communicate with each other via Slack while they run in loops.

**Conclusion:** the most valuable engineers of the next 12–18 months won't be those who write the cleverest prompts, but those who design the most **reliable, observable, and economical** loops around increasingly powerful models. The question changes: no longer *"how do I write this prompt?"* but *"how do I design this loop?"*

---

## Resources

### 📺 5 YouTube videos (transcripts in `transcripts/`)

1. **[Anthropic's Boris Cherny: Why Coding Is Solved, and What Comes Next](https://www.youtube.com/watch?v=SlGRN8jh2RI)** — Sequoia Capital (~24 min). *The source conference.* Cherny describes his real setup (working from his phone, 5–10 sessions, hundreds of agents, dozens of loops) and his predictions. → `transcripts/01_...`
2. **[Write Loops, Not Prompts: the loop around the AI agent, explained](https://www.youtube.com/watch?v=3NV0Verh3nE)** — Code Presenter (~7.5 min). *The best technical explanation*: the two meanings of "loop," context rot, the Ralph loop, back pressure. → `transcripts/02_...`
3. **[The Creator of Claude Code Doesn't Write Prompts Anymore. He Writes Loops.](https://www.youtube.com/watch?v=w285kJY3Xws)** — ai_root_cause (~9 min). *Step-by-step tutorial*: `/loop` and `/goal` commands, the 5 blocks + brain, the 3 golden rules, a stealable template. → `transcripts/03_...`
4. **[The New AI Prompting Method Everyone Is Talking About: Loops](https://www.youtube.com/watch?v=Ry3YyG22EUc)** — Upgraded (~19 min). *A concrete demo accessible to non-technical viewers*: open vs closed loop, a complete e-commerce example, 4 everyday scenarios. → `transcripts/04_...`
5. **[The Next Big AI Skill: Loop Engineering](https://www.youtube.com/watch?v=Mah1J7_74No)** — Evolving Algorithm (~7.5 min). *The most conceptual*: the ReAct pattern (Reason/Act/Observe), maker/verifier, verifiable autonomy, comprehension debt. → `transcripts/05_...`

**Bonus** (not transcribed, to go further): [Boris Cherny — Acquired Unplugged / WorkOS](https://www.youtube.com/watch?v=RkQQ7WEor7w) · [Loop Engineering, This Week in AI — Mastra](https://www.youtube.com/watch?v=yUtcNZEW-2A)

### 📄 5 articles

1. **[Loop Engineering — Addy Osmani](https://addyosmani.com/blog/loop-engineering/)** — The article that gave the paradigm its official name and that formalizes the framework of the 5 blocks + memory. **Read this first.**
2. **[Stop Prompting Your Agent. Start Writing Loops. — Oscar Gallego Ruiz (Medium)](https://medium.com/@garbarok/stop-prompting-your-agent-start-writing-loops-73608223f075)** — A good practical entry point on the shift from prompt to loop.
3. **[I Don't Prompt Claude Anymore. I Write Loops That Prompt Claude. — James Fahey (Medium)](https://medium.com/@fahey_james/i-dont-prompt-claude-anymore-i-write-loops-that-prompt-claude-57e48a4f28d7)** — Clarifies the misunderstanding: Cherny didn't eliminate prompts, he automated *who calls them*.
4. **[Claude Code's Creators Explain Agent Loops & How They Code — The Neuron](https://www.theneuron.ai/explainer-articles/claude-code-creators-boris-cherny-and-cat-wu-explain-how-to-use-agent-loops/)** — A mainstream explanation, with Cat Wu's (Claude Code) perspective.
5. **[Anthropic's Coding Chief Doesn't Write Prompts Anymore. He Writes Loops. — The Latency Gambler (Medium)](https://medium.com/@kanishks772/anthropics-coding-chief-doesn-t-write-prompts-anymore-he-writes-loops-86db2e05bb02)** — Puts it in perspective with Anthropic's figures (>80% of production code generated by Claude, etc.).

**Bonus**: [Designing Loops — A Practitioner's Short Field Guide](https://interestingengineering.substack.com/p/designing-loops-a-practitioners-short) · [I Write Loops, Not Prompts — Dragos Roua](https://dragosroua.com/i-stopped-prompting-my-agents-i-write-agentic-loops-instead-heres-why/)

---

## Primary sources cited across these resources

The resources above all rely on the same small core of original sources. Here they are directly, to trace back to the source.

### The statements that started the debate

- **Boris Cherny**, original quote relayed on X: [x.com/rohanpaul_ai/status/2063289804708835412](https://x.com/rohanpaul_ai/status/2063289804708835412) — pulled from his Sequoia conference ([video](https://www.youtube.com/watch?v=SlGRN8jh2RI)).
- **Peter Steinberger** (creator of OpenClaw, ex-OpenAI): *"You shouldn't be prompting coding agents anymore. You should be designing loops that prompt your agents."* → [x.com/steipete/status/2063697162748260627](https://x.com/steipete/status/2063697162748260627). He's the one who establishes the list of 5 primitives picked up by Osmani.
- **Wes Winder**, a warning about token costs cited by Osmani: [x.com/weswinder/status/2063700289710964906](https://x.com/weswinder/status/2063700289710964906).

### The original technique — Geoffrey Huntley ("Ralph")

- *[Ralph Wiggum as a "software engineer"](https://ghuntley.com/ralph/)* — the founding post (July 2025).
- *[everything is a ralph loop](https://ghuntley.com/loop/)* — "one task per loop, software is clay on the potter's wheel."
- *[i ran Claude in a loop for three months… called cursed](https://ghuntley.com/cursed/)* — the proof of existence ("cursed" language).
- *[Software development now costs less than the wage of a minimum wage worker](https://ghuntley.com/real/)* — Huntley's economic perspective.
- Pedagogical takes on the technique: [A Brief History of Ralph — HumanLayer](https://www.humanlayer.dev/blog/brief-history-of-ralph) · [Ship Features in Your Sleep with Ralph Loops — Geocodio](https://www.geocod.io/code-and-coordinates/2026-01-27-ralph-loops) · [Mastering Ralph loops — LinearB](https://linearb.io/blog/ralph-loop-agentic-engineering-geoffrey-huntley).

### The technical foundation — "context rot"

- *[Context Rot: How Increasing Input Tokens Impacts LLM Performance](https://research.trychroma.com/context-rot)* — Chroma Research, July 2025. The study (18 models: GPT-4.1, Claude 4, Gemini 2.5, Qwen3…) that justifies starting from a blank context at every iteration.

### The loop's building blocks, in the product docs

- Addy Osmani, *[Loop Engineering](https://addyosmani.com/blog/loop-engineering/)* — and his related posts cited within: [Agent Harness Engineering](https://addyosmani.com/blog/agent-harness-engineering/), [The Factory Model](https://addyosmani.com/blog/factory-model/), [Long-Running Agents](https://addyosmani.com/blog/long-running-agents/), [Agent Skills](https://addyosmani.com/blog/agent-skills/), [The Orchestration Tax](https://addyosmani.com/blog/orchestration-tax/), [The Intent Debt](https://addyosmani.com/blog/intent-debt/), [The Code Agent Orchestra](https://addyosmani.com/blog/code-agent-orchestra/), [Adversarial Code Review](https://addyosmani.com/blog/adversarial-code-review/), [Code Review in the Age of AI](https://addyosmani.com/blog/code-review-ai/), [Comprehension Debt](https://addyosmani.com/blog/comprehension-debt/), [Cognitive Surrender](https://addyosmani.com/blog/cognitive-surrender/).
- OpenAI Codex documentation referenced by Osmani: [Automations](https://developers.openai.com/codex/app/automations) · [Skills](https://developers.openai.com/codex/skills) · [Subagents](https://developers.openai.com/codex/subagents).

> *Note: the X/Twitter links and product documentation pages may change or require a login. The blog posts (ghuntley.com, addyosmani.com) and the Chroma study are the most stable references.*
