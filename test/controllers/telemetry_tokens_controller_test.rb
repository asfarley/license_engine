require 'test_helper'

class TelemetryTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @telemetry_token = telemetry_tokens(:one)
  end

  test "should get index" do
    get telemetry_tokens_url
    assert_response :success
  end

  test "should get new" do
    get new_telemetry_token_url
    assert_response :success
  end

  test "should create telemetry_token" do
    assert_changes -> { TelemetryToken.count }, from: TelemetryToken.count, to: TelemetryToken.count + 1 do
      post telemetry_tokens_url, params: { telemetry_token: { clicks: @telemetry_token.clicks, company_id: @telemetry_token.company_id, license_id: @telemetry_token.license_id, minutes: @telemetry_token.minutes, user_email: @telemetry_token.user.email } }
    end

    assert_redirected_to telemetry_token_url(TelemetryToken.last)
  end

  test "should show telemetry_token" do
    get telemetry_token_url(@telemetry_token)
    assert_response :success
  end

  test "should get edit" do
    get edit_telemetry_token_url(@telemetry_token)
    assert_response :success
  end

  test "should update telemetry_token" do
    patch telemetry_token_url(@telemetry_token), params: { telemetry_token: { clicks: @telemetry_token.clicks, company_id: @telemetry_token.company_id, license_id: @telemetry_token.license_id, minutes: @telemetry_token.minutes, user_id: @telemetry_token.user_id } }
    assert_redirected_to telemetry_token_url(@telemetry_token)
  end

  test "should destroy telemetry_token" do
    assert_changes -> { TelemetryToken.count }, from: TelemetryToken.count, to: TelemetryToken.count - 1 do
      delete telemetry_token_url(@telemetry_token)
    end

    assert_redirected_to telemetry_tokens_url
  end
end
