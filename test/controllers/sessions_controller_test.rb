require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "the sign-in page shows the email and password form without a top bar" do
    get new_session_path

    assert_response :success
    assert_select "form[action=?]", session_path do
      assert_select "input[name=email_address]"
      assert_select "input[name=password][type=password]"
    end
    assert_select "[role=alert]", count: 0
    assert_select "header.topbar", count: 0
  end

  test "signed-in users visiting the sign-in page are sent to the ticket dashboard" do
    sign_in_as users(:customer)

    get new_session_path

    assert_redirected_to root_path
  end

  test "logging out while signed out redirects to sign in" do
    delete session_path

    assert_redirected_to new_session_path
  end

  test "signing in with valid credentials redirects to the ticket dashboard" do
    post session_path, params: { email_address: "customer@example.com", password: "password" }

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "signing in with a wrong password re-renders the form with a generic error" do
    post session_path, params: { email_address: "customer@example.com", password: "wrong" }

    assert_response :unprocessable_entity
    assert_select "[role=alert]", text: "Invalid email or password"
    assert_select "form[action=?]", session_path
  end

  test "signing in with an unknown email shows the same generic error" do
    post session_path, params: { email_address: "nobody@example.com", password: "password" }

    assert_response :unprocessable_entity
    assert_select "[role=alert]", text: "Invalid email or password"
  end

  test "logging out ends the session and protected pages require signing in again" do
    post session_path, params: { email_address: "agent@example.com", password: "password" }

    delete session_path

    assert_redirected_to new_session_path
    get root_path
    assert_redirected_to new_session_path
  end
end
