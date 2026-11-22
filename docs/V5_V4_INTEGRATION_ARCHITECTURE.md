# V5 Integration Architecture: V4 capabilities absorbed into V5

Status: Approved design baseline; implementation and acceptance are pending.

## 1. Product principle
V5 is the single user-facing Enterprise Job Architecture Platform. V4 is a source of existing capabilities and data to be migrated into V5, not a separate application to be opened from V5.

The V5 interface must not contain a V4 launch button, external V4 navigation, iframe, embedded V4 page, or runtime dependency on the V4 deployment.

## 2. Preservation and release boundaries
- Develop on branch `v5-development`; do not overwrite `main` during development.
- Do not modify V5 Production or retire V4 until V5 has passed acceptance.
- Do not modify ILM Workforce Lab.
- Keep methodology and source-of-truth distinctions: approved training methodology governs; delivery materials operationalize it; the platform implements approved methodology; handbook explains concepts.
- Treat the ILM Workforce Lab as a UI/UX reference only where explicitly approved, not as a source of Job Architecture methodology or data.

## 3. V4 capabilities to absorb into V5
Rebuild or port the relevant capabilities into native V5 modules:
- Job Evaluation results and PC Matrix
- Internal Job Grading Structure and Grade Definitions
- Job Architecture Mapping
- Data Explorer and search/filter/export capabilities
- Methodology & Rules reference
- Existing relevant data views and validations

These must use V5 navigation, authentication, authorization, tenant context, design system, and data services. No V4 page is to be embedded.

## 4. V5 capabilities to retain and extend
- Multi-company / tenant-aware data separation
- Platform, Group, Business Unit, Reviewer, and Read Only role model (subject to final role design)
- Import/export with validation, duplicate/error reporting, and templates
- Approval workflow, audit trail, version history, and data governance
- Analytics, simulation, planning, and presentation/image exports
- Integration/API capability, subject to security and implementation review

## 5. Ten-step Job Architecture workflow
1. Organization Review & Org Chart
2. Job Analysis
3. Job Description
4. Job Evaluation Results
5. Internal Job Grading Structure
6. Career Streams & Career Levels Mapping
7. Job Family & Sub-family Mapping
8. Job Architecture Mapping
9. Career Development Tracks
10. Job Success Profiles

Data relationships between steps must be explicit. Do not infer or fabricate Mercer IPE/HAY scores, factor ratings, PC results, or proprietary methodology. Imported official results remain source data; derived suggestions must be marked provisional and require HR validation.

## 6. V4 data migration baseline
Previously identified V4 baseline for reconciliation:
- 81 position records
- 33 PC Matrix rows
- 22 Grade Definitions

These counts are migration checkpoints, not proof that migration has occurred. Before/after reconciliation must record source count, migrated count, rejected count, duplicate count, and reason for each exception. Preserve source identifiers or a controlled crosswalk for traceability.

## 7. Client-neutralization
Remove organization-specific names, abbreviations, codes, logos, place names, and indirect identifiers from application source, UI, sample data, import templates, exports, metadata, comments, and documentation. Use generic labels such as Company A, Group, Head Office, Business Unit, Site, and Location where appropriate. Do not remove meaningful role or job content merely because it is specific.

## 8. Acceptance criteria
- Users access all absorbed V4 capabilities within V5; no V4 launch or navigation control exists.
- No V4 iframe, embedded page, or V4 runtime dependency remains.
- Single V5 authentication and role-aware access control apply to all modules.
- V4 data migration is reconciled and exceptions are documented.
- Ten workflow steps are navigable and linked through governed data.
- Import/export, validation, search/filter, and applicable simulation/export flows are tested.
- Tenant isolation, authorization, audit/version behavior, and error handling are tested.
- Client-neutral scan covers source, UI, datasets, API, templates, exports, metadata, and documentation.
- Preview testing and user acceptance are completed before Production promotion.
- V4 is not retired until V5 is accepted and the rollback plan is verified.

## 9. Current implementation limitation
The existing Vercel deployment source files were only partially retrievable through the connected tooling (large file contents were truncated). Therefore this document records the approved integration baseline only. It does not claim that V4 has been integrated, that migration has run, or that V5 has passed testing.
