# Security Policy

## Supported versions

Stocked is maintained on the `main` branch. Security fixes go to `main` and are published as a new Docker image. Older builds are not patched.

## What is sensitive

Stocked keeps these on the machine that runs it:

- The `ADMIN_KEY`, which pairs browsers and resets PINs
- Profile PINs, stored only as salted scrypt hashes
- Gemini API keys, stored encrypted with the `secret.key` file
- The inventory itself, in SQLite files in the data directory

Treat each of these like a password.

## Reporting a vulnerability

Please **do not** open a public issue for a security problem.

Report it privately through [GitHub private vulnerability reporting](https://github.com/mohdahmedasif/stocked/security/advisories/new). Include:

- A description of the issue and its impact
- Steps to reproduce, or a proof of concept
- The version or commit you tested

Don't include real keys, PINs or inventory data in the report. Use made-up data instead.
