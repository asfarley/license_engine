Gem::Specification.new do |s|
  s.name        = "license_engine"
  s.version     = "0.1.0"
  s.authors     = ["license_engine"]
  s.summary     = "Mountable Rails engine for floating network license management"
  s.files       = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  s.add_dependency "rails", "~> 8.0"
  s.add_dependency "devise"
  s.add_dependency "devise-jwt"
  s.add_dependency "rolify"
  s.add_dependency "pundit"
  s.add_dependency "pg"
  s.add_dependency "jbuilder"
end
