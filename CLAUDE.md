# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
bundle install && yarn install

# Database
rails db:create db:migrate db:seed

# Run development server (starts Rails + JS watcher + CSS watcher)
foreman start -f Procfile.dev

# Build assets
yarn build && yarn build:css

# Tests
rails test                    # all tests
rails test test/models/       # specific directory
rails test test/models/user_test.rb  # single file

# Linting / security
bundle exec rubocop
brakeman
```

## Architecture

License Server is a Rails 8 app that manages **floating network licenses** for desktop applications and **compiles program descriptions** for those applications.

### Core Domain

- **Company** — a license-holding organization; users belong to a company
- **License** — a floating license owned by a company; can be checked out by one user at a time; has `license_type` enum (Standard/Limited)
- **User** — belongs to a company, has Rolify roles (`:admin` or `:user`), tracks activity timestamps (`last_checkout_time`, `last_checkin_time`, `last_compile_time`)
- **Program** — a user-uploaded program source (with Active Storage `binary_input` attachment) that gets compiled by an external binary; has `program_type` enum (11 types); compiled output stored in `program.output`
- **TelemetryToken** — usage records (minutes, clicks, version) per user/license/company; records older than 60 days are purged by a Rake task

### License Lifecycle

1. User calls `POST /licenses/:id/checkout` → license is assigned to user
2. User calls `POST /licenses/:id/checkin` → license is returned
3. License validity check: non-expired AND currently checked out by the requesting user is required before program compilation

### Program Compilation

`app/helpers/programs_helper.rb` contains the core compilation logic. It shells out to external binaries located in `/vsls_compiler/bin/` (e.g., `process_eqr`, `process_ACE_LER`, `process_ALL`). Compilation is synchronous within the request.

### Authorization

Pundit policies in `app/policies/`. Two roles via Rolify:
- `:admin` — full access across all companies
- `:user` (default) — scoped to their own company's resources via Pundit policy scopes

### Authentication

Devise with `devise-jwt`. JWT tokens are blacklisted on sign-out using the `JwtBlacklist` model. Controllers that serve JSON-only endpoints are CSRF-exempt; standard Devise covers session-based web auth.

### Response Formats

Controllers respond to both HTML and JSON. Some endpoints (license checkout/checkin, telemetry) are JSON-only.

## Key Files

| File | Purpose |
|------|---------|
| `app/helpers/programs_helper.rb` | External compiler invocation logic |
| `app/policies/` | Pundit authorization policies |
| `config/routes.rb` | All endpoints (RESTful + custom actions) |
| `db/schema.rb` | Authoritative schema reference |
| `config/initializers/devise.rb` | JWT config, mailer sender |

## Environment

- Ruby 3.4.5 (see `.ruby-version`)
- PostgreSQL; dev credentials in `config/database.yml` (user: `rails`, pass: `vitalsim`)
- AWS SES for email in production/development; test env uses null mailer
- Active Storage defaults to disk; production can use S3/GCS/Azure (see `config/storage.yml`)
