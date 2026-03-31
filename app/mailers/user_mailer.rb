class UserMailer < ApplicationMailer
  default from: 'bot@vital-sim.com'
  
  def test(email)
    mail(:to => email, :subject => "Hello World!")
  end
end
