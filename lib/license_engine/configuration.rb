module LicenseEngine
  class NotConfigured < StandardError; end

  class Configuration
    FAIL_CLOSED_AUTHENTICATE = ->(_controller) {
      raise NotConfigured, "LicenseEngine.authenticate is not configured. " \
        "Set it in an initializer with LicenseEngine.configure { |c| c.authenticate = ->(controller) { controller.authenticate_user! } }"
    }

    FAIL_CLOSED_CURRENT_ACTOR = ->(_controller) {
      raise NotConfigured, "LicenseEngine.current_actor is not configured. " \
        "Set it in an initializer with LicenseEngine.configure { |c| c.current_actor = ->(controller) { controller.current_user } }"
    }

    FAIL_CLOSED_AUTHORIZE = ->(_controller, _permission, _resource) { false }

    FAIL_CLOSED_ACTOR_COMPANY = ->(_host_actor) {
      raise NotConfigured, "LicenseEngine.actor_company is not configured. " \
        "Return the host user's company so the engine can scope license operations."
    }

    attr_accessor :authenticate, :current_actor, :authorize, :actor_company

    def initialize
      @authenticate  = FAIL_CLOSED_AUTHENTICATE
      @current_actor = FAIL_CLOSED_CURRENT_ACTOR
      @authorize     = FAIL_CLOSED_AUTHORIZE
      @actor_company = FAIL_CLOSED_ACTOR_COMPANY
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
