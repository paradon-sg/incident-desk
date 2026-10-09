require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "creates a user with a role" do
    user = User.create!(email_address: "new@example.com", password: "password", role: "agent")

    assert_equal "agent", user.reload.role
    assert user.has_role?(:agent)
  end

  test "requires a known role" do
    user = User.new(email_address: "new@example.com", password: "password", role: "admin")

    assert_not user.valid?
    assert_includes user.errors.full_messages, "Role must be one of: customer, agent"
  end

  test "requires a role" do
    user = User.new(email_address: "new@example.com", password: "password")

    assert_not user.valid?
    assert user.errors.of_kind?(:role, :inclusion)
  end

  test "changing the role replaces the previous one" do
    user = users(:customer)

    user.update!(role: "agent")

    assert_equal [ "agent" ], user.reload.roles.map(&:name)
  end

  test "requires a unique email address" do
    user = User.new(email_address: "Customer@Example.com", password: "password", role: "customer")

    assert_not user.valid?
    assert user.errors.of_kind?(:email_address, :taken)
  end

  test "requires a valid email address" do
    user = User.new(email_address: "not-an-email", password: "password", role: "customer")

    assert_not user.valid?
    assert user.errors.of_kind?(:email_address, :invalid)
  end
end
