---
name: privacy-opsec
description: Operating instructions when handling sensitive data — personal records, application materials, credentials, location, communications. Apply defense-in-depth principles; never link anonymous activity to identified accounts. Use when a project involves real personal data or when threat-modelling matters.
---

# Privacy & Operational Security

This module is about handling sensitive data competently — yours or someone else's. It's not about evading nation-state surveillance (that's a separate, deeper problem). It's about not leaking what doesn't need to be leaked.

## The core principle: defense in depth

No single layer is sufficient. Each layer compensates for the failures of the others. Most data leaks happen because someone relied on one control and it failed.

| Layer | Concern | Examples |
| --- | --- | --- |
| Network | Who can see your traffic? | TLS everywhere, VPN where appropriate, no auth-required services on plain HTTP |
| Communication | Who can read your messages? | E2E-encrypted apps (Signal, Matrix); not SMS, not platform DMs |
| Identity | Who can link your accounts? | Compartmentalisation; separate emails per identity; no shared passwords |
| Device | What if someone has the hardware? | Full-disk encryption, screen lock, biometric or strong passphrase |
| Discipline | Are you following the rules consistently? | The hardest layer; most failures happen here |

## Compartmentalisation

Don't link your activities. Common rules:

- **Different email per context** — work, personal, public-facing, financial. ProtonMail or Tutanota for accounts that should not be linked to a Google identity.
- **Different password per account** — managed by a password manager (Bitwarden, 1Password). Reused passwords are how single breaches become identity-wide compromises.
- **Different identity per public profile** — if you don't want a future employer to find your gaming handle, don't use the same username.
- **Never log into a real account from an "anonymous" session** — once joined, the link is permanent. Browsers, cookies, and behavioural fingerprints keep records.

## Metadata hygiene

Metadata is often more revealing than content.

- **Photos**: EXIF data embeds GPS, device, timestamp. Strip with `exiftool -all= file.jpg` or platform tools (Scrambled EXIF on Android) before sharing.
- **Documents**: Word, PDF, and Office files embed author names, edit history, comments, revision tracking. `Inspect Document` in Word; `qpdf --linearize` for PDFs; or convert to PDF/A.
- **Emails**: who/when/how-often is observable even with encrypted content. Reduce frequency and predictability when that matters.

## Communication tooling

Pick by threat model:

- **Most contexts** (general privacy, not nation-state) → Signal. E2E by default, registers with phone number.
- **Anonymous identity** → Session. No phone number; identity is a cryptographic key.
- **Activist or journalism contexts** → Briar (works without internet, peer-to-peer over Tor / WiFi / Bluetooth). Or Signal with disappearing messages.
- **Self-hosted small team** → Matrix with your own homeserver.

Don't assume "private" messages on social platforms (X, Instagram, Facebook DMs) are private from the platform. They are not. The platform reads them and complies with subpoenas.

## Device baseline

- Full-disk encryption (LUKS on Linux, BitLocker on Windows, FileVault on macOS, default on iOS, opt-in on Android — turn it on)
- Screen lock with passphrase (not just biometric — biometrics can be compelled)
- OS updates installed promptly
- Browser: Firefox with uBlock Origin and a private container per identity, or Brave for less configuration
- Avoid logging into personal accounts on shared/work devices

## Data handling for projects

When the project involves personal data (yours, applicants', users'):

- **Minimise collection.** Don't collect what you don't need. Every field is a future leak.
- **Encrypt at rest.** Database fields, file storage, backups.
- **Encrypt in transit.** TLS only, no plaintext APIs internal or external.
- **Access control.** Need-to-know basis; logs of who accessed what.
- **Retention policy.** Delete data on a schedule. Old data is liability.
- **No PII in logs, metrics, error reporting, or LLM prompts.** Redact at the boundary.

## The human layer (where most failures happen)

- **Telling someone.** The most common cause of compromise. Need-to-know is a discipline.
- **Routine.** Same time, same place, same handle, same device makes you trivially trackable.
- **One mistake destroys the stack.** Logging into a real account once from a compartmentalised browser links them forever. If unsure whether something is safe, don't.
- **Phishing**. Even with all the above, a convincing email that asks for credentials beats every technical control. Treat password / 2FA / financial requests with paranoia.

## Threat modelling (one paragraph)

Before applying controls, ask: *who am I defending against, what do they want, and what would they do?* The controls that matter for "I don't want my employer to find my forum posts" are different from "I'm a journalist working on a sensitive story". Don't apply nation-state controls to commercial-privacy problems (you'll fail to maintain the discipline, and the discipline is most of what protects you), and don't apply commercial-privacy controls to nation-state problems (the controls don't go deep enough).

## When working with an AI agent on sensitive material

- Don't paste production credentials into prompts, even for "just one moment"
- Strip PII from samples before feeding them to the model
- Logs of conversations may persist; treat them like logs of any other system

## Anti-patterns

- Using one email for everything
- Storing passwords in a notes app or browser without encryption
- Sharing links from "private" social platforms as if they're actually private
- Stripping metadata from one file in a batch and forgetting the others
- Disabling security features for convenience and never re-enabling them
- Rolling your own crypto

## See also

- `domains/infra-containers.md` — TLS, secret management, container isolation
- `core/CLAUDE.md` — handling identity and credentials in applications
