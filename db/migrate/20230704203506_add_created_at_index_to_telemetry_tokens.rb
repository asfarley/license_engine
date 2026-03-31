class AddCreatedAtIndexToTelemetryTokens < ActiveRecord::Migration[6.0]
  def change
    add_index :telemetry_tokens, :created_at
  end
end
