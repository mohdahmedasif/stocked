# Stocked

A self-hosted pantry tracker for food, medicine and household supplies. It records what you have, where it is kept and when it expires. An optional Gemini photo scan can fill in the add form from a product label.

## Features

- **Pantry**: search, filter by category or location, and sort by name, expiry or stock.
- **Products and batches**: one product can have several purchases. The total on hand is the sum of the batch counts.
- **Photo add**: take or upload a label photo, and Gemini drafts the fields for you to review.
- **History**: every change to a batch count is logged.
- **Reports**: a table with CSV export and print.
- **Catalog**: edit categories, locations, package types and units.
- **Backup and restore**: export all data to one file and restore it on a new install.
- **Import**: load an existing Google Sheets CSV.

## Requirements

- Node.js 22 or later
- Optional: a [Gemini API key](https://aistudio.google.com/) for photo extraction

## Getting started

```bash
git clone https://github.com/mohdahmedasif/stocked.git
cd stocked
cp .env.example .env    # set ADMIN_KEY
npm install
npm run install:all
npm run dev
```

Open http://127.0.0.1:5173. In development, Vite serves the UI and proxies `/api` to the Express server on port 3000.

To run the production build locally:

```bash
npm run build
npm start
```

Then open http://127.0.0.1:3000.

## Docker

```bash
cp .env.example .env    # set ADMIN_KEY
docker compose up -d --build
```

The app runs on port 3000 (or the `PORT` you set). Data is kept in the `stocked-data` volume.

## Configuration

Only two environment variables are read from `.env`:

| Variable | Description |
|----------|-------------|
| `PORT` | Port the app listens on. Defaults to `3000`. |
| `ADMIN_KEY` | Required. Used to pair a browser and to reset a forgotten PIN. |

All other settings, such as expiry windows, the Gemini model, the app name and Gemini API keys, are managed in the app's Settings page. Categories, locations and units are managed in the Catalog.

Gemini API keys are stored encrypted with the `secret.key` file in the data directory. If that file is lost, saved keys must be entered again.

Never commit `.env`, `secret.key`, a database file or a backup file.

## Access

1. **Pair the device.** A browser must be paired once with the admin key. The pairing lasts a year and is renewed whenever a PIN is entered on that device.
2. **Unlock a profile.** Each person has a profile protected by a 4 to 8 digit PIN.

Each profile has its own inventory, history, catalog and settings, stored in a separate database file. Five wrong PINs in a row lock the profile for one minute, and each further wrong attempt extends the lock up to two hours. A forgotten PIN can be reset with the admin key. A lost device can be removed with **Settings → Unpair other devices**.

PINs are stored as salted scrypt hashes. Device and session tokens are stored as SHA-256 hashes. The PIN controls access to the app; the database file itself is not encrypted.

**HTTPS:** run the app behind HTTPS whenever it is reachable from the internet. Over plain HTTP, cookies are sent without the `Secure` flag, so anyone who can observe the network traffic could capture them.

**Reverse proxies:** the pairing rate limit is per IP address. Behind a proxy, all visitors share one address and therefore one limit.

## Installing as an app

Over HTTPS, or on `localhost`, the app can be installed from the browser's menu (**Install app** or **Add to Home Screen**). Inventory data is never stored on the device, so changes require a connection to the server.

## Data

| Entity | Meaning |
|--------|---------|
| Product | An item you stock, matched by name and category |
| Company | The brand of a purchase |
| Batch | One purchase, with its count, location, size, expiry and acquired date |

Adding a purchase identical to an existing batch increases that batch's count. Any other purchase creates a new batch.

**Backup:** on the Import page, choose **Full backup** to download a JSON file. Restoring it replaces the contents of the current profile. Gemini keys, PINs and paired devices are not included.

**Google Sheets import:** export the sheet as CSV, then use the Import page, or run:

```bash
npm run import:sheet -- path/to/export.csv
```

Rows with the same name and category are merged into one product, and each row becomes a batch.

## Deployment

### Docker on a server

Pull the image published by CI, then restart:

```bash
bash scripts/deploy-image.sh
```

The image is built and pushed to GitHub Container Registry by the [build workflow](.github/workflows/build-deploy.yml) when a change is merged to `main`.

To build on the server instead:

```bash
docker compose up -d --build
```

### systemd

```bash
npm run install:all && npm run build
sudo cp deploy/inventory.service /etc/systemd/system/inventory.service
# Edit User= and the paths in the unit file, then:
sudo systemctl daemon-reload
sudo systemctl enable --now inventory
```

### Updating without Docker

```bash
bash scripts/deploy.sh
```

This pulls `main`, installs dependencies, rebuilds the client and restarts the service.

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md). To report a vulnerability, see [SECURITY.md](SECURITY.md).

## License

[MIT](LICENSE)
