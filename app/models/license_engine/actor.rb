module LicenseEngine
  class Actor < ApplicationRecord
    self.table_name = "license_engine_actors"

    belongs_to :company, class_name: "LicenseEngine::Company", optional: true
    has_many :licenses, class_name: "LicenseEngine::License", dependent: :nullify
    has_many :telemetry_tokens, class_name: "LicenseEngine::TelemetryToken", dependent: :nullify

    validates :external_id, presence: true
    validates :external_type, presence: true
    validates :external_id, uniqueness: { scope: :external_type }

    def self.for(host_user, company: nil)
      return nil if host_user.nil?

      external_id   = host_user.respond_to?(:id) ? host_user.id.to_s : host_user.to_s
      external_type = host_user.class.name

      actor = find_or_initialize_by(external_id: external_id, external_type: external_type)

      if company && actor.company_id != company.id
        actor.company = company
      end

      actor.save! if actor.new_record? || actor.changed?
      actor
    end

    def checkout_available_license
      license = available_license
      return nil unless license

      transaction do
        license.actor = self
        license.checkedout = true
        license.save!
        touch_checkout!
      end
      license
    end

    def free_license_is_available
      return false unless company
      company.has_available_license
    end

    def available_license
      return nil unless company
      company.get_available_license
    end

    def checkout_license(license)
      transaction do
        license.actor = self
        license.checkedout = true
        license.save!
        touch_checkout!
      end
      license
    end

    def touch_checkout!
      update!(last_checkout_time: Time.current)
    end

    def touch_checkin!
      update!(last_checkin_time: Time.current)
    end

    def last_activity_time
      [last_checkin_time, last_checkout_time].compact.max
    end

    def self.recently_active
      where.not(last_checkin_time: nil).or(where.not(last_checkout_time: nil))
        .where("GREATEST(COALESCE(last_checkin_time, '1970-01-01'), COALESCE(last_checkout_time, '1970-01-01')) > ?", 5.days.ago)
    end

    def minutes_active_this_week
      telemetry_tokens.where(created_at: 1.week.ago..Date.tomorrow).sum(:minutes)
    end

    def minutes_active_24h
      telemetry_tokens.where("created_at > ?", 24.hours.ago).sum(:minutes)
    end

    def clicks_this_week
      telemetry_tokens.where(created_at: 1.week.ago..Date.tomorrow).sum(:clicks)
    end

    def clicks_24h
      telemetry_tokens.where("created_at > ?", 24.hours.ago).sum(:clicks)
    end

    def current_application_version
      telemetry_tokens.order(created_at: :desc).first&.version || "No data"
    end
  end
end
