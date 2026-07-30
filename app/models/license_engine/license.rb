module LicenseEngine
  class License < ApplicationRecord
    self.table_name = "license_engine_licenses"

    belongs_to :company, class_name: "LicenseEngine::Company"
    belongs_to :actor, class_name: "LicenseEngine::Actor", optional: true
    has_many :telemetry_tokens, class_name: "LicenseEngine::TelemetryToken", dependent: :nullify

    enum :license_type, { Standard: 0, Limited: 1 }

    def unexpired?
      expiry_date && expiry_date > Date.today
    end

    def available?
      unexpired? && !checkedout
    end
  end
end
