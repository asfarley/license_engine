# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

company1 = Company.create! name: 'Example Corp'
company2 = Company.create! name: 'Admin Org'

License.create! name: 'L01', company: company1, license_type: 0, expiry_date: 1.year.from_now
License.create! name: 'L02', company: company2, license_type: 0, expiry_date: 1.year.from_now
License.create! name: 'L03', company: company2, license_type: 0, expiry_date: 1.year.from_now

user1 = User.create! email: 'user@example.com', password: 'changeme',
                     password_confirmation: 'changeme', company: company1

admin1 = User.create! email: 'admin@example.com', password: 'changeme',
                      password_confirmation: 'changeme', company: company2
admin1.add_role :admin
