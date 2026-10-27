# API contract

`openapi.json` describes only the implemented v0.1 foundation. Laravel API tests are the executable authority. Generated client automation and schema compatibility CI are pending. No specialist, notification or account-registration endpoint is implied.

Browser: GET `/sanctum/csrf-cookie`, then POST `/api/v1/session` with the XSRF token header and cookies. Production must configure secure cookies, allowed origins and stateful domains for its actual domain. Mobile: POST `/api/v1/mobile/login`, store token in OS-backed secure storage, send Bearer token, reauthenticate after expiry.

Sync: persist local entry and mutation together; retry identical mutation UUID/payload until acknowledged. Key ordering does not change idempotency. Preserve conflicts and advance a pull cursor only after persisting the returned page. Deleted IDs cannot be resurrected. The current cursor has no expiry/compaction; implement epochs and snapshot recovery before production retention is enabled.
