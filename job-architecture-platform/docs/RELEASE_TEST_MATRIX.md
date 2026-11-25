# Enterprise Job Architecture Platform — Release Test Matrix

| ID | Area | Test | Expected result | Severity |
|---|---|---|---|---|
| SEC-01 | Tenant isolation | User in tenant A requests tenant B record by UUID | Denied; no metadata leakage | Critical |
| SEC-02 | Tenant isolation | Change tenant_id in request body/query | Server validates membership; denied | Critical |
| SEC-03 | Membership | Suspend or remove user membership | Access revoked on next request | Critical |
| SEC-04 | RBAC | Viewer attempts create/update/delete | Denied | High |
| SEC-05 | RBAC | HR Editor attempts approve/publish | Denied | High |
| SEC-06 | RBAC | Approver attempts alter source IPE values | Denied | Critical |
| DATA-01 | IPE integrity | Import then export evaluation record | Source values/provenance unchanged | Critical |
| DATA-02 | SLOT/PE | Import SLOT with blank factor fields | Remains SLOT; not treated as evaluated PE | High |
| DATA-03 | Import | CSV/XLSX contains missing required fields | Row-level error; no partial commit | High |
| DATA-04 | Backup | Backup and restore tenant workspace | Counts, IDs, versions and hashes match | High |
| GOV-01 | Approval | Submit, return, reject, approve and publish | Full decision trail and effective date retained | High |
| GOV-02 | Separation | Requester attempts own approval where prohibited | Denied | High |
| ORG-01 | Scenario | Modify proposed org chart | Approved baseline remains unchanged | High |
| ORG-02 | Hierarchy | Group → Head Office/Centers/BUs → lower levels | Parent-child and reporting types validate | High |
| UX-01 | Language | Switch EN ↔ VI on all screens | Complete translated labels; data unchanged | Medium |
| EXP-01 | Export | Export report from tenant A | No tenant B data; metadata identifies scenario/version | Critical |
| OPS-01 | Recovery | Restore latest backup to isolated environment | Restore completes and verification passes | Critical |
| OPS-02 | Release | Roll back failed release | Previous approved release is restored | Critical |

Do not promote a release if any Critical test fails. High-severity failures require documented owner risk acceptance; security and data-integrity failures cannot be waived for production use.
