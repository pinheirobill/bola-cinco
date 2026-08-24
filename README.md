# Bola Cinco

Rails app base for Bola Cinco.

## Stack

- Rails 8.1.3.1
- Turbo + Stimulus
- Solid Queue / Solid Cache / Solid Cable
- Devise authentication
- Audited change tracking
- Tailwind CSS + daisyUI
- SQLite for local development

## Setup

```bash
bin/setup
```

## Run

```bash
bin/dev
```

## Notes

- Authentication uses Devise with a `User` model.
- Model changes are recorded through Audited.
- The home page is served from `HomeController#index`.
