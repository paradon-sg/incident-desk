require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "signed-out visitors are redirected to sign in" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "signed-in agents see their email, role and a log out button in the top bar" do
    sign_in_as users(:agent)

    get root_path

    assert_response :success
    assert_select "header.topbar" do
      assert_select ".user", text: /agent@example\.com · Agent/
      assert_select "form[action=?] button", session_path, text: "Log out"
    end
  end

  test "signed-in customers see their role in the top bar" do
    sign_in_as users(:customer)

    get root_path

    assert_select "header.topbar .user", text: /customer@example\.com · Customer/
  end
end
