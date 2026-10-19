---
name: review-checklist
description: Reviews a diff for correctness, quality, security and privacy before merge. Use at the Review stage or when asked to review AI-written code.
---

# Review checklist

Answer each item with evidence (file + line), not "looks fine".

## Correctness and quality
- [ ] Runs, and solves the stated spec scenarios (each scenario has a test or manual check)
- [ ] All imports, packages, and APIs are real and match the lockfile versions
- [ ] Follows existing conventions; does not duplicate an existing utility
- [ ] Small functions, single responsibility, no magic numbers
- [ ] Tests added/updated; regression test for every bug fix; no weakened tests

## Security and privacy
- [ ] No SQL built by string concatenation; inputs validated and size-limited
- [ ] No secrets in diff or history
- [ ] No sensitive user data in logs, analytics, crash reports, or uploads
- [ ] Permissions are minimal and justified
- [ ] New dependencies are real, maintained, and necessary

## Report
State: what changed, what was run (exact commands + results), what was NOT verified, risks.
