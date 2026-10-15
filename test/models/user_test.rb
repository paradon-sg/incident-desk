require "test_helper"

class UserTest < ActiveSupport::TestCase
  %w[ customer agent ].each do |role|
    test "a user can save with exactly one #{role} role" do
      user = User.new(email_address: "new@example.com", password: "test-password")
      user.add_role role

      assert user.save, user.errors.full_messages.to_sentence
      assert_equal [ role ], user.reload.roles.pluck(:name)
      assert_equal role, user.role
    end
  end

  test "a user cannot save without a role" do
    user = User.new(email_address: "new@example.com", password: "test-password")

    assert_not user.save
    assert_includes user.errors[:roles], "must be exactly one of customer or agent"
  end

  test "a user cannot save with both allowed roles" do
    user = User.new(email_address: "new@example.com", password: "test-password")
    user.roles = [ roles(:customer), roles(:agent) ]

    assert_not user.save
    assert_includes user.errors[:roles], "must be exactly one of customer or agent"
  end

  test "a user cannot save with an unsupported role" do
    user = User.new(email_address: "new@example.com", password: "test-password")
    user.roles.build(name: "admin")

    assert_not user.save
    assert_not user.persisted?
  end

  test "rolify cannot add a second role to a persisted user" do
    user = users(:customer)

    assert_raises ActiveRecord::RecordNotUnique do
      user.add_role :agent
    end

    assert_equal [ "customer" ], user.reload.roles.pluck(:name)
  end
end
