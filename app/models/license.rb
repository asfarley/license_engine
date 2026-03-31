class License < ApplicationRecord
  belongs_to :company
  belongs_to :user, optional: true
  has_many :telemetry_tokens, dependent: :nullify
  enum :license_type, { Standard: 0, Limited: 1 }

  def unexpired?
    expiry_date > Date.today
  end

  def available?
    expiry_date > Date.today && !checkedout
  end
  
  # Maintain backward compatibility
  #alias_method :valid, :valid?
  #alias_method :available, :available?

end