require "application_system_test_case"

class TelemetryTokensTest < ApplicationSystemTestCase
  setup do
    @telemetry_token = telemetry_tokens(:one)
  end

  test "visiting the index" do
    visit telemetry_tokens_url
    assert_selector "h1", text: "Telemetry Tokens"
  end

  test "creating a Telemetry token" do
    visit telemetry_tokens_url
    click_on "New Telemetry Token"

    fill_in "Clicks", with: @telemetry_token.clicks
    fill_in "Company", with: @telemetry_token.company_id
    fill_in "License", with: @telemetry_token.license_id
    fill_in "Minutes", with: @telemetry_token.minutes
    fill_in "User", with: @telemetry_token.user_id
    click_on "Create Telemetry token"

    assert_text "Telemetry token was successfully created"
    click_on "Back"
  end

  test "updating a Telemetry token" do
    visit telemetry_tokens_url
    click_on "Edit", match: :first

    fill_in "Clicks", with: @telemetry_token.clicks
    fill_in "Company", with: @telemetry_token.company_id
    fill_in "License", with: @telemetry_token.license_id
    fill_in "Minutes", with: @telemetry_token.minutes
    fill_in "User", with: @telemetry_token.user_id
    click_on "Update Telemetry token"

    assert_text "Telemetry token was successfully updated"
    click_on "Back"
  end

  test "destroying a Telemetry token" do
    visit telemetry_tokens_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Telemetry token was successfully destroyed"
  end
end
