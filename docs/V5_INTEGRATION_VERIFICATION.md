# V5 Integration Verification Register

Last checked: 2026-11-22 (Asia/Ho_Chi_Minh)
Branch under development: `v5-development`
Repository: `leducthuan67/enterprise-job-architecture`

## Verified deployment state

| Item | Verified result | Meaning |
|---|---|---|
| V5 Production | Deployment `dpl_4eyVee2YunJK8d7gbWBwAjKu9Zi4` is READY with target `production` | Existing production deployment is still the rollback/production baseline; no V5/V4 merge is proven |
| V5 development Preview | Deployment `dpl_DCzdJBKhQ8LP9MxbvxpZzTbqeFRL` is READY from commit `7a84d8b39a964026fc7632a15baf2896b4bf009b` | Preview build completed for the current development commit |
| V4 Production | Deployment `dpl_7Sf92tNW9Te7ku38v9wB6rHv2XKq` is READY with target `production` | Existing V4 production baseline remains present |
| V4 development Preview | Deployment `dpl_GNjT7t4GN8k7JnNcfkn4P8mz8d8t` is READY from the same development commit | V4 project is also receiving builds from the shared repository/branch |

A READY state confirms a successful Vercel build/deployment state only. It does not prove feature correctness, migration, security, tenant isolation, or user acceptance.

## Source inspection findings

### V4 / repository branch
- The repository's `index.html` is a single-file browser application. Its visible product title is 4.0 although its header badge says 5.0.
- The source includes 10 workflow steps and local browser workspace behavior.
- The source includes organization-specific division codes, position names, comments and other identifying content. It is not safe to reuse as a client-neutral dataset without a reviewed transformation and scan.
- The README explicitly describes browser-local storage, CSV/JSON import/export, and the absence of server-side authentication, role permissions, cloud database, server audit, multi-level approvals, XLSX import and PowerPoint export.
- The V4 data baseline in the application/migration design is 81 positions (67 PE, 14 SLOT), 33 PC Matrix rows and 22 grade definitions. These are source reconciliation checkpoints, not migrated counts.

### V5 / existing production deployment
- The deployment tree includes `src/index.html`, `src/api/v5-auth.js`, `src/api/v5-data.js`, `src/package.json` and `src/vercel.json`.
- The two API modules and HTML source are too large for the connected deployment-file retrieval response; returned content was explicitly truncated. Therefore a complete code review or source-to-source merge cannot be performed from those partial responses.
- The inspected API snippets show private Vercel Blob storage and session-token handling. This is not enough evidence to certify the full authentication, authorization, or tenant-isolation implementation.
- The repository branch's `index.html` is not the same source tree as the V5 production deployment. Do not overwrite it or copy it into V5 as a substitute for the unavailable V5 source.

## Current blockers (must be cleared before integration)

1. Obtain complete, versioned V5 source (including both API modules, HTML, package manifest, Vercel config and environment-variable names only; never commit secret values).
2. Separate V4 and V5 Vercel Git deployment scopes. The same `v5-development` commit currently creates Preview deployments in both projects. Do not assume the project preview-disable setting has stopped this: the V4 Preview was observed after the setting update.
3. Obtain a complete V4 source/data export and define a reviewed anonymization alias map before changing any source records or comments.
4. Build a deterministic migration adapter and reconcile source, migrated, rejected, duplicate and exception counts.
5. Run browser/API tests, authorization and tenant-isolation tests, client-neutral scans, import/export checks, and user acceptance on V5 Preview.

## No-go conditions

- Do not promote a development Preview to Production.
- Do not retire V4.
- Do not expose or invent login credentials.
- Do not claim the V4 modules or data are integrated until the migration and tests above have evidence.
- Do not add a V4 launch button, external V4 link, iframe or V4 runtime dependency to V5.

## Next safe implementation sequence

1. Establish independent V5 source control and Vercel project deployment scope.
2. Commit V5 source to a dedicated V5 path/branch without changing V4 Production.
3. Port V4 capabilities as native V5 modules and data contracts; retain V5 authentication and tenant context.
4. Anonymize through a reviewed mapping, then run deterministic reconciliation.
5. Test and document every acceptance criterion before Production release.
