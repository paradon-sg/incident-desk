require "test_helper"
require "rake"

Rails.application.load_tasks unless Rake::Task.task_defined?("users:create")

class UsersTaskTest < ActiveSupport::TestCase
  %w[ customer agent ].each do |role|
    test "users:create creates a #{role} with the supplied password" do
      output, errors = capture_io do
        assert_difference "User.count", 1 do
          create_user(email: "new@example.com", role: role)
        end
      end

      user = User.find_by!(email_address: "new@example.com")
      assert user.authenticate("task-test-password")
      assert_equal [ role ], user.roles.pluck(:name)
      assert_equal "Created #{role} new@example.com.\n", output
      assert_empty errors
    end
  end

  test "users:create rejects an invalid role without creating a user" do
    output, errors = capture_io do
      assert_no_difference [ "User.count", "Role.count" ] do
        error = assert_raises(SystemExit) { create_user(email: "new@example.com", role: "admin") }
        assert_equal 1, error.status
      end
    end

    assert_empty output
    assert_match 'Invalid role "admin". ROLE must be one of: customer, agent.', errors
  end

  test "users:create rejects a duplicate normalized email without changing the user" do
    user = users(:customer)
    original_attributes = user.attributes

    output, errors = capture_io do
      assert_no_difference "User.count" do
        error = assert_raises(SystemExit) { create_user(email: " CUSTOMER@EXAMPLE.COM ", role: "agent") }
        assert_equal 1, error.status
      end
    end

    assert_empty output
    assert_match "Could not create user: Email address has already been taken.", errors
    assert_equal original_attributes, user.reload.attributes
    assert_equal [ "customer" ], user.roles.pluck(:name)
  end

  private
    # Invoke the real rake task with isolated environment values and invocation state.
    def create_user(email:, role:)
      original_environment = ENV.to_h.slice("EMAIL", "ROLE", "PASSWORD")
      ENV.update("EMAIL" => email, "ROLE" => role, "PASSWORD" => "task-test-password")
      task = Rake::Task["users:create"]
      task.reenable
      task.invoke
    ensure
      %w[ EMAIL ROLE PASSWORD ].each { |key| ENV.delete(key) }
      ENV.update(original_environment)
      task&.reenable
    end
end
