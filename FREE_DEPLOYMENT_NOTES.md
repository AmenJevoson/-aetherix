# AETHERIX Free Deployment Notes

## Current Status

This source package now passes:

```bash
corepack pnpm check
corepack pnpm build
corepack pnpm test
```

The app is ready for a free preview deployment without a custom domain.

## Recommended Free Path

Use Vercel Hobby with the free `*.vercel.app` domain.

1. Create a GitHub repository named `aetherix`.
2. Push this project folder to GitHub.
3. Import the repository in Vercel.
4. Keep the default build settings from `vercel.json`.
5. Deploy.

The first public URL will look like:

```text
https://aetherix-<suffix>.vercel.app
```

## Minimum Environment Variables

For a frontend-only preview, you can deploy without secrets. Public pages should load.

For login and AI/database features, set these in Vercel:

```env
NODE_ENV=production
JWT_SECRET=<generate-a-strong-secret>
DATABASE_URL=<mysql-compatible-connection-string>
GOOGLE_CLIENT_ID=<google-oauth-client-id>
GOOGLE_CLIENT_SECRET=<google-oauth-client-secret>
GOOGLE_CALLBACK_URL=https://<your-vercel-domain>/auth/google/callback
BUILT_IN_FORGE_API_URL=https://api.manus.im
BUILT_IN_FORGE_API_KEY=<manus-api-key>
VITE_APP_ID=<app-id-if-using-manus-oauth>
VITE_OAUTH_PORTAL_URL=https://oauth.manus.im
```

## Free Database Options

The code uses MySQL through Drizzle. A MySQL-compatible free/starter database is required for real login and subscriptions.

Good candidates:

- TiDB Cloud Starter
- Aiven free/trial MySQL if available in your region
- A local Docker MySQL only for local testing

PlanetScale is MySQL-compatible, but check current pricing before choosing it.

## Important Fixes Applied

- Fixed `wouter` navigation usage.
- Fixed tRPC login URL call in the login page.
- Fixed AI orchestrator TypeScript errors.
- Mounted `riskControl` routes in the main tRPC router.
- Added a real `/health` endpoint.
- Added Google OAuth HTTP routes under `/auth/google/login` and `/auth/google/callback`.
- Added Vercel serverless entry under `api/index.ts`.
- Reworked `vercel.json` for the current project structure.
- Fixed production static file lookup.
- Removed hard-coded Google OAuth secret from `.env.example` and tests.
- Updated page metadata from the old Signal Weekly text to AETHERIX.

## Known Limits

- Google OAuth will not work until you create new credentials for the final Vercel URL.
- AI functions will not work until `BUILT_IN_FORGE_API_KEY` is configured.
- Database-backed features will not work until `DATABASE_URL` points to a reachable MySQL-compatible database and migrations are run.
- The local Codex sandbox blocked listening on ports, so local browser verification could not be completed here. Build and tests passed.

