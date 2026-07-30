# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A **mountable, isolated Rails engine** (`LicenseEngine::`) that manages
floating network licenses for desktop applications. The engine is
namespace-isolated (`isolate_namespace LicenseEngine`) — models,
controllers, views, and tables all live under the `LicenseEngine::` prefix.

The engine does **not** own authentication, users, roles, or session
management. Those are host-application concerns. The engine defines a
fixed permission vocabulary and calls host-supplied callbacks to
authenticate the request and authorize each protected action.

## Configuration API

Hosts wire the engine in a Rails initializer:

```ruby
LicenseEngine.configure do |config|
  config.authenticate  = ->(controller) { controller.authenticate_user! }
  config.current_actor = ->(controller) { controller.current_user }
  config.actor_company = ->(host_user) { host_user&.company }
  config.authorize     = ->(controller, permission, resource) do
    PermissionPolicy.new(controller.current_user).can?(permission)
  end
end
```

Every callback fails **closed** if unset — `authenticate` and `current_actor`
raise `LicenseEngine::NotConfigured`, `authorize` returns false, and
protected actions raise `LicenseEngine::Authorization::NotAuthorized`.

## Permission vocabulary

The engine defines permissions, not roles. See
`lib/license_engine/permissions.rb`. Controllers call
`authorize_engine!(:permission, resource=nil)`. Views call
`can_engine?(:permission)`.

Current verbs: `view_license`, `issue_license`, `revoke_license`,
`checkout_license`, `checkin_license`, `bulk_update_licenses`,
`view_company`, `create_company`, `update_company`, `activate_company`,
`deactivate_company`, `destroy_company`, `view_telemetry`,
`record_telemetry`, `destroy_telemetry`, `view_activity`,
`manage_operators`.

Hosts map their own roles to these verbs via a `PermissionPolicy` (or
equivalent).

## Domain

- `LicenseEngine::Company` — license-holding organization
- `LicenseEngine::License` — floating license owned by a company; can be checked out by one actor at a time; `license_type` enum (`Standard`/`Limited`)
- `LicenseEngine::Actor` — engine-owned mapping from an opaque host actor (`external_type` + `external_id`) to a company; carries `last_checkout_time` and `last_checkin_time`
- `LicenseEngine::TelemetryToken` — usage records (minutes, clicks, version) per actor/license/company

`LicenseEngine::Actor.for(host_user, company:)` finds or creates the
engine-side actor record from any host object that responds to `#id`.

## License lifecycle

1. `POST /licenses/:id/checkout` — actor claims the license (permission: `checkout_license`)
2. `POST /licenses/:id/checkin`  — actor returns the license (permission: `checkin_license`)
3. `GET  /licenses/validate`     — returns whether the actor's company has a valid unexpired license

## Tables

All engine tables carry the `license_engine_` prefix:

- `license_engine_companies`
- `license_engine_licenses`  (has `actor_id` referencing `license_engine_actors`, not `user_id`)
- `license_engine_actors`
- `license_engine_telemetry_tokens`

## Not owned by the engine

- No `User` model, no `devise`, `devise-jwt`, `rolify`, `pundit` gems
- No `SessionsController`, `RegistrationsController`, `UsersController`
- No `JwtBlacklist`, `Role`
- No devise views or locales
- No initializers for auth

## Key files

| File | Purpose |
|------|---------|
| `lib/license_engine/configuration.rb`     | Callback API + fail-closed defaults |
| `lib/license_engine/permissions.rb`       | Fixed permission vocabulary |
| `app/controllers/concerns/license_engine/authorization.rb` | `authenticate_engine!` / `current_actor` / `authorize_engine!` |
| `app/models/license_engine/actor.rb`      | Engine-owned actor record |
| `config/routes.rb`                        | Engine routes |
| `db/migrate/*isolate_license_engine_namespace.rb` | Renames tables to `license_engine_*` |
| `db/migrate/*create_license_engine_actors.rb`     | Creates the actors table |

## Environment

- Ruby 3.4.5
- Rails 8, PostgreSQL

## Testing standalone

The engine ships a full Rails app under `config/` for standalone dev/test.
Boot with `foreman start -f Procfile.dev` from the repo root; you will
need to provide your own auth callbacks in a local initializer.
