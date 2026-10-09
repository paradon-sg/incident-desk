require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "signed-out visitors are sent to the sign-in page" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "the sign-in page has no top bar" do
    get new_session_path

    assert_select ".topbar", count: 0
  end

  test "signed-in pages show the top bar with the user's email, role, and a log out button" do
    sign_in_as users(:agent)

    get root_path

    assert_response :success
    assert_select ".topbar" do
      assert_select ".brand", "Incident Desk"
      assert_select ".user span", "agent@example.com · Agent"
      assert_select "form[action=?] button", session_path, text: "Log out"
    end
  end

  test "logging out ends the session" do
    post session_path, params: { email_address: users(:customer).email_address, password: "password" }
    get root_path
    assert_response :success

    delete session_path
    assert_redirected_to new_session_path

    get root_path
    assert_redirected_to new_session_path
  end
end
