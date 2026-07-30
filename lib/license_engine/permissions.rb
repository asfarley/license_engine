module LicenseEngine
  module Permissions
    ALL = %i[
      view_license
      issue_license
      revoke_license
      checkout_license
      checkin_license
      bulk_update_licenses

      view_company
      create_company
      update_company
      activate_company
      deactivate_company
      destroy_company

      view_telemetry
      record_telemetry
      destroy_telemetry

      view_activity
      manage_operators
    ].freeze

    def self.known?(permission)
      ALL.include?(permission)
    end
  end

  class UnknownPermission < StandardError
    def initialize(permission)
      super("Unknown LicenseEngine permission: #{permission.inspect}. Known permissions: #{Permissions::ALL.inspect}")
    end
  end
end
