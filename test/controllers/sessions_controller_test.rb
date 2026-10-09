require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:customer) }

  test "new" do
    get new_session_path

    assert_response :success
    assert_select "form[action=?]", session_path
  end

  test "create with valid credentials redirects to the dashboard" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create returns to the page the user originally asked for" do
    get root_path
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to root_url
  end

  test "create with a wrong password re-renders the form" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_response :unprocessable_entity
    assert_select ".alert-error", "Invalid email or password"
    assert_select "input[name=email_address][value=?]", @user.email_address
    assert_nil cookies[:session_id]
  end

  test "create with an unknown email re-renders the form with the same message" do
    post session_path, params: { email_address: "nobody@example.com", password: "password" }

    assert_response :unprocessable_entity
    assert_select ".alert-error", "Invalid email or password"
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(@user)

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end
end
