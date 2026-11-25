# Enterprise Job Architecture Platform 6.0

Standalone V6 browser prototype based on the V5 Job Architecture source application and previously agreed methodology.

Features include organization analysis, job description, evaluation records, internal grading, career streams and levels, job families, mapping, development, data quality, governance, browser-local company workspaces, CSV/JSON import/export, Excel workbook export and PowerPoint summary export. XLSX/PPTX libraries are loaded from public CDNs.

Methodology: Job Analysis & Organization Context -> Mercer IPE / Job Evaluation -> Internal Job Grading -> Career Streams & Levels -> Job Families & Sub-families -> Job Profiles.

Important: This remains a browser prototype. Data is stored in localStorage and is not synchronized across users/devices. It does not yet provide server-side tenant isolation, authentication, role-based permissions, cloud database, server-side audit log or approval workflow. Mercer IPE scores are recorded as provided; no licensed IPE score calculation is performed. Validate imported data before operational use.

## Mandatory design standard
See docs/CORE_DESIGN_PRINCIPLES.md for mandatory product principles and release acceptance criteria. See docs/VERSION_MANIFEST.md for synchronization requirements across Platform, methodology, training and consulting projects.

## Production completion work
- docs/PRODUCTION_ARCHITECTURE_AND_COMPLETION_PLAN.md — target architecture, roles, delivery gates and definition of done.
- docs/RELEASE_TEST_MATRIX.md — security, data integrity, governance, scenario, export and operational acceptance tests.
- supabase/migrations/0001_multi_tenant_foundation.sql — initial PostgreSQL tenant/data model and row-level security policies.
- supabase/migrations/0002_scenarios_workflow_guards.sql — scenario/reporting model and workflow integrity guards.

The SQL migrations are engineering foundations only. They have not been applied to a live database or security-tested in a provisioned environment. Do not use real employee/customer data or describe the product as production SaaS until the release gates pass.
