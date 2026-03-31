require "application_system_test_case"

class JwtBlacklistsTest < ApplicationSystemTestCase
  setup do
    @jwt_blacklist = jwt_blacklists(:one)
  end

  test "visiting the index" do
    visit jwt_blacklists_url
    assert_selector "h1", text: "Jwt Blacklists"
  end

  test "creating a Jwt blacklist" do
    visit jwt_blacklists_url
    click_on "New Jwt Blacklist"

    fill_in "Exp", with: @jwt_blacklist.exp
    fill_in "Jti", with: @jwt_blacklist.jti
    click_on "Create Jwt blacklist"

    assert_text "Jwt blacklist was successfully created"
    click_on "Back"
  end

  test "updating a Jwt blacklist" do
    visit jwt_blacklists_url
    click_on "Edit", match: :first

    fill_in "Exp", with: @jwt_blacklist.exp
    fill_in "Jti", with: @jwt_blacklist.jti
    click_on "Update Jwt blacklist"

    assert_text "Jwt blacklist was successfully updated"
    click_on "Back"
  end

  test "destroying a Jwt blacklist" do
    visit jwt_blacklists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Jwt blacklist was successfully destroyed"
  end
end
