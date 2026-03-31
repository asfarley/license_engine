class JwtBlacklist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  # Rails 8 prefers explicit table names
  self.table_name = 'jwt_blacklist'
end
