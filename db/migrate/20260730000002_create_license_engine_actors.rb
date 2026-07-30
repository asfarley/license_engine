class CreateLicenseEngineActors < ActiveRecord::Migration[8.0]
  def change
    create_table :license_engine_actors do |t|
      t.string :external_id,   null: false
      t.string :external_type, null: false
      t.references :company, foreign_key: { to_table: :license_engine_companies }
      t.datetime :last_checkout_time
      t.datetime :last_checkin_time
      t.timestamps
    end

    add_index :license_engine_actors, [:external_type, :external_id], unique: true, name: "index_license_engine_actors_on_external"

    if table_exists?(:license_engine_licenses) && column_exists?(:license_engine_licenses, :actor_id)
      add_foreign_key :license_engine_licenses, :license_engine_actors, column: :actor_id
    end

    if table_exists?(:license_engine_telemetry_tokens) && column_exists?(:license_engine_telemetry_tokens, :actor_id)
      add_foreign_key :license_engine_telemetry_tokens, :license_engine_actors, column: :actor_id
    end
  end
end
