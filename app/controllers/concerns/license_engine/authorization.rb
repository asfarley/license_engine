module LicenseEngine
  module Authorization
    extend ActiveSupport::Concern

    class NotAuthorized < StandardError
      attr_reader :permission, :resource

      def initialize(permission, resource = nil)
        @permission = permission
        @resource = resource
        super("Not authorized to perform #{permission.inspect}#{resource ? " on #{resource.inspect}" : ""}")
      end
    end

    included do
      helper_method :current_actor, :host_actor, :actor_company, :can_engine? if respond_to?(:helper_method)
    end

    def authenticate_engine!
      LicenseEngine.configuration.authenticate.call(self)
    end

    def host_actor
      @__license_engine_host_actor ||= LicenseEngine.configuration.current_actor.call(self)
    end

    def current_actor
      return nil unless host_actor
      @__license_engine_actor ||= LicenseEngine::Actor.for(host_actor, company: actor_company)
    end

    def actor_company
      return nil unless host_actor
      @__license_engine_actor_company ||= LicenseEngine.configuration.actor_company.call(host_actor)
    end

    def authorize_engine!(permission, resource = nil)
      raise LicenseEngine::UnknownPermission, permission unless LicenseEngine::Permissions.known?(permission)

      allowed = LicenseEngine.configuration.authorize.call(self, permission, resource)
      raise NotAuthorized.new(permission, resource) unless allowed
      true
    end

    def can_engine?(permission, resource = nil)
      return false unless LicenseEngine::Permissions.known?(permission)
      !!LicenseEngine.configuration.authorize.call(self, permission, resource)
    end
  end
end
