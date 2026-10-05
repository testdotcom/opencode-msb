---
name: grilling
description: Grill the user about a plan, decision, or idea. Invoke when the end user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

# SKILL: Grilling

Interview the user in multiple steps until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round using the `question` tool, then wait for the user's answers before the next round.

## Asking a round with the `question` tool

Always use the `question` tool to put decisions to the user. Never ask them as plain prose in your reply. Make **one** `question` call per round, with one entry in `questions` for each frontier question (the tool accepts several at once and shows them together).

Each entry has:

- `header`: a short title for the question (30 characters max).
- `question`: the full question text. Include whatever context the user needs to decide, which may be multiple sentences.
- `options`: the plausible answers, each with a short `label` (1-5 words) and a `description` explaining the choice and its trade-offs.
- `multiple`: `true` only if the user may legitimately pick more than one option.

Your recommended answer goes **first** in `options`, with `(Recommended)` appended to its label. Do not add a catch-all "Other" option: the tool lets the user type a custom answer automatically.

For open-ended questions with no sensible fixed choices (a name, a number, a free-form constraint), still use the tool, offering your best-guess answers as options and relying on the custom-answer input for anything else.

Example round:

```json
{
  "questions": [
    {
      "header": "Auth strategy",
      "question": "How should users authenticate? This decides whether we need a session store and shapes the API surface.",
      "options": [
        { "label": "JWT (Recommended)", "description": "Stateless, no session store; harder to revoke tokens." },
        { "label": "Server sessions", "description": "Easy revocation; needs shared session storage." }
      ],
      "multiple": false
    },
    {
      "header": "Offline support",
      "question": "Does the app need to work offline?",
      "options": [
        { "label": "No (Recommended)", "description": "Simplest; assume connectivity." },
        { "label": "Read-only offline", "description": "Cache data for viewing; no sync conflicts." }
      ]
    }
  ]
}
```

## Working the tree

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

If the user's answer is a custom one, or reveals something unexpected, treat it as new information: update the tree before choosing the next round.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them with the `question` tool and wait.

## Finishing

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Summarise the decisions reached, then use the `question` tool one last time to ask the user to confirm you have reached a shared understanding (e.g. "Confirm" / "Not yet, keep grilling"). Do not act on the outcome until they confirm.
