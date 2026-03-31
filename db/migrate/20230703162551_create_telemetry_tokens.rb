class CreateTelemetryTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :telemetry_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.references :license, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.integer :minutes
      t.integer :clicks

      t.timestamps
    end
  end
end
