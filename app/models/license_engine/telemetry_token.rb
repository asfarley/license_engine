module LicenseEngine
  class TelemetryToken < ApplicationRecord
    self.table_name = "license_engine_telemetry_tokens"

    belongs_to :actor, class_name: "LicenseEngine::Actor", optional: true
    belongs_to :license, class_name: "LicenseEngine::License", optional: true
    belongs_to :company, class_name: "LicenseEngine::Company", optional: true
  end
end
