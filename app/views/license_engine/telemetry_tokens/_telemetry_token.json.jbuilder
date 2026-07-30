json.extract! telemetry_token, :id, :actor_id, :license_id, :company_id, :minutes, :clicks, :version, :created_at, :updated_at
json.url telemetry_token_url(telemetry_token, format: :json)
