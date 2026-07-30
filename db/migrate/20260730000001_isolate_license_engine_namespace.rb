class IsolateLicenseEngineNamespace < ActiveRecord::Migration[8.0]
  def up
    rename_table :companies, :license_engine_companies if table_exists?(:companies)
    rename_table :licenses,  :license_engine_licenses  if table_exists?(:licenses)
    rename_table :telemetry_tokens, :license_engine_telemetry_tokens if table_exists?(:telemetry_tokens)

    if table_exists?(:license_engine_licenses)
      if column_exists?(:license_engine_licenses, :user_id) && !column_exists?(:license_engine_licenses, :actor_id)
        rename_column :license_engine_licenses, :user_id, :actor_id
      end

      if foreign_key_exists?(:license_engine_licenses, column: :actor_id)
        remove_foreign_key :license_engine_licenses, column: :actor_id
      end
    end

    if table_exists?(:license_engine_telemetry_tokens)
      if column_exists?(:license_engine_telemetry_tokens, :user_id) && !column_exists?(:license_engine_telemetry_tokens, :actor_id)
        rename_column :license_engine_telemetry_tokens, :user_id, :actor_id
      end

      if foreign_key_exists?(:license_engine_telemetry_tokens, column: :actor_id)
        remove_foreign_key :license_engine_telemetry_tokens, column: :actor_id
      end
    end
  end

  def down
    rename_table :license_engine_companies, :companies if table_exists?(:license_engine_companies)
    rename_table :license_engine_licenses, :licenses if table_exists?(:license_engine_licenses)
    rename_table :license_engine_telemetry_tokens, :telemetry_tokens if table_exists?(:license_engine_telemetry_tokens)

    if table_exists?(:licenses) && column_exists?(:licenses, :actor_id)
      rename_column :licenses, :actor_id, :user_id
    end

    if table_exists?(:telemetry_tokens) && column_exists?(:telemetry_tokens, :actor_id)
      rename_column :telemetry_tokens, :actor_id, :user_id
    end
  end
end
