require "test_helper"
require "rake"

class UsersRakeTest < ActiveSupport::TestCase
  setup do
    unless Rake::Task.task_defined?("users:create")
      Rake::Task.define_task(:environment)
      load Rails.root.join("lib/tasks/users.rake")
    end
    Rake::Task["users:create"].reenable
  end

  test "creates a user with the given email, password, and role" do
    out, _err = run_task({ "EMAIL" => "new@example.com", "PASSWORD" => "secret123", "ROLE" => "agent" })

    user = User.find_by!(email_address: "new@example.com")
    assert_equal "agent", user.role
    assert user.authenticate("secret123")
    assert_match "Created agent new@example.com", out
  end

  test "rejects an invalid role" do
    _out, err = run_task({ "EMAIL" => "new@example.com", "PASSWORD" => "secret123", "ROLE" => "admin" }, fails: true)

    assert_match "Role must be one of: customer, agent", err
    assert_nil User.find_by(email_address: "new@example.com")
  end

  test "rejects a duplicate email" do
    _out, err = run_task({ "EMAIL" => users(:customer).email_address, "PASSWORD" => "secret123", "ROLE" => "customer" }, fails: true)

    assert_match "Email address has already been taken", err
  end

  test "requires a password when not running in a terminal" do
    _out, err = run_task({ "EMAIL" => "new@example.com", "ROLE" => "customer" }, fails: true)

    assert_match "PASSWORD is required", err
  end

  private
    def run_task(env, fails: false)
      previous = %w[ EMAIL PASSWORD ROLE ].index_with { |key| ENV[key] }
      %w[ EMAIL PASSWORD ROLE ].each { |key| ENV[key] = env[key] }

      capture_io do
        with_stdin(StringIO.new) do
          if fails
            assert_raises(SystemExit) { Rake::Task["users:create"].invoke }
          else
            Rake::Task["users:create"].invoke
          end
        end
      end
    ensure
      previous.each { |key, value| ENV[key] = value }
    end

    def with_stdin(io)
      original, $stdin = $stdin, io
      yield
    ensure
      $stdin = original
    end
end
