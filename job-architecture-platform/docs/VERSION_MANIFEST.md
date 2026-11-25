# Job Architecture Platform Version Manifest

| Component | Baseline | Synchronization rule |
|---|---|---|
| Platform | V6 browser prototype | Deployed features and data schema are authoritative only after release verification |
| Methodology | V6-aligned | Must follow docs/CORE_DESIGN_PRINCIPLES.md |
| Training | V6-aligned | Examples, workflow and screenshots must match the deployed Platform release |
| Consulting projects | Project-specific, mapped to V6 | Client-approved source IPE data and decisions remain immutable unless formally approved |

## Engineering foundation update — 2026-11-25

- Added production architecture and completion gates: docs/PRODUCTION_ARCHITECTURE_AND_COMPLETION_PLAN.md.
- Added release/security test matrix: docs/RELEASE_TEST_MATRIX.md.
- Added draft PostgreSQL tenant and row-level security migration: supabase/migrations/0001_multi_tenant_foundation.sql.
- Added scenario/reporting model and workflow guard migration: supabase/migrations/0002_scenarios_workflow_guards.sql.
- Updated README with implementation status and limitations.

**Code commit:** 70e7ebc845c462d9562d1c331f5b2e5feb4f385c (README integration; subsequent migration commits are in main history).

## Deployment and release status

- Existing browser prototype remains the active reference; no production alias was changed by this engineering update.
- Database migrations are source artifacts only. They have not been applied to a provisioned database and have not passed live RLS/security tests.
- Authentication, role enforcement, tenant isolation, server-side audit, approval workflow and backup/restore remain incomplete.
- No paid infrastructure, production credentials, custom domain or real customer data has been provisioned.

Every release must update this manifest with release ID, effective date, code commit, deployment URL/status, changes, affected documents and migration notes. A document must not claim a feature is available until it is verified in the deployed release.

**Current baseline:** V6 prototype with a committed production architecture and database foundation draft. Not production SaaS. See docs/CORE_DESIGN_PRINCIPLES.md for acceptance criteria.
