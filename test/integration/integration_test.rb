require 'test_helper'

class IntegrationTest < ActionDispatch::IntegrationTest
   test "Users can check out active licenses" do
    u1 = User.new
    u1.email = "test@test"
    u1.password = "password"
    u1.password_confirmation = "password"
    u2 = User.new
    u2.email = "test2@test"
    u2.password = "password"
    u2.password_confirmation = "password"
    c = Company.new
    l = License.new
    l.expiry_date = Date.tomorrow
    l.company = c
    u1.company = c 
    u2.company = c
    c.save
    l.save
    u1.save
    u2.save
    assert u1.free_license_is_available, "A license should be available for check-out if the date is in the future and it hasn't been checked out."
    assert u1.available_license == l 
    u1.checkout_license(l)
    assert_not u2.free_license_is_available, "A license should not be available for check-out if it's already checked out."
   end
end
