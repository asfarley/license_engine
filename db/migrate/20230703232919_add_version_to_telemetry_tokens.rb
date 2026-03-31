class AddVersionToTelemetryTokens < ActiveRecord::Migration[6.0]
  def change
    add_column :telemetry_tokens, :version, :string
  end
end
