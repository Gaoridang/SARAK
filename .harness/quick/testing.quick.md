# Testing Quick Guide

- Add tests for ViewModel public methods, repository logic, and services.
- Use deterministic fixtures; avoid network in unit tests.
- Cover success path + failure path + edge case.
- For async APIs, assert state transitions and error mapping.

Open full `.harness/testing.md` only when creating new test helpers/patterns or integration-style harness flows.
