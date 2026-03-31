require "devise"
require "devise/jwt"
require "rolify"
require "pundit"

module LicenseEngine
  class Engine < ::Rails::Engine
    # Non-isolated: models/controllers live in the global namespace so the
    # host app can reference User, Company, License, etc. directly.

    initializer "license_engine.append_migrations" do |app|
      unless app.root.to_s == root.to_s
        config.paths["db/migrate"].expanded.each do |path|
          app.config.paths["db/migrate"] << path
        end
      end
    end
  end
end
