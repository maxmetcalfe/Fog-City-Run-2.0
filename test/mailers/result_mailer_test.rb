
require 'test_helper'
 
class ResultMailerTest < ActionMailer::TestCase
  test "results email" do
    email = ResultMailer.results_email(results(:one), "test@hotmail.com")
 
    assert_emails 1 do
      email.deliver_now
    end
 
    assert_equal ["runfogcity@gmail.com"], email.from
    assert_equal ["test@hotmail.com"], email.to
    assert_equal "Fog City Run Results", email.subject
    assert_equal read_fixture("result_mailer").join, email.body.to_s
  end
end