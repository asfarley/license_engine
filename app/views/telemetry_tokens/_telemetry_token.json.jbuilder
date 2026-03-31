json.extract! telemetry_token, :id, :user_id, :license_id, :company_id, :minutes, :clicks, :created_at, :updated_at
json.url telemetry_token_url(telemetry_token, format: :json)
