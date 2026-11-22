# Enterprise Job Architecture Platform — Core Design Principles & Acceptance Criteria

**Standard ID:** EJA-CORE-001  
**Baseline:** V6  
**Status:** Mandatory product and delivery standard  
**Applies to:** Platform, methodology, training materials, consulting projects and all company workspaces

## 1. Mercer IPE integrity
- The platform may store, import, display, compare and report authorized Mercer IPE outputs supplied by the client or licensed evaluator.
- It must not independently calculate, reverse-engineer, modify, overwrite or represent its own estimate as an official Mercer IPE result.
- Preserve source values, source file, evaluation date, evaluator/reference, version and approval status where provided.
- Any internal grade mapping is a separate organization policy layer. It must not change the source IPE result.
- Provisional mappings and HR recommendations must be clearly distinguished from approved decisions.

## 2. Organization coverage
Support the organizational scope:
1. Group
2. Head Office
3. Centers
4. Business Units

The organization model must allow configurable departments, functions, teams and reporting relationships below these levels. Parent-child relationships and reporting-line types must be explicit; sample/demo structures must be labelled illustrative until confirmed.

## 3. Bilingual experience
- Vietnamese and English are first-class interface and content languages.
- Navigation, labels, instructions, data templates, validation messages, exports and methodology/training materials must be aligned in both languages.
- Language switching must not alter underlying records or calculations.
- Imported source values should be preserved; translated display labels must not overwrite original data.

## 4. Excel data exchange
- Support upload/import of XLSX and CSV, plus JSON backup/restore where applicable.
- Provide validated templates, required-field checks, data-quality feedback and import preview/error reporting.
- Export structured Excel workbooks with clearly named sheets, stable column definitions and metadata.
- Never silently change source IPE values during import/export.

## 5. Organization and grading simulation
- Support current-state and proposed-state organization models.
- Support moving/adding/removing units and positions in a scenario without overwriting the approved baseline.
- Support position-to-unit assignment, reporting lines, headcount and span/layer views where source data permits.
- Support internal grade distribution and scenario comparison, with clear distinction between official IPE data, internal policy mapping and provisional suggestions.
- Export organization diagrams as image files and PowerPoint slides. Exported outputs must identify company, scenario, version and date.

## 6. Multi-company architecture
- Support multiple independent company workspaces.
- Company data, organization models, grade frameworks, language preferences, scenarios and approvals must be isolated by tenant.
- Production release requires server-side tenant isolation, authentication, role-based access, backup and audit trail. Browser-local workspaces are prototype functionality only and do not satisfy production multi-tenant security.

## 7. Version synchronization and governance
- Platform, methodology, training and project delivery materials must share a controlled version baseline.
- Each release must publish a version manifest with release ID, effective date, changes, impacted methodology/training/project documents and migration notes.
- Methodology changes must be reflected in Platform rules and training materials; Platform changes that affect delivery must trigger corresponding document updates.
- Keep a traceable change log and approval status. Do not silently change approved methodology or client project baselines.

## Release acceptance checklist
A release may be described as meeting this standard only when:
- [ ] IPE source integrity and provenance controls are verified.
- [ ] Group / Head Office / Centers / Business Units hierarchy and configurable reporting lines are testable.
- [ ] Vietnamese and English coverage is complete for the released scope.
- [ ] XLSX import, validation, preview, export and round-trip tests pass.
- [ ] Current/proposed org simulation, grading comparison, image export and PPT export pass.
- [ ] Multi-tenant isolation and role permissions pass security tests for production.
- [ ] Platform, methodology, training and project version manifest is synchronized.

## Current V6 implementation note
V6 is a browser prototype derived from the V5 application. It contains the existing job architecture workflow, source PC/grade data, browser-local company workspaces, CSV/JSON import/export and V6 Excel/PPT export additions. These prototype capabilities do not by themselves prove full acceptance of this standard. In particular, server-side tenant isolation, production authentication/authorization, full bilingual coverage, robust organization scenario modelling and image export must be verified or completed before claiming production readiness.
