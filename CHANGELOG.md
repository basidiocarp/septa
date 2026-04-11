# Changelog

All notable changes to Septa are documented in this file.

## [Unreleased]

## [0.1.1] - 2026-04-10

### Added

- **Usage event contract**: Septa now defines `usage-event-v1` plus a matching
  fixture so normalized usage and cost capture can stabilize before summary and
  UI layers diverge.

### Changed

- **Integration guidance**: the contract inventory and integration patterns now
  describe the `cortina -> mycelium -> cap` usage flow alongside the existing
  cross-tool identity boundaries.
- **Stipe doctor schema**: the `stipe-doctor-v1` contract now includes
  runtime-policy reporting fields for remembered decisions, precedence, and
  active install profile state.

## [0.1.0] - 2026-04-10

### Added

- **Cortina lifecycle contract**: Septa now defines the
  `cortina-lifecycle-event-v1` schema and fixture for normalized lifecycle
  capture across hosts and downstream consumers.

### Changed

- **Contract inventory**: the maintainer docs and integration guidance now
  describe Cortina's normalized lifecycle contract alongside the existing
  cross-tool payload families.
