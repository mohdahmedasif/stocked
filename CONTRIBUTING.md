# Contributing to Stocked

Thanks for helping out. Stocked is a self-hosted pantry tracker built with Express, React and SQLite, with an optional Gemini photo reader.

Please read the [Code of Conduct](CODE_OF_CONDUCT.md) before you take part.

## Keep private data out

Never commit, upload or paste:

- `.env`, `secret.key`, Gemini keys, `ADMIN_KEY` or PINs
- Real inventory data, including photos, CSV exports and backups
- Deploy keys

Use invented item names and placeholder tokens in tests and fixtures.

## Development setup

You need Node.js 22 or later.

```bash
git clone https://github.com/mohdahmedasif/stocked.git
cd stocked
cp .env.example .env
npm install
npm run install:all
npm run dev
```

The UI runs on http://127.0.0.1:5173 and the API on port 3000.

## Checks before you open a PR

```bash
npm --prefix server test       # server test suite
npm --prefix client run build  # type-check and build the client
```

CI runs the same checks on pull requests, so they're a useful preview.

## Pull requests

1. For a larger change, it helps to open an issue first to discuss the approach.
2. Keep each PR to one problem.
3. Follow the style of the surrounding code, and avoid reformatting files you aren't changing.
4. In the PR description, explain **why** the change is needed, not only what changed.
5. Fill in the PR template, including the privacy checklist.

## Good places to start

- Clearer empty states, error messages and labels
- Accessibility improvements in the UI
- Tests for the server routes and the photo-reading logic, using fake data
- Documentation fixes

## License

By contributing, you agree that your work will be released under the [MIT License](LICENSE).
