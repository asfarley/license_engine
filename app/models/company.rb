class Company < ApplicationRecord
  has_many :licenses, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :telemetry_tokens, dependent: :nullify

  def has_valid_license
    licenses.any?(&:unexpired?)
  end

  def get_valid_license
    licenses.find(&:unexpired?)
  end

  def has_available_license
    licenses.any?(&:available?)
  end

  def get_available_license
    licenses.find(&:available?)
  end

end
