# Enterprise Job Architecture Platform — Production Completion Blueprint

Document: EJA-ARCH-001  
Baseline inspected: V6 browser prototype (2026-11-25)

## 1. Verified current state

The V6 application is a single-page HTML application. It includes the job architecture workflow, browser-local company workspaces, CSV/JSON import/export, Excel export and PowerPoint summary export. The repository README and core design standard explicitly state that data remains in localStorage and is not synchronized across users or devices. It does not yet provide server-side tenant isolation, authentication, role-based permissions, cloud database, server-side audit or approval workflow.

Code inspection found release-consistency items: the document title identifies V6, while the footer and storage keys still contain V5.0 naming; language switching translates a limited set of visible labels rather than providing complete bilingual content; and the source contains more than one importDataFile declaration, so the effective handler must be tested rather than inferred from the first implementation.

## 2. Target architecture

- Web client: modular application with an explicit API boundary; no privileged service credentials in browser code.
- Identity: managed authentication with verified email, MFA policy for privileged roles, session expiry and invitation lifecycle.
- Tenant model: every business record carries tenant_id; tenant membership and role are checked on every server request and by database row-level security.
- Database: PostgreSQL with foreign keys, constraints, migration history, indexes, backups and point-in-time recovery where available.
- API/server functions: validate schema, identity, tenant membership, role, business rules and approval state; write audit events in the same transaction.
- File storage: private tenant-scoped buckets, signed short-lived URLs, file type/size checks, malware scanning where supported, retention policy and file hashes.
- Exports: server-generated XLSX/PPTX where appropriate; record tenant, scenario, version, export time and user; prevent cross-tenant export.
- Observability: structured logs with correlation IDs; never log source HR data, credentials, tokens or customer names unnecessarily.

## 3. Role model

| Role | Read | Edit master data | Submit evaluation | Approve/publish | Manage users | Audit |
|---|---:|---:|---:|---:|---:|---:|
| Tenant Admin | Yes | Yes | Yes | Delegated | Yes | Yes |
| Architecture Owner | Yes | Yes | Yes | Yes | No | Yes |
| HR Editor | Yes | Yes | Yes | No | No | No |
| Evaluator | Yes | Limited | Yes | No | No | No |
| Approver | Yes | No | No | Yes | No | No |
| Viewer | Yes | No | No | No | No | No |
| Auditor | Yes | No | No | No | No | Yes |

Role combinations and separation-of-duties rules must be configurable by tenant. A user must never gain access merely by changing a tenant ID in a URL or request body.

## 4. Core domain model

Tenant → organization units → positions → job profiles. Evaluation records preserve the authorized source result and provenance independently from internal grade policy. Workflow requests capture proposed changes and decisions. Audit events record actor, tenant, entity, event type, timestamp and before/after hashes. Scenario data must be versioned separately from the approved baseline.

The initial SQL migration in supabase/migrations/0001_multi_tenant_foundation.sql provides a reviewable starting schema and RLS policies. It is not production-ready by itself; migration hardening and the test plan are mandatory.

## 5. Non-negotiable methodology controls

1. Mercer IPE scores are stored and displayed as supplied by the authorized source; never calculate, reverse-engineer, alter or label estimates as official IPE.
2. Internal Grade is a separate organization policy outcome; it must not overwrite IPE source values.
3. Career Track, Career Level, Job Family, Sub-family and Job Profile recommendations remain provisional until approved against job content and scope.
4. Keep Job, Position and Person as distinct entities.
5. Preserve source files, source hashes, evaluation date, evaluator/reference, version and approval status when available.
6. Scenario design must not overwrite the approved organization baseline.
7. Every publish action requires an explicit approval record and effective date.

## 6. Delivery sequence and exit criteria

### Gate 0 — Source and release control
- Establish a reproducible build from the Git repository.
- Align application title, visible version, footer, storage schema and release manifest.
- Create automated smoke tests for all current modules and exports.
- Keep the current production alias unchanged until a candidate passes.

### Gate 1 — Identity and tenant security
- Configure a dedicated authentication/database project.
- Implement invitations, tenant membership and role checks.
- Apply migrations using a privileged deployment process.
- Complete positive and negative cross-tenant RLS tests.
- Confirm users cannot read, update, delete or export another tenant's records.

### Gate 2 — Data and migration
- Define canonical IDs, schema validation and import staging.
- Build CSV/XLSX preview, validation, error report and atomic commit.
- Preserve source IPE values and provenance through import/export.
- Implement versioned JSON backup/restore with tenant-bound ownership.

### Gate 3 — Workflow and audit
- Add submit, review, approve, reject, return-for-revision and publish states.
- Enforce separation of duties and delegated approval limits.
- Write append-only audit events in the same transaction as approved changes.
- Provide filtered audit search and export for authorized auditors.

### Gate 4 — Organization and scenario
- Support Group, Head Office, Centers and Business Units plus configurable lower levels.
- Model solid, dotted, functional and matrix reporting relationships.
- Maintain approved baseline and draft scenarios independently.
- Compare headcount, layers, spans, positions and grade distribution where data exists.
- Export diagrams to PNG/SVG and PowerPoint with scenario/version metadata.

### Gate 5 — Bilingual and usability
- Complete Vietnamese and English coverage for navigation, forms, validation, help, templates and exports.
- Ensure language switching does not change stored values.
- Test responsive layouts, accessibility, keyboard navigation and large datasets.

### Gate 6 — Release readiness
- Complete security review, backup restore drill, performance test and user acceptance test.
- Publish release manifest and migration notes.
- Deploy to preview, obtain sign-off, then promote to production.
- Retain rollback path and verify production health after release.

## 7. Minimum test suite

- Tenant A cannot select, mutate or export Tenant B data using direct API calls, guessed UUIDs or altered filters.
- Suspended and removed memberships lose access immediately.
- Viewer cannot write; HR Editor cannot approve; Approver cannot silently alter source evaluation evidence.
- Evaluation source values and provenance remain unchanged through import, export and version migration.
- SLOT records are not treated as completed PE evaluations.
- Rejected and returned workflow requests retain the complete decision history.
- A published baseline cannot be overwritten by a draft scenario.
- CSV/XLSX import rejects malformed required fields and reports row-level errors without partial writes.
- Backup restore reproduces record counts, IDs, versions and source hashes.
- Vietnamese/English switching preserves all underlying values.
- Exports are tenant-scoped and contain correct company/scenario/version/effective date metadata.

## 8. External prerequisites and safety boundary

The inspected Vercel project is deployed as a static application and is not yet connected to a verified production database/authentication service. Completing Gates 1–6 requires an approved database/auth provider project, owner-controlled credentials, an agreed data-processing/security policy, and a deployment path. No paid service, production secret, custom domain, billing upgrade or real customer data is to be created or changed without explicit authorization.

## 9. Definition of done

The product is complete only when all gates pass, the acceptance checklist in docs/CORE_DESIGN_PRINCIPLES.md is verified against the deployed build, cross-tenant security tests pass, the restore drill succeeds, and the owner receives the production URL plus admin onboarding and operating documentation. Until then, label the product V6 prototype / controlled pilot, not production SaaS.
