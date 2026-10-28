# YanMata account deletion guide

Last updated: 28 October 2026

This guide covers self-service deletion for YanMata **member** accounts. Staff, reviewer, publisher and specialist accounts use administrator-managed offboarding because their actions may be part of required clinical, safeguarding or publication audit records.

## Delete a member account in the app

1. Open YanMata and sign in.
2. Open **You**.
3. Under **Account controls**, choose **Delete account**.
4. Read the permanent-deletion warning.
5. Enter the current account password.
6. Type `DELETE` exactly.
7. Choose **Delete account permanently**.

The server verifies the password, revokes access tokens and deletes the member account. YanMata then clears the current device’s local account data. If verification or deletion fails, local data is retained and the app shows an error.

## Data covered

The current database relationships delete the member’s profile, journal/sync records, cycle settings, support requests and conversations, registered devices, notification preferences and access tokens. Orders and support records whose schema intentionally permits a null user are de-identified by removing the account link rather than being presented as active member data.

Before production, the privacy owner must confirm the retention schedule for security records, audit metadata and backups. Protected backups may retain deleted data until their documented expiry; restored backups must replay deletion records before returning to service.

## Other devices and offline data

An offline device cannot be remotely erased. The member must log out, clear app data or uninstall YanMata on every other device holding an offline copy. A deleted account cannot authenticate or upload queued records when that device reconnects.

## If the member cannot use the app

Use the official contact channel at [Zentreeca.org](https://zentreeca.org) and request YanMata account deletion. Identity verification is required. Do not include journal entries, chat messages or other health details in the request.

## Logout is different

**Logout** revokes only the current session and clears this device’s account data. Synced server data and the account remain available for a future sign-in. The warning explicitly calls out unsynced changes because they are lost when local data is cleared.

## Verification requirements

- Incorrect password and incorrect confirmation must not delete anything.
- A successful deletion returns HTTP 204, removes the member and invalidates the old token.
- Staff and specialist deletion attempts return HTTP 403.
- Mobile local data is deleted only after the API confirms server deletion.
- No health text, password or access token may appear in logs, analytics or push payloads.
