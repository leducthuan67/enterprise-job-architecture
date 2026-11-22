# V4 → V5 Native Module Migration Register

Status: Working migration register. No production migration has been executed.

## Source inspection findings
- The V4 Production deployment is available in the Vercel project named `enterprise_job_architecture_platform_4_0_cloudflare_deploy`.
- The V4 Production deployment's file tree exposes a static `index.html`.
- The GitHub repository branch `v5-development` currently contains a 129,274-byte `index.html` titled Enterprise Job Architecture Platform 4.0 in its HTML title, while its in-page header and version marker describe a 5.0 advanced prototype. This mixed labeling must be resolved before using that file as the V5 baseline.
- The inspected HTML embeds a large position dataset and browser-side logic. The dataset includes organization-specific identifiers and comments. It must not be copied into a client-neutral build without a full scrub and validation.
- The current repository also has a V5 integration architecture document. The branch remains isolated from `main`.

## Native V5 module mapping

| Existing capability / source | Destination in V5 | Migration treatment | Verification |
|---|---|---|---|
| 10-step workflow navigation | V5 Workflow / Dashboard | Keep one V5 navigation tree; normalize step labels and routing | All ten steps reachable inside V5 |
| Organization Review / Org Chart | Organization | Port data structures and views; add governed reporting-line relationships | Org chart hierarchy, parent-child integrity, entity isolation |
| Job Analysis | Job Analysis | Retain evidence fields and structured analysis; connect to JD | Required fields, evidence traceability |
| Job Description | Job Description | Retain JD view/template and version model | Position-to-JD link, approval state, version history |
| Job Evaluation Results | Job Evaluation | Port display of source PC and factor ratings; do not recalculate methodology | Source-to-target value reconciliation |
| PC Matrix | Job Evaluation / Reference Data | Migrate as a governed reference table | 33 source rows reconciled; uniqueness and coverage |
| Internal Grade Framework | Job Grading | Migrate grade definitions and PC bands as supplied | 22 definitions reconciled; overlaps flagged, not silently resolved |
| Career Streams & Levels | Career Architecture | Retain provisional/reference status where source indicates it | HR approval status visible |
| Job Family / Sub-family | Job Architecture Taxonomy | Use approved catalogue only; no unapproved auto-classification | Catalogue owner and effective version |
| Job Architecture Mapping | Job Architecture | Native mapping view using shared V5 entities | Position, family, stream, level, grade links validated |
| Career Development Tracks | Career Development | Preserve illustrative movement examples as non-binding until approved | Readiness rules and approval gate |
| Job Success Profiles | Success Profiles | Retain structured template; do not invent competency content | Profile source and approval state |
| Data Explorer | Data Management | Rebuild as V5 data browser with permission-aware filtering | Tenant scoping, access tests, search/export tests |
| Data Quality & Validation | Data Quality | Port checks and add migration exception reporting | Duplicate, missing, invalid and orphan record tests |
| Methodology & Rules | Methodology | Preserve source references and distinguish policy from recommendations | Version, source, owner and approval displayed |
| Governance & Change Control | Governance | Upgrade to server-side workflow/audit where implemented | Audit events, approvals, effective dates |

## Data migration contract

### Known source checkpoints
- Positions: 81 records (previously identified as 67 PE and 14 SLOT in the source view).
- PC Matrix: 33 rows.
- Grade Definitions: 22 rows.

The counts above are source checkpoints only. They do not establish successful extraction or migration.

### Required migration fields
For every migrated entity, retain:
- Source system and source record key
- Target V5 entity ID
- Company / tenant ID (assigned only after approved neutral tenant mapping)
- Source version / effective date where available
- Migration batch ID and timestamp
- Migration status: migrated, rejected, duplicate, or pending review
- Exception reason and reviewer decision

### Reconciliation output
A migration report must show source count, extracted count, migrated count, rejected count, duplicate count, and unresolved count by entity type. Every difference must be explained. Do not silently drop, merge, or rewrite source values.

### Sensitive-data handling
- Quarantine the original source dataset; do not expose it in a public or client-neutral preview.
- Scan organization names, abbreviations, codes, place names, free-text comments, metadata, hidden fields, export files and embedded sample data.
- Replace organization identity only through a documented anonymization map. Preserve meaningful job titles, responsibilities and professional terminology.
- Verify the anonymized output with both automated scanning and human review before it is used for demonstrations or deployment.
- Do not copy source comments verbatim into a public preview.

## Technical integration requirements
- All modules must use the same V5 tenant context, authentication, authorization, navigation, API and data model.
- No iframe, external V4 URL, V4 launch button, cross-app redirect, or V4 runtime call.
- Avoid duplicate datasets and parallel localStorage stores. V5 data services are the authoritative runtime.
- Maintain stable entity IDs and explicit relationships between Organization, Position, Job Profile, Evaluation, Grade, Career Architecture and Success Profile.
- Imported PC and factor values are read-only source facts unless an authorized correction workflow records the old value, new value, evidence, approver and effective date.
- Separate prototype-only capabilities from production-ready capabilities in the UI and documentation.

## Deployment guardrail
Both V4 and V5 Vercel projects are linked to the same GitHub repository. A commit on `v5-development` can create Preview deployments in more than one linked Vercel project. Before further code commits, verify project Git settings and ensure V4 Preview deployments cannot be mistaken for the V5 test environment. Do not change V4 Production or V5 Production during migration.

## Next implementation gates
1. Obtain complete source files and exact V4/V5 deployment provenance; do not use truncated source payloads as implementation input.
2. Establish the canonical V5 code baseline and separate client-neutral application code from client data.
3. Extract V4 data into a controlled migration package; run client-neutralization and reconciliation.
4. Implement native V5 module migration in dependency order: shared data model → Organization/Position → Evaluation/Grade → Career Architecture/Mapping → Data Explorer/Governance.
5. Add integration tests and tenant/role security tests.
6. Deploy Preview only to the intended V5 project; verify UI and data end-to-end.
7. Obtain user acceptance before Production promotion or V4 retirement.
