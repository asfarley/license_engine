Gem::Specification.new do |s|
  s.name        = "license_engine"
  s.version     = "0.2.0"
  s.authors     = ["license_engine"]
  s.summary     = "Mountable Rails engine for floating network license management"
  s.files       = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  s.add_dependency "rails", "~> 8.0"
  s.add_dependency "pg"
  s.add_dependency "jbuilder"
end
