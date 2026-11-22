# Enterprise Job Architecture Platform 6.0

Standalone V6 browser prototype based on the V5 Job Architecture source application and previously agreed methodology.

Features inherited from V5 include organization analysis, job description, evaluation records, internal grading, career streams and levels, job families, mapping, development, data quality, governance, multi-company browser workspaces, CSV/JSON import and CSV/JSON export. V6 adds Excel workbook export and PowerPoint summary export. XLSX/PPTX libraries are loaded from public CDNs.

Methodology: Job Analysis & Organization Context -> Mercer IPE / Job Evaluation -> Internal Job Grading -> Career Streams & Levels -> Job Families & Sub-families -> Job Profiles.

Important: This remains a browser prototype. Data is stored in localStorage and is not synchronized across users/devices. It does not yet provide server-side tenant isolation, authentication, role-based permissions, cloud database, server-side audit log or approval workflow. Mercer IPE scores are recorded as provided; no licensed IPE score calculation is performed. Validate imported data before operational use.
