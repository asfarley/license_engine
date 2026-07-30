namespace :license_engine do
  desc "Delete telemetry tokens older than 60 days"
  task delete_old_telemetry: :environment do
    LicenseEngine::TelemetryToken.where("created_at < ?", 60.days.ago).delete_all
  end

  desc "Backfill LicenseEngine::Actor records from a legacy users table"
  task backfill_actors: :environment do
    conn = ActiveRecord::Base.connection
    unless conn.table_exists?(:users)
      puts "No users table present; nothing to backfill."
      next
    end

    external_type = ENV.fetch("LICENSE_ENGINE_ACTOR_CLASS", "User")

    rows = conn.exec_query(<<~SQL)
      SELECT id, company_id, last_checkout_time, last_checkin_time
      FROM users
    SQL

    created = 0
    rows.each do |row|
      actor = LicenseEngine::Actor.find_or_initialize_by(
        external_id: row["id"].to_s,
        external_type: external_type
      )
      actor.company_id = row["company_id"] if actor.company_id.nil?
      actor.last_checkout_time ||= row["last_checkout_time"]
      actor.last_checkin_time  ||= row["last_checkin_time"]
      created += 1 if actor.new_record?
      actor.save!
    end

    puts "Backfilled #{rows.count} actors (#{created} new)."

    remap_fk = ->(table, column) do
      next unless conn.column_exists?(table, column)
      rows_remap = conn.exec_query("SELECT DISTINCT #{column} FROM #{table} WHERE #{column} IS NOT NULL")
      rows_remap.each do |r|
        legacy_id = r[column.to_s]
        actor = LicenseEngine::Actor.find_by(external_id: legacy_id.to_s, external_type: external_type)
        next unless actor
        conn.execute(
          "UPDATE #{table} SET #{column} = #{actor.id} WHERE #{column} = #{legacy_id.to_i} AND #{column} != #{actor.id}"
        )
      end
    end

    remap_fk.call("license_engine_licenses", "actor_id")
    remap_fk.call("license_engine_telemetry_tokens", "actor_id")

    puts "Remapped legacy user_id references to actor_id."
  end
end
