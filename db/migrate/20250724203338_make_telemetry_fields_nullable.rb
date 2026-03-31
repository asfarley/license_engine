class MakeTelemetryFieldsNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :telemetry_tokens, :user_id, true
    change_column_null :telemetry_tokens, :license_id, true
    change_column_null :telemetry_tokens, :company_id, true
  end
end
