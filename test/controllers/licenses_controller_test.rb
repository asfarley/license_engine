require 'test_helper'

class LicensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @license = licenses(:one)
  end

  test "should get index" do
    get licenses_url
    assert_response :success
  end

  test "should get new" do
    get new_license_url
    assert_response :success
  end

  test "should create license" do
    assert_changes -> { License.count }, from: License.count, to: License.count + 1 do
      post licenses_url, params: { license: { company_id: @license.company_id, name: @license.name, license_type: @license.license_type } }
    end

    assert_redirected_to license_url(License.last)
  end

  test "should show license" do
    get license_url(@license)
    assert_response :success
  end

  test "should get edit" do
    get edit_license_url(@license)
    assert_response :success
  end

  test "should update license" do
    patch license_url(@license), params: { license: { company_id: @license.company_id, name: @license.name, license_type: @license.license_type } }
    assert_redirected_to license_url(@license)
  end

  test "should destroy license" do
    assert_changes -> { License.count }, from: License.count, to: License.count - 1 do
      delete license_url(@license)
    end

    assert_redirected_to licenses_url
  end
end
