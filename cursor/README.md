# Cursor run data

This folder holds the Cursor cloud-agent record for the uniqueness-lemma formalization.

- Agent: [bc-0287fe9d-bd12-5612-a650-fb13f5f1b0ec](https://cursor.com/agents/bc-0287fe9d-bd12-5612-a650-fb13f5f1b0ec)
- Title: Uniqueness lemma, not a measurement
- Source snapshot: `7b7447be237146a6be1dfac4ccca08a364a1d0a0` (uniqueness-lemma branch of the private measure-average project)
- Formal check reported by the agent: `cd lean && lake build` exited 0, with no `sorry`. `#print axioms` on the public theorems reported `propext`, `Classical.choice`, and `Quot.sound`.

## Files

- [`metadata.json`](metadata.json) — agent id, timestamps, and source SHA
- [`run-report.md`](run-report.md) — what was proved and what was not
- [`messages.md`](messages.md) — the user prompts and assistant progress notes from the run
- [`transcript-compact.jsonl`](transcript-compact.jsonl) — compact event log (roles, text, tool names)
- [`agent-transcript.jsonl`](agent-transcript.jsonl) — full Cursor agent transcript of this run

The transcript is a working log of the formalization. It is not itself a proof; the proof is `lean/PeriodicRawSpectrum.lean`.
