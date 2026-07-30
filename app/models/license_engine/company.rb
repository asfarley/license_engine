module LicenseEngine
  class Company < ApplicationRecord
    self.table_name = "license_engine_companies"

    has_many :licenses, class_name: "LicenseEngine::License", dependent: :destroy
    has_many :actors, class_name: "LicenseEngine::Actor", dependent: :nullify
    has_many :telemetry_tokens, class_name: "LicenseEngine::TelemetryToken", dependent: :nullify

    def has_valid_license
      licenses.any?(&:unexpired?)
    end

    def get_valid_license
      licenses.find(&:unexpired?)
    end

    def has_available_license
      licenses.any?(&:available?)
    end

    def get_available_license
      licenses.find(&:available?)
    end
  end
end
