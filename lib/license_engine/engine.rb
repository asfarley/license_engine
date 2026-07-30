require_relative "configuration"
require_relative "permissions"

module LicenseEngine
  class Engine < ::Rails::Engine
    isolate_namespace LicenseEngine

    # The engine reads its own routes from config/engine_routes.rb so that
    # a host mounting the engine can use `config/routes.rb` normally.
    config.paths["config/routes.rb"] = "config/engine_routes.rb"

    initializer "license_engine.append_migrations" do |app|
      unless app.root.to_s == root.to_s
        config.paths["db/migrate"].expanded.each do |path|
          app.config.paths["db/migrate"] << path
        end
      end
    end
  end
end
