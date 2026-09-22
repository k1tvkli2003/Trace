# Trace

Personal, local-first learning agent for long books. **Implementation underway; no learning pipeline shipped.**

## Targets
Android, Windows, Web/PWA. Flutter 3.44.0 stable / Dart 3.12.0 is current development baseline, not a release pin until CI and lockfiles are established. StudyHub-Web is read-only design/data vocabulary reference.

See [.hermes implementation plan](.hermes/plans/2026-09-22_223024-trace-learning-agent.md), [target matrix](tool/target-matrix.md), [decision log](docs/architecture/decision-log.md), and [work record](docs/codex/2026-09-22-trace-implementation/02-state.md).

No OCR, raw LLM HTML, client API secrets or direct AI-to-database writes. Model route belongs behind server gateway. No production deployment is configured.
