class User < ApplicationRecord
  rolify
  after_create :assign_default_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable,
  :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  belongs_to :company, optional: true
  has_many :licenses, through: :company
  has_many :telemetry_tokens, dependent: :nullify

  def checkout_available_license
    license = available_license
    checkout_license license if license
    self.last_checkout_time = DateTime.now
    self.save
    license.user_id = id
    license.save
    license
  end

  def free_license_is_available
    licenses.any?{ |l| l.available? }
  end

  def available_license
    licenses.find(&:available?)
  end

  def checkout_license(license)
    license.user = self
    license.checkedout = true
    license.save
  end

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  def last_activity_time
    return nil if last_checkin_time.nil? && last_checkout_time.nil?
    [last_checkin_time, last_checkout_time].compact.max
  end

  def self.recently_active_users
    User.where.not(last_checkin_time: nil).or(User.where.not(last_checkout_time: nil))
        .where("GREATEST(COALESCE(last_checkin_time, '1970-01-01'), COALESCE(last_checkout_time, '1970-01-01')) > ?", 5.days.ago)
  end

  def minutes_active_this_week
    telemetry_tokens.where(created_at: 1.week.ago..Date.tomorrow).sum(:minutes)
  end

  def minutes_active_24h
    telemetry_tokens.where('created_at > ?', 24.hours.ago).sum(:minutes)
  end

  def clicks_this_week
    telemetry_tokens.where(created_at: 1.week.ago..Date.tomorrow).sum(:clicks)
  end

  def clicks_24h
    telemetry_tokens.where('created_at > ?', 24.hours.ago).sum(:clicks)
  end

  def current_application_version
    latest_token = telemetry_tokens.order(created_at: :desc).first
    latest_token&.version || "No data"
  end

  def company_name
    company&.name || "User not assigned to company"
  end


end
