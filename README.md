# License Engine

A mountable Rails engine for managing floating network licenses. Provides:

- Company and license management (create, assign, activate/deactivate)
- License checkout/checkin lifecycle
- Role-based access control (admin vs. user) via Rolify and Pundit
- JWT authentication integration via Devise
- Telemetry token collection (usage minutes, clicks, version tracking)

The engine does not include Devise itself. It integrates with the host application's Devise user model, auto-detected from `Devise.mappings` or configurable via `LicenseServer.user_class_name`.
